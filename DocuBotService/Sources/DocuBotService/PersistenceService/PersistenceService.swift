//
//  PersistenceService.swift
//
//
//  Created by William Lumley on 8/12/2023.
//

import Foundation

public protocol PersistenceService: Service {

    func getCodebases() async throws -> [CodebaseRecord]

}
