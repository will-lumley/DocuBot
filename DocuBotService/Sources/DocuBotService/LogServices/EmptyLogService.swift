//
//  EmptyLogService.swift
//  
//
//  Created by William Lumley on 26/9/2023.
//

import Foundation

class EmptyLogService: LogService {

    // MARK: - Service

    static var key: ServiceKey {
        .log
    }

    // MARK: - Lifecycle

    init() {
        // Intentionally left blank.
    }

    // MARK: - LogService

    func log(with type: LogType, _ string: String) {
        // Intentionally left blank.
    }

}
