//
//  HTML.swift
//
//
//  Created by Pat Nakajima on 5/2/24.
//

import Foundation
import libxml2

enum ParserError: Error {
	case noRootElement
}

extension UnsafePointer<xmlChar> {
	var string: String {
		String(cString: self)
	}
}

extension UnsafeMutablePointer<xmlChar> {
	var string: String {
		String(cString: self)
	}
}

class Parser {
	let htmlDocument: htmlDocPtr

	init(html: String) throws {
		let options = Int32(
			HTML_PARSE_RECOVER.rawValue |
				HTML_PARSE_NOERROR.rawValue |
				HTML_PARSE_NOWARNING.rawValue |
				HTML_PARSE_NOIMPLIED.rawValue
		)

		let cString = html.utf8CString
		let cStringCount = cString.count
		self.htmlDocument = cString.withUnsafeBytes {
			htmlReadMemory($0.baseAddress, Int32(cStringCount), nil, "", options)
		}
	}

	func parse() throws -> (any MutableNode)? {
		let root = xmlDocGetRootElement(htmlDocument).pointee

		return traverse(node: root, parent: nil)
	}

	func traverse(node xmlNode: xmlNode, parent: MutableElementNode?) -> (any MutableNode)? {
		guard let name = xmlNode.name?.string else {
			return nil
		}

		// If it's a text node, there won't be any children or attributes so just return
		if name == "text" {
			let node = MutableTextNode(textContent: xmlNode.content.string)
			node.parent = parent
			return node
		}

		let node = MutableElementNode(.from(name))

		// Get attributes
		var attributes: [String: String] = [:]
		var property = xmlNode.properties
		while let currentProperty = property?.pointee {
			let attrName = currentProperty.name.string
			let attrValue = xmlNodeListGetString(htmlDocument, currentProperty.children, 1)
			defer { xmlFree(attrValue) }

			attributes[attrName] = attrValue?.string ?? ""

			property = currentProperty.next
		}

		node.attributes = attributes

		// Recurse through children
		var position = 0
		var child = xmlNode.children
		while let currentChild = child?.pointee {
			if let childNode = traverse(node: currentChild, parent: node) {
				childNode.position = position
				node.appendChild(childNode)
			}

			position += 1
			child = currentChild.next
		}

		return node
	}

	deinit {
		xmlFreeDoc(htmlDocument)
	}
}

public struct HTML {
	var html: String

	public init(html: String) {
		self.html = html
	}

	public init(html: Data) {
		self.html = String(data: html, encoding: .utf8)!
	}

	public func parse() throws -> Result<MutableElementNode, any Error> {
		let parser = try Parser(html: html)
		return Result { try parser.parse() as! MutableElementNode }
	}
}
