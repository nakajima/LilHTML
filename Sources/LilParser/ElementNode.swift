//
//  ElementNode.swift
//
//
//  Created by Pat Nakajima on 5/2/24.
//

import Foundation

public class ElementNode: Node {
	public var tagName: TagName
	public var attributes: [String: String] = [:]
	public var childNodes: [any Node] = []
	public weak var parent: ElementNode?
	public var position: Int = -1

	public var metadata: [String: Any] = [:]

	private var childNodesByTagName: [String: [any Node]] = [:]

	public init(_ tagName: TagName) {
		self.tagName = tagName
	}

	public init(tagName: TagName) {
		self.tagName = tagName
	}

	public subscript(_ index: String) -> String? {
		get {
			attributes[index]
		}

		set {
			attributes[index] = newValue
		}
	}

	public var firstChild: (any Node)? {
		childNodes.first
	}

	public var lastChild: (any Node)? {
		childNodes.last
	}

	public var firstElementChild: ElementNode? {
		for childNode in childNodes {
			if let childElement = childNode as? ElementNode {
				return childElement
			}
		}

		return nil
	}

	public var childElements: [ElementNode] {
		childNodes.compactMap { $0 as? ElementNode }
	}

	public func first(_ tagName: TagName) -> ElementNode? {
		for child in childNodes {
			guard let child = child as? ElementNode else {
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

	public func recursiveElementChildren() -> [ElementNode] {
		var result: [ElementNode] = [self]

		for child in childElements {
			result.append(contentsOf: child.recursiveElementChildren())
		}

		return result
	}

	public func find(_ tagNames: TagName...) -> [ElementNode] {
		find(tagNames)
	}

	public func find(attributes: [String: String]) -> [ElementNode] {
		var result: [ElementNode] = []

		for childNode in childElements {
			if attributes.allSatisfy({ (name, value) in
				childNode[name] == value
			}) {
				result.append(childNode)
			}

			result.append(contentsOf: childNode.find(attributes: attributes))
		}

		return result
	}

	public func find(_ tagNames: [TagName]) -> [ElementNode] {
		var result: [ElementNode] = []

		for childNode in childElements {
			if childNode.is(tagNames) {
				result.append(childNode)
			}

			result.append(contentsOf: childNode.find(tagNames))
		}

		return result
	}

	public func appendChild(_ node: any Node) {
		node.remove()
		node.parent = self
		node.position = childNodes.count
		childNodes.append(node)
	}

	public func removeChild(_ node: any Node) {
		childNodes.remove(at: node.position)
		node.position = -1
		setPositions()
	}

	public func recursiveCopy() -> ElementNode {
		let copy = ElementNode(tagName: tagName)

		for (name, value) in attributes {
			copy[name] = value
		}

		for child in childNodes {
			if let textNode = child as? TextNode {
				copy.appendChild(textNode.copy())
			} else if let elemNode = child as? ElementNode {
				copy.appendChild(elemNode.recursiveCopy())
			}
		}

		return copy
	}

	private func setPositions() {
		// Reset position
		for (newPosition, child) in childNodes.enumerated() {
			child.position = newPosition
		}
	}
}
