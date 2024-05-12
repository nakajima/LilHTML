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

	enum CodingKeys: CodingKey {
		case tagName, attributes, childNodes, position
	}

	public init(from decoder: any Decoder) throws {
		print("decoding from container \(Date())")

		let container = try decoder.container(keyedBy: CodingKeys.self)

		self.tagName = try container.decode(TagName.self, forKey: .tagName)
		self.attributes = try container.decode([String: String].self, forKey: .attributes)
		self.position = try container.decode(Int.self, forKey: .position)

		let childNodesWithType = try container.decode([MutableNodeType?].self, forKey: .childNodes)
		let childNodes: [any MutableNode] = childNodesWithType.compactMap { child in
			switch child {
			case let .element(elem):
				print(elem.debugDescription)
				return elem
			case let .text(text):
				print(text.debugDescription)
				return text
			default:
				return nil
			}
		}

		for node in childNodes {
			node.parent = self
		}

		self.childNodes = childNodes
	}

	public func immutableCopy(shallow: Bool = false) -> ImmutableElementNode {
		let children: [any Node] = shallow ? [] : childNodes.compactMap { node in
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

	func replace(with replacement: any MutableNode) {
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
		childNodes.remove(at: node.position)
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
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(tagName, forKey: .tagName)
		try container.encode(attributes, forKey: .attributes)
		try container.encode(position, forKey: .position)

		print("encoding to container \(self)")

		let typedChildNodes = (childNodes as! [any MutableNode]).map(\.type)
		try container.encode(typedChildNodes, forKey: .childNodes)
	}
}
