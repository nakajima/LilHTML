//
//  Node.swift
//
//
//  Created by Pat Nakajima on 5/2/24.
//

import Foundation

public protocol Node: AnyObject, Equatable, CustomDebugStringConvertible {
	var position: Int { get set }
	var parent: ElementNode? { get set }
	var textContent: String { get }
	func same(as: any Node) -> Bool
}

public extension Node {
	var toHTML: String {
		switch self {
		case let elem as ElementNode:
			var parts = ["<\(elem.tagName.lowercased())"]

			if !elem.attributes.isEmpty {
				var attrs: [String] = []
				parts.append(" ")
				for (name, value) in elem.attributes {
					attrs.append("\(name)=\"\(value)\"")
				}
				parts.append(attrs.joined(separator: " "))
			}

			parts.append(">")

			for child in elem.childNodes {
				parts.append(child.toHTML)
			}

			parts.append("</\(elem.tagName.lowercased())>")
			return parts.joined(separator: "")
		case let text as TextNode:
			return text.textContent
		default:
			return ""
		}
	}

	var innerHTML: String {
		return switch self {
		case let elem as ElementNode:
			elem.childNodes.map(\.toHTML).joined()
		case let text as TextNode:
			text.textContent
		default:
			""
		}
	}

	var nextSibling: (any Node)? {
		guard let parent else {
			return nil
		}

		if position + 1 < parent.childNodes.count {
			return parent.childNodes[position + 1]
		} else {
			return nil
		}
	}

	var prevSibling: (any Node)? {
		guard let parent else {
			return nil
		}

		if position - 1 >= 0 {
			return parent.childNodes[position - 1]
		} else {
			return nil
		}
	}

	var nextElementSibling: ElementNode? {
		guard let parent else {
			return nil
		}

		for childNode in parent.childNodes where childNode.position > position {
			if let result = childNode as? ElementNode {
				return result
			}
		}

		return nil
	}

	func replace(with replacement: any Node) {
		if let parent {
			parent.childNodes[position] = replacement.remove()
		}
	}

	@discardableResult func remove() -> Self {
		if let parent {
			parent.removeChild(self)
		}

		return self
	}

	func `is`(_ tagNames: TagName...) -> Bool {
		self.is(tagNames)
	}

	func `is`(_ tagNames: [TagName]) -> Bool {
		guard let elem = self as? ElementNode else {
			return false
		}

		for name in tagNames {
			assert(!name.rawValue.contains(","), "tag names must not contain commas")
			if elem.tagName == name {
				return true
			}
		}

		return false
	}
}
