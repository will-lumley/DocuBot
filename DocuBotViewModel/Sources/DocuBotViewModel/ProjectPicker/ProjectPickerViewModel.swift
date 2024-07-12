//
//  ProjectPickerViewModel.swift
//
//
//  Created by William Lumley on 4/7/2024.
//

import Foundation

public class ProjectPickerViewModel: ObservableObject {

    // MARK: - Properties

    let foo: String

    // MARK: - Lifecycle

    public init(foo: String) {
        self.foo = foo
    }

}

// MARK: - Preview

public extension ProjectPickerViewModel {

    static var mock: ProjectPickerViewModel {
        .init(foo: "fii")
    }

}
