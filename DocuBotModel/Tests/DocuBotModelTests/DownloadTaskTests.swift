//
//  DownloadTaskTests.swift
//  DocuBotModel
//
//  Created by William Lumley on 17/11/2024.
//

import Combine
@testable import DocuBotModel
import Foundation
import Testing

@Suite("DownloadTaskTests")
struct DownloadTaskTests {

    // MARK: - Properties

    private let destinationByteSize = 3908
    private let testURL: URL
    private let testDestinationURL: URL

    // MARK: - Lifecycle

    init() throws {
        let urlStr = "https://s28.q4cdn.com/392171258/files/doc_downloads/test.pdf"
        self.testURL = try #require(URL(string: urlStr))
        self.testDestinationURL = try #require(Self.getDownloadDirectory())
    }

    // MARK: - Tests

    @Test("Download")
    func download() async throws {
        // GIVEN we start off a download task
        let task = DownloadTask(
            sourceURL: self.testURL,
            destinationURL: self.testDestinationURL,
            onUpdatedPublisher: .init(nil)
        )

        // WHEN we try and download the data
        let destination = try await task.download()

        // THEN the URL should look right
        #expect(destination.path().contains("/TestModels/test.pdf"))

        // THEN we should be able to get the data representation of it
        let data = try Data(contentsOf: destination)

        // THEN we should have downloaded all the right amount of bytes
        #expect(data.count == destinationByteSize)
    }

    @Test("Failed Download")
    func failedDownload() async throws {
        // GIVEN we start off a download task with an invalid URL
        let invalidURL = try #require(URL(string: "invalid-url"))
        let task = DownloadTask(
            sourceURL: invalidURL,
            destinationURL: self.testDestinationURL,
            onUpdatedPublisher: .init(nil)
        )

        // WHEN we try and download something
        // THEN we get an error thrown
        await #expect(throws: Error.self) {
            try await task.download()
        }
    }

    @Test("Update Publisher")
    func updatePublisher() async throws {
        var cancellables: Set<AnyCancellable> = []

        let publisher = CurrentValueSubject<DownloadTask.Progress?, Never>(nil)

        // GIVEN we start off a download task
        let task = DownloadTask(
            sourceURL: self.testURL,
            destinationURL: self.testDestinationURL,
            onUpdatedPublisher: publisher
        )

        // WHEN we try and download the data
        _ = try await task.download()

        // THEN we should receive updates from our publisher
        await withCheckedContinuation { continuation in
            publisher
                .sink { _ in
                    // THEN we should get updates on our progress
                    continuation.resume()
                }
                .store(in: &cancellables)
        }
    }

}

// MARK: - Private

private extension DownloadTaskTests {

    static func getDownloadDirectory() -> URL? {
        // Firstly, we want to move our model from our temp URL
        // to our AppSupport directory
        let fileManager = FileManager.default

        guard let appSupportDirectory = fileManager.urls(
            for: .applicationSupportDirectory,
            in: .userDomainMask
        ).first else {
            return nil
        }

        // Define the "Models" subdirectory within AppSupport
        let modelsDirectory = appSupportDirectory
            .appendingPathComponent("DocuBot/TestModels", isDirectory: true)

        // Create the "Models" subdirectory if it doesn’t already exist
        do {
            if fileManager.fileExists(atPath: modelsDirectory.path(percentEncoded: false)) == false {
                try fileManager.createDirectory(
                    at: modelsDirectory,
                    withIntermediateDirectories: true
                )
            }
        } catch {
            return nil
        }

        return modelsDirectory
    }
}
