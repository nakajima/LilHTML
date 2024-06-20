//
//  MutableElementNode.swift
//
//
//  Created by Pat Nakajima on 5/2/24.
//

import Foundation

public final class MutableElementNode: Hashable, Decodable, MutableNode, Element {
	public var tagName: TagName
	public var attributes: [String: String] = [:]
	public var childNodes: [any Node] = []
	public weak var parent: MutableElementNode?
	public var position: Int = -1

	public func hash(into hasher: inout Hasher) {
		hasher.combine(tagName)
		hasher.combine(attributes)
		hasher.combine(childNodes.map(\.hashValue))
		hasher.combine(position)
	}

	public init(from decoder: any Decoder) throws {
		print("decoding from container \(Date())")

		let container = try decoder.singleValueContainer()
		let html = try container.decode(String.self)

		let node = try HTML(html: html).parse().get()

		self.tagName = node.tagName
		self.attributes = node.attributes
		self.position = node.position
		self.childNodes = node.childNodes
	}

	public func immutableCopy(shallow: Bool = false) -> ImmutableElementNode {
		let children: [any ImmutableNode] = shallow ? [] : childNodes.compactMap { node in
			switch node {
			case let elem as MutableElementNode:
				return elem.immutableCopy()
			case let text as MutableTextNode:
				return text.immutableCopy()
			default:
				return nil
			}
		}

		return ImmutableElementNode(
			tagName: tagName,
			attributes: attributes,
			childNodes: children,
			parent: parent?.immutableCopy(shallow: true),
			position: position
		)
	}

	public func replace<Replacement: MutableNode>(with replacement: Replacement) {
		if let parent {
			parent.childNodes[position] = replacement.remove()
		}
	}

	@discardableResult public func remove() -> Self {
		if let parent {
			parent.removeChild(self)
		}

		return self
	}

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

	public func appendChild(_ node: any MutableNode) {
		node.remove()
		node.parent = self
		node.position = childNodes.count
		childNodes.append(node)
	}

	public func removeChild(_ node: any MutableNode) {
		if childNodes.indices.contains(node.position) {
			childNodes.remove(at: node.position)
		}

		node.position = -1
		setPositions()
	}

	public func recursiveCopy() -> MutableElementNode {
		let copy = MutableElementNode(tagName: tagName)

		for (name, value) in attributes {
			copy[name] = value
		}

		for child in childNodes {
			if let textNode = child as? MutableTextNode {
				copy.appendChild(textNode.copy())
			} else if let elemNode = child as? MutableElementNode {
				copy.appendChild(elemNode.recursiveCopy())
			}
		}

		return copy
	}

	private func setPositions() {
		// Reset position
		for (newPosition, child) in childNodes.enumerated() {
			let child = child as! any MutableNode
			child.position = newPosition
		}
	}
}

extension MutableElementNode: Encodable {
	public func encode(to encoder: any Encoder) throws {
		var container = encoder.singleValueContainer()
		try container.encode(toHTML())
	}
}
