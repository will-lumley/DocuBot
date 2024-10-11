//
//  PrintLogService.swift
//  
//
//  Created by William Lumley on 25/9/2023.
//

import Foundation

class PrintLogService: LogService {

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
        // swiftlint:disable:next direct_print
        print("[DOCUBOT] \(type.name) \(string)")
    }

}
