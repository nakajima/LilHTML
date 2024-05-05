//
//  ParserDelegate.swift
//
//
//  Created by Pat Nakajima on 5/2/24.
//

import Foundation

class ParserDelegate: NSObject, XMLParserDelegate {
	public var rootNode: ElementNode?
	public var currentNode: ElementNode?
	public var error: (any Error)?
	public var result: Result<ElementNode, any Error>?

	enum ParseError: Error {
		case didNotGetRootElement
	}

	func parser(_: XMLParser, didStartElement elementName: String, namespaceURI _: String?, qualifiedName _: String?, attributes: [String: String] = [:]) {
		let node = ElementNode(tagName: TagName(rawValue: elementName.uppercased()) ?? .custom)
		node.attributes = attributes

		if let currentNode {
			currentNode.appendChild(node)
		} else {
			rootNode = node
		}

		currentNode = node
	}

	func parser(_: XMLParser, didEndElement _: String, namespaceURI _: String?, qualifiedName _: String?) {
		currentNode = currentNode?.parent
	}

	func parser(_: XMLParser, foundCharacters: String) {
		if let currentNode {
			let textNode = TextNode(textContent: foundCharacters)
			currentNode.appendChild(textNode)
		}
	}

	func parser(_: XMLParser, parseErrorOccurred parseError: any Error) {
		error = parseError
	}

	func parserDidEndDocument(_: XMLParser) {
		if let rootNode {
			result = .success(rootNode)
		} else {
			result = .failure(ParseError.didNotGetRootElement)
		}
	}
}
