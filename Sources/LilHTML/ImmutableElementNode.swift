//
//  ImmutableElementNode.swift
//
//
//  Created by Pat Nakajima on 5/11/24.
//

import Foundation

@propertyWrapper
public enum Indirect<T: Codable & Sendable & Equatable & Hashable>: Codable, Sendable, Equatable, Hashable {
	indirect case wrapped(T)

	public var wrappedValue: T {
		get { switch self { case let .wrapped(x): return x } }
		set { self = .wrapped(newValue) }
	}
}

public struct ImmutableElementNode: ImmutableNode, Element, @unchecked Sendable {
	public let tagName: TagName
	public let attributes: [String: String]
	public var childNodes: [any Node] = []
	@Indirect public var parent: ImmutableElementNode?
	public let position: Int

	public init(
		tagName: TagName,
		attributes: [String: String] = [:],
		childNodes: [any Node],
		parent: ImmutableElementNode?,
		position: Int
	) {
		self.tagName = tagName
		self.attributes = attributes
		self.childNodes = childNodes
		self._parent = .wrapped(parent)
		self.position = position
	}

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
		let container = try decoder.container(keyedBy: CodingKeys.self)

		self.tagName = try container.decode(TagName.self, forKey: .tagName)
		self.attributes = try container.decode([String: String].self, forKey: .attributes)
		self.position = try container.decode(Int.self, forKey: .position)

		let childNodesWithType = try container.decode([ImmutableNodeType?].self, forKey: .childNodes)
		let childNodes: [any ImmutableNode] = childNodesWithType.compactMap { child in
			switch child {
			case let .element(elem):
				return elem
			case let .text(text):
				return text
			default:
				return nil
			}
		}

		self._parent = .wrapped(nil)

		self.childNodes = childNodes.map { node in
			switch node {
			case let node as ImmutableElementNode:
				node.with(parent: self)
			case let node as ImmutableTextNode:
				node.with(parent: self)
			default:
				node
			}
		}
	}

	public func with(parent: ElementType) -> ImmutableElementNode {
		var copy = self
		copy.parent = parent
		return copy
	}
}

extension ImmutableElementNode: Encodable {
	public func encode(to encoder: any Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(tagName, forKey: .tagName)
		try container.encode(attributes, forKey: .attributes)
		try container.encode(position, forKey: .position)

		let typedChildNodes = (childNodes as! [any ImmutableNode]).map(\.type)
		try container.encode(typedChildNodes, forKey: .childNodes)
	}
}
