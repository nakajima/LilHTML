//
//  HTML.swift
//
//
//  Created by Pat Nakajima on 5/2/24.
//

import Foundation
#if canImport(FoundationXML)
	import FoundationXML
#endif

public struct HTML {
	var html: Data

	static func escape(_ html: String) -> String {
		var result = ""
		var inTag = false

		for character in html {
			switch character {
			case "<":
				inTag = true
				result.append(character)
			case ">":
				inTag = false
				result.append(character)
			case "&":
				if inTag {
					result.append(character)
				} else {
					result.append("&amp;")
				}
			default:
				result.append(character)
			}
		}

		return result
	}

	public static func unescape(_ html: String) -> String {
		var newString = html
		let htmlEntities: [String: String] = [
			"&quot;": "\"",
			"&apos;": "'",
			"&lt;": "<",
			"&gt;": ">",
			"&amp;": "&",
		]

		for (key, value) in htmlEntities {
			newString = newString.replacingOccurrences(of: key, with: value)
		}

		return newString
	}

	public init(html: String) {
		self.html = Data(HTML.escape(html).utf8)
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
