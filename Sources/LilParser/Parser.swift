//
//  Parser.swift
//
//
//  Created by Pat Nakajima on 5/2/24.
//

import Foundation
import LilTidy

public struct Parser {
	var html: String
//	var delegate: ParserDelegate

	public init(html: String) {
		self.html = html
	}

	public func parse() throws -> Result<ElementNode, any Error>? {
		let cleaned = try LilTidy.clean(html, options: [
			"add-xml-space": "yes",
			"output-html": "no",
			"output-xhtml": "yes",
			"output-xml": "no",
			"quote-nbsp": "no",
			"logical-emphasis": "yes", // Use strong instead of b and em instead of i
			"wrap": "0",
			"force-output": "yes",
			"tidy-mark": "no",
			"drop-empty-elements": "no"
		])

		let delegate = ParserDelegate()
		let xmlparser = XMLParser(data: Data(cleaned.utf8))
		xmlparser.delegate = delegate
		xmlparser.parse()

		return delegate.result
	}
}
