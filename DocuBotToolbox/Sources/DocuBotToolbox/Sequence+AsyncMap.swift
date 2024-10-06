//
//  Sequence+AsyncMap.swift
//  DocuBotToolbox
//
//  Created by William Lumley on 6/10/2024.
//


/// Special thanks to
/// https://www.swiftbysundell.com/articles/async-and-concurrent-forEach-and-map/
/// for the code.
/// 
public extension Sequence {

    func asyncMap<T>(
        _ transform: (Element) async throws -> T
    ) async rethrows -> [T] {
        var values = [T]()

        for element in self {
            try await values.append(transform(element))
        }

        return values
    }

}
