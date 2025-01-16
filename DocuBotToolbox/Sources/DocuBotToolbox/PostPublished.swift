//
//  PostPublished.swift
//  
//
//  Created by William Lumley on 2/9/2024.
//

import Combine
import Foundation

@propertyWrapper
public struct PostPublished<Value> {

    // MARK: - Properties

    private var value: Value
    public let subject = PassthroughSubject<Value, Never>()

    public var wrappedValue: Value {
        get {
            value
        }
        set {
            value = newValue
            subject.send(value)
        }
    }

    public var projectedValue: AnyPublisher<Value, Never> {
        subject.eraseToAnyPublisher()
    }

    // MARK: - Lifecycle

    public init(wrappedValue: Value) {
        self.value = wrappedValue
    }
}

// MARK: - AnyPublisher

extension AnyPublisher where Failure == Never {

    func assign(to published: Reference<PostPublished<Output>>) -> AnyCancellable {
        return self.sink { value in
            published.value.wrappedValue = value
        }
    }

}

class Reference<T> {
    var value: T

    init(_ value: T) {
        self.value = value
    }
}
