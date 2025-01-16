//
//  LogService.swift
//
//
//  Created by William Lumley on 1/7/2023.
//

import Foundation

public protocol LogService: Service {
    func log(with type: LogType, _ string: String)
}
