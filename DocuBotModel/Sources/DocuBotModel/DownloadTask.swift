//
//  DownloadTask.swift
//  DocuBotModel
//
//  Created by William Lumley on 7/11/2024.
//

@preconcurrency import Combine
import DocuBotToolbox
import Foundation

/// A class that encapsulates a downloadable task with progress tracking and async/await support.
///
/// The `DownloadTask` uses `URLSession` to perform network downloads while providing real-time
/// progress updates and seamless integration with Swift's async/await syntax.
public final class DownloadTask: NSObject, @unchecked Sendable {

    // MARK: - Types

    /// A type alias for progress updates during the download process.
    public typealias Progress = DocuBotToolbox.Progress

    // MARK: - Properties

    /// A publisher that emits progress updates for the download task.
    ///
    /// Subscribers can listen to this publisher to track the current status of the download operation.
    public let onUpdatedPublisher: CurrentValueSubject<Progress?, Never>

    /// The source URL from which the data is being downloaded.
    public let sourceURL: URL

    /// The destination URL where the downloaded data will be saved.
    private let destinationURL: URL

    /// A continuation used to integrate async/await syntax with the download process.
    private var continuation: CheckedContinuation<URL, Error>?

    /// The `URLSession` instance used to perform the network activity.
    private var session: URLSession!

    /// The `URLSessionDownloadTask` instance responsible for managing the actual download operation.
    private var sessionDownloadTask: URLSessionDownloadTask?

    // MARK: - Lifecycle

    /// Creates a new instance of `DownloadTask`.
    ///
    /// - Parameters:
    ///   - sourceURL: The URL from which the data will be downloaded.
    ///   - destinationURL: The URL where the downloaded data will be saved.
    ///   - onUpdatedPublisher: A publisher for progress updates during the download operation.
    public init(
        sourceURL: URL,
        destinationURL: URL,
        onUpdatedPublisher: CurrentValueSubject<Progress?, Never>
    ) {
        self.sourceURL = sourceURL
        self.destinationURL = destinationURL
        self.onUpdatedPublisher = onUpdatedPublisher

        super.init()

        self.session = .init(
            configuration: .default,
            delegate: self,
            delegateQueue: OperationQueue()
        )
    }

}

// MARK: - Public

public extension DownloadTask {

    /// Starts the download operation.
    ///
    /// This method initiates the download of data from the `sourceURL` to the `destinationURL`.
    /// It integrates with Swift's async/await syntax and supports error handling.
    ///
    /// - Returns: The final destination URL of the downloaded file.
    /// - Throws: An error if the download fails.
    func download() async throws -> URL {
        try await withCheckedThrowingContinuation { continuation in
            self.continuation = continuation
            let request = URLRequest(url: self.sourceURL)

            self.sessionDownloadTask = session.downloadTask(with: request)
            self.sessionDownloadTask?.delegate = self
            self.sessionDownloadTask?.resume()
        }
    }
}

// MARK: - URLSessionDownloadDelegate

extension DownloadTask: URLSessionDownloadDelegate {

    /// Called periodically to provide progress updates during the download.
    ///
    /// Updates are sent to the `onUpdatedPublisher` with the current progress.
    public func urlSession(
        _ session: URLSession,
        downloadTask: URLSessionDownloadTask,
        didWriteData bytesWritten: Int64,
        totalBytesWritten: Int64,
        totalBytesExpectedToWrite: Int64
    ) {
        let value = Double(totalBytesWritten)
        let total = Double(totalBytesExpectedToWrite)

        Task { @MainActor in
            let progress = Progress(value: value, total: total)
            self.onUpdatedPublisher.send(progress)
        }
    }

    /// Called when the download finishes and the file is written to a temporary location.
    ///
    /// The file is moved to the `destinationURL`, and the continuation is resumed.
    public func urlSession(
        _ session: URLSession,
        downloadTask: URLSessionDownloadTask,
        didFinishDownloadingTo location: URL
    ) {
        do {
            let fileManager = FileManager.default

            let destination = destinationURL
                .appendingPathComponent(self.sourceURL.lastPathComponent)

            // Copy the file from the temp location to the destination URL
            // and ensure it's not already there.
            if fileManager.fileExists(atPath: destination.path) {
                try fileManager.removeItem(at: destination)
            }
            try fileManager.copyItem(at: location, to: destination)

            // Resume continuation with the destination URL
            self.continuation?.resume(returning: destination)
        } catch {
            // Resume continuation with the error if the operation fails
            self.continuation?.resume(throwing: error)
        }

        // Clear the continuation to prevent reuse
        self.continuation = nil
    }

    /// Called when the download task completes, either successfully or with an error.
    ///
    /// If an error occurred, the continuation is resumed with the error.
    public func urlSession(
        _ session: URLSession,
        task: URLSessionTask,
        didCompleteWithError error: (any Error)?
    ) {
        if let error = error {
            self.continuation?.resume(throwing: error)
            self.continuation = nil
        }
    }
}
