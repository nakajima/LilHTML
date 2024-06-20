//
//  Node.swift
//
//
//  Created by Pat Nakajima on 5/2/24.
//

import Foundation

public protocol Node: Hashable, Codable, Equatable, CustomDebugStringConvertible {
	associatedtype ElementType: Element

	var position: Int { get }
	var parent: ElementType? { get }
	var textContent: String { get }
	func same(as: any Node) -> Bool
}

public extension Node {
	func toHTML(includeWhitespace: Bool = false) -> String {
		switch self {
		case let elem as ElementType:
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
				parts.append(child.toHTML(includeWhitespace: includeWhitespace))
			}

			parts.append("</\(elem.tagName.lowercased())>")
			return parts.joined(separator: "")
		case let text as any TextNode:
			if text.textContent.trimmingCharacters(in: .whitespacesAndNewlines) != "" || includeWhitespace {
				return HTML.escape(text.textContent)
			} else {
				return ""
			}
		default:
			return ""
		}
	}

	var innerHTML: String {
		return switch self {
		case let elem as ElementType:
			elem.childNodes.map { $0.toHTML() }.joined()
		case let text as MutableTextNode:
			text.textContent
		default:
			""
		}
	}

	var nextElementSibling: ElementType? {
		guard let parent else {
			return nil
		}

		for childNode in parent.childNodes where childNode.position > position {
			if let result = childNode as? ElementType {
				return result
			}
		}

		return nil
	}

	func `is`(_ tagNames: TagName...) -> Bool {
		self.is(tagNames)
	}

	func `is`(_ tagNames: [TagName]) -> Bool {
		guard let elem = self as? any Element else {
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

public extension Node where Self: MutableNode {
	var nextSibling: (any MutableNode)? {
		guard let parent else {
			return nil
		}

		if position + 1 < parent.childNodes.count {
			return parent.childNodes[position + 1] as? any MutableNode
		} else {
			return nil
		}
	}

	var prevSibling: (any MutableNode)? {
		guard let parent else {
			return nil
		}

		if position - 1 >= 0 {
			return parent.childNodes[position - 1] as? any MutableNode
		} else {
			return nil
		}
	}
}

public extension Node where Self: ImmutableNode {
	var nextSibling: (any ImmutableNode)? {
		guard let parent else {
			return nil
		}

		if position + 1 < parent.childNodes.count {
			return parent.childNodes[position + 1] as? any ImmutableNode
		} else {
			return nil
		}
	}

	var prevSibling: (any ImmutableNode)? {
		guard let parent else {
			return nil
		}

		if position - 1 >= 0 {
			return parent.childNodes[position - 1] as? any ImmutableNode
		} else {
			return nil
		}
	}
}
