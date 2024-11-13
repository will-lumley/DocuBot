//
//  _Index+Tests.swift
//  DocuBotService
//
//  Created by William Lumley on 13/11/2024.
//

@testable import DocuBotService
import Testing

struct IndexTests {

    @Test("Migations Array")
    func migrationsArray() {
        #expect(Index.migrations.count == 1)
    }

}
