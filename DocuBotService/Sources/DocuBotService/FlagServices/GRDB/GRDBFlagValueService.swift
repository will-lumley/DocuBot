//
//  GRDBFlagValueService.swift
//
//
//  Created by William Lumley on 7/11/2023.
//

import Combine
import DocuBotToolbox
import Foundation
import GRDB
import Vexil

public final class GRDBFlagValueService {

    // MARK: - Properties

    private var database: DatabaseReader & DatabaseWriter

    private lazy var encoder: JSONEncoder = {
        JSONEncoder()
    }()

    private lazy var decoder: JSONDecoder = {
        JSONDecoder()
    }()

    public var databasePath: String {
        database.path
    }

    private let queue = DispatchQueue(label: "grdb-flag-value-notifications")

    private var cache = [String: Flag]()

    // MARK: - Lifecycle

    public init() {
        let fileManager = FileManager.default

        guard let containerURL = fileManager.containerURL(
            forSecurityApplicationGroupIdentifier: Secrets.BundleIDs.appGroup
        ) else {
            fatalError("Failed to create ContainerURL")
        }

        // Create a full file path to the database in the shared container
        let databasePath = containerURL
            .appendingPathComponent("flags")
            .appendingPathExtension("db")
            .path()

        // If the file does not exist, create it
        if fileManager.fileExists(atPath: databasePath) == false {
            let foo = fileManager.createFile(atPath: databasePath, contents: nil)
            print("Foo: \(foo)")

            let str = "Hello, World!"
            let strData = str.data(using: .utf8)!
            let url = URL(string: databasePath)!

            do {
                try strData.write(to: url)
            } catch {
                print("error: \(error)")
            }
        }

        // Create our database
        do {
            self.database = try DatabasePool(path: databasePath, configuration: .init())

            // Make sure our flag values are up to date
            try self.migrate(database: database)

            loadCache()
        } catch {
            fatalError("Failed to launch GRDBFlagValueService: \(error)")
        }
    }

}

// MARK: - FlagValueSource

extension GRDBFlagValueService: FlagValueSource {

    public var name: String {
        "GRDB"
    }

    public func flagValue<Value>(key: String) -> Value? where Value: FlagValue {
        cache[key]
            .flatMap { try? decoder.decode(BoxedFlagValue.self, from: $0.value) }
            .flatMap { Value(boxedFlagValue: $0) }
    }

    public func setFlagValue<Value>(_ value: Value?, key: String) throws where Value: FlagValue {
        try database.write { [weak self] db in
            guard let self else {
                return
            }
            if let value = value {
                let flag = Flag(key: key, value: try encoder.encode(value.boxedFlagValue))
                try flag.save(db)
                cache[key] = flag

            } else {
                try Flag.deleteOne(db, key: key)
                cache.removeValue(forKey: key)
            }
        }
    }

    public func valuesDidChange(keys: Set<String>) -> AnyPublisher<Set<String>, Never>? {
        changedKeys()
            .handleEvents(
                receiveOutput: { [weak self] keys in
                    self?.loadCache(keys: keys)
                }
            )
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

}

// MARK: - Private

private extension GRDBFlagValueService {

    func loadCache(keys: Set<String> = []) {
        do {
            let flags = try database.read { db -> [String: Flag] in
                let query: QueryInterfaceRequest<Flag>
                if keys.isEmpty {
                    query = Flag.all()
                } else {
                    query = Flag.filter(keys: keys)
                }

                let cursor = try query.fetchCursor(db)
                return try cursor.reduce(into: [String: Flag]()) { result, flag in
                    result[flag.key] = flag
                }
            }

            if keys.isEmpty {
                cache = flags
            } else {
                for key in keys {
                    if let flag = flags[key] {
                        cache[key] = flag
                    } else {
                        cache.removeValue(forKey: key)
                    }
                }
            }
        } catch {
            fatalError("Failed to load flags from GRDB: \(error)")
        }
    }

    func changedKeys() -> AnyPublisher<Set<String>, Never> {
        ValueObservation.tracking { db -> [Row] in
            let request = Flag.select(Flag.Columns.key, Flag.Columns.hashValue)
            return try Row.fetchAll(db, request)
        }
            .publisher(in: database, scheduling: .async(onQueue: queue))
            .mapFlagHashes()
            .withPreviousValue()
            .filterChangedFlags()
            .map { flags in
                Set(flags.keys)
            }
            .catch { error -> AnyPublisher<Set<String>, Never> in
                fatalError("Unhandled Error: \(error)")
            }
            .eraseToAnyPublisher()
    }

}

// MARK: - Publisher

private extension Publisher {

    func withPreviousValue() -> AnyPublisher<(oldValue: Output?, value: Output), Failure> {
        scan((nil, nil)) { ($0.1, $1) }
            .map { (oldValue: $0.0, value: $0.1!) }
            .eraseToAnyPublisher()
    }

}

private extension Publisher where Output == [Row] {

    func mapFlagHashes() -> Publishers.Map<Self, [String: Int]> {
        self
            .map { flags -> [String: Int] in
                let array = flags.compactMap { row -> (String, Int)? in
                    guard
                        let key = String.fromDatabaseValue(row[GRDBFlagValueService.Flag.Columns.key.name]),
                        let hash = Int.fromDatabaseValue(row[GRDBFlagValueService.Flag.Columns.hashValue.name])
                    else {
                        return nil
                    }
                    return (key, hash)
                }

                return Dictionary(uniqueKeysWithValues: array)
            }
    }

}

private extension Publisher where Output == (oldValue: [String: Int]?, value: [String: Int]) {

    /// Compares two sets of flag hashes and returns only those that have changed
    func filterChangedFlags() -> Publishers.Map<Self, [String: Int]> {
        self
            .map { previous, updated in
                guard let previous = previous else {
                    return updated
                }
                return updated.filter { previous[$0.key] != $0.value }
            }
    }

}
