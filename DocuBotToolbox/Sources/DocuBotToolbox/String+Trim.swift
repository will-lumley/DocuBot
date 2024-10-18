//
//  String+Trim.swift
//  DocuBotToolbox
//
//  Created by William Lumley on 16/10/2024.
//

public extension String {

    func trim(by length: Int) -> String {
        if self.count > length {
            let index = self.index(self.startIndex, offsetBy: length)
            return String(self[..<index])
        } else {
            return self
        }
    }

}
