//
//  Initial.swift
//
//
//  Created by William Lumley on 18/6/2024.
//

import GRDB

struct Initial: DatabaseMigration {

    var identifier: String {
        "0001_Initial"
    }

    func perform(db: Database) {
        let foo = 4
        print("Foo: \(foo)")
    }

}

