//
//  HTML.swift
//
//
//  Created by Pat Nakajima on 5/2/24.
//

import Foundation

public struct HTML {
	var html: Data

	public init(html: String) {
		self.html = Data(html.utf8)
	}

	public init(html: Data) {
		self.html = html
	}

	public func parse() throws -> Result<MutableElementNode, any Error> {
		let delegate = ParserDelegate()
		let xmlparser = XMLParser(data: html)
		xmlparser.delegate = delegate
		xmlparser.parse()

		if let error = delegate.error {
			return .failure(error)
		}

		guard let result = delegate.result else {
			return .failure(ParserDelegate.ParseError.didNotGetResult)
		}

		return result
	}
}
