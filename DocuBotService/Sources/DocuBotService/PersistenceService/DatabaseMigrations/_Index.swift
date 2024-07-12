//
//  Index.swift
//
//
//  Created by William Lumley on 2/7/2024.
//

import Foundation

struct Index {

    static var migrations: [any DatabaseMigration] {
        [
            Initial()
        ]
    }

}
