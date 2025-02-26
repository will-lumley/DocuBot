//
//  llama_batch.swift
//  DocuBotService
//
//  Created by William Lumley on 26/2/2025.
//

import Foundation
import llama

extension llama_batch {

    mutating func clear() {
        self.n_tokens = 0
    }

}
