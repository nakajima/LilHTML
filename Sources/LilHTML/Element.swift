//
//  Element.swift
//
//
//  Created by Pat Nakajima on 5/11/24.
//

import Foundation

public protocol Element: Node {
	var tagName: TagName { get }
	var attributes: [String: String] { get }
	var childNodes: [any Node] { get }
	var parent: Self? { get }
	var position: Int { get }
}

public extension Element {
	subscript(_ index: String) -> String? {
		attributes[index]
	}

	var textContent: String {
		childNodes.map(\.textContent).joined()
	}

	var firstElementChild: Self? {
		for childNode in childNodes {
			if let childElement = childNode as? Self {
				return childElement
			}
		}

		return nil
	}

	var childElements: [Self] {
		childNodes.compactMap { $0 as? Self }
	}

	func first(_ tagName: TagName) -> Self? {
		for child in childNodes {
			guard let child = child as? Self else {
				continue
			}

			if child.is(tagName) {
				return child
			}

			if let first = child.first(tagName) {
				return first
			}
		}

		return nil
	}

	func recursiveElementChildren() -> [Self] {
		var result: [Self] = [self]

		for child in childElements {
			result.append(contentsOf: child.recursiveElementChildren())
		}

		return result
	}

	func find(_ tagNames: TagName..., in parent: [TagName] = []) -> [Self] {
		if parent.isEmpty {
			return find(tagNames)
		} else {
			return find(parent).flatMap { $0.find(tagNames) }
		}
	}

	func find(attributes: [String: AttributeValue]) -> [Self] {
		var result: [Self] = []

		for childNode in childElements {
			if attributes.allSatisfy({ name, value in
				value.matches(value: childNode[name])
			}) {
				result.append(childNode)
			}

			result.append(contentsOf: childNode.find(attributes: attributes))
		}

		return result
	}

	func search(_ segments: SelectarSegment...) -> [Self] {
		search(segments)
	}

	func search<T: Node & Element>(node: T, segments: [SelectarSegment]) -> [T] {
		var result: [T] = []
		var segments = segments
		let originalSegments = segments

		guard let segment = segments.popLast() else {
			return []
		}

		if segment.matches(node) {
			// We've got a match, let's see if we keep matching...
			if segments.isEmpty {
				// We're done, we can add it to the result
				result.append(node)
			} else {
				// We have more to match
				for child in node.childElements {
					result.append(contentsOf: search(node: child, segments: segments))
				}
			}
		} else {
			for child in node.childElements {
				result.append(contentsOf: search(node: child, segments: originalSegments))
			}
		}

		return result
	}

	func search(_ segments: [SelectarSegment]) -> [Self] {
		let segments = Array(segments.reversed())
		return search(node: self, segments: segments)
	}

	func find(_ tagNames: [TagName]) -> [Self] {
		var result: [Self] = []

		for childNode in childElements {
			if childNode.is(tagNames) {
				result.append(childNode)
			}

			result.append(contentsOf: childNode.find(tagNames))
		}

		return result
	}
}

extension Element where ElementType == ImmutableElementNode {
	var firstChild: (any ImmutableNode)? {
		(childNodes as! [any ImmutableNode]).first
	}

	var lastChild: (any ImmutableNode)? {
		(childNodes as! [any ImmutableNode]).last
	}
}

extension Element where ElementType == MutableElementNode {
	var firstChild: (any MutableNode)? {
		(childNodes as! [any MutableNode]).first
	}

	var lastChild: (any MutableNode)? {
		(childNodes as! [any MutableNode]).last
	}
}
