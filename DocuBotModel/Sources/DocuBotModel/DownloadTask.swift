//
//  DownloadTask.swift
//  DocuBotModel
//
//  Created by William Lumley on 7/11/2024.
//

@preconcurrency import Combine
import DocuBotToolbox
import Foundation

public final class DownloadTask: NSObject, @unchecked Sendable {

    // MARK: - Types

    public typealias Progress = DocuBotToolbox.Progress

    // MARK: - Properties

    /// Our progress publisher that clients can use to listen to the status of the download
    public let onUpdatedPublisher: CurrentValueSubject<Progress?, Never>

    /// The URL that this task is downloading data from
    public let sourceURL: URL

    /// The URL that we'll copy this data to, once downloaded
    private let destinationURL: URL

    /// The continuation we'll be using to conform to async/await syntax
    private var continuation: CheckedContinuation<URL, Error>?

    /// The underlying `URLSession` that we'll be using to perform the network activity
    private var session: URLSession!

    /// The underlying `URLSessionDownloadTask` that we'll be using to download the data
    private var sessionDownloadTask: URLSessionDownloadTask?

    // MARK: - Lifecycle

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

// MARK: - Private

private extension DownloadTask {

}

// MARK: - URLSessionDelegate

extension DownloadTask: URLSessionDownloadDelegate {

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

    public func urlSession(
        _ session: URLSession,
        downloadTask: URLSessionDownloadTask,
        didFinishDownloadingTo location: URL
    ) {
        do {
            let fileManager = FileManager.default

            // Copy the file from the temp location to the destination URL
            if fileManager.fileExists(atPath: destinationURL.path) {
                try fileManager.removeItem(at: destinationURL)
            }
            try fileManager.copyItem(at: location, to: destinationURL)

            // Return the continuation with the destination URL
            self.continuation?.resume(returning: destinationURL)
        } catch {
            // Throw the error if we find one
            self.continuation?.resume(throwing: error)
        }

        // Clear the continuation to avoid reuse
        self.continuation = nil
    }

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

// MARK: - URLSessionDelegate

extension DownloadTask: URLSessionDelegate {

}
