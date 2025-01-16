//
//  DocumentParser+ExtractContent.swift
//  DocuBotModel
//
//  Created by William Lumley on 13/1/2025.
//

import Foundation
import PDFKit

extension DocumentParser {

    func loadPlainText(from url: URL) throws(ContentExtractionError) -> String {
        // Extract the documents content directly as a string file
        guard let content = try? String(contentsOf: url, encoding: .utf8) else {
            throw .failedToReadContent
        }
        return content
    }

    func loadDocumentText(
        from url: URL,
        with documentType: NSAttributedString.DocumentType
    ) throws (ContentExtractionError) -> String {
        // Load the data from the file
        guard let data = try? Data(contentsOf: url) else {
            throw .failedToReadFile
        }

        guard let attrStr = try? NSAttributedString(
            data: data,
            options: [.documentType: documentType],
            documentAttributes: nil
        ) else {
            throw .failedToReadContent
        }

        return attrStr.string
    }

    func loadPdf(from url: URL) throws (ContentExtractionError) -> String {
        guard let pdf = PDFDocument(url: url), let pdfStr = pdf.string else {
            throw .failedToReadContent
        }

        return pdfStr

    }

}
