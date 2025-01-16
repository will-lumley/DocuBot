//
//  Progress.swift
//  DocuBotToolbox
//
//  Created by William Lumley on 22/10/2024.
//

/// A structure representing progress with a value and a total, providing percentage calculations.
public struct Progress: Hashable, Sendable {

    // MARK: - Properties

    /// The current progress value.
    public let value: Double

    /// The total value representing 100% progress.
    public let total: Double

    // MARK: - Lifecycle

    /// Creates a new instance of `Progress`.
    ///
    /// - Parameters:
    ///   - value: The current progress value.
    ///   - total: The total value representing 100% progress.
    public init(value: Double, total: Double) {
        self.value = value
        self.total = total
    }
}

// MARK: - Public

public extension Progress {

    /// The progress expressed as a percentage.
    ///
    /// This property calculates the percentage of progress by dividing the `value` by the `total`
    /// and multiplying the result by 100.
    ///
    /// - Returns: A `Double` representing the progress percentage.
    var percentage: Double {
        value / total * 100
    }

}
