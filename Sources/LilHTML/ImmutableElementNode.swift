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
		childNodes: [any ImmutableNode],
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
		let container = try decoder.singleValueContainer()
		let html = try container.decode(String.self)

		let node = try HTML(html: html).parse().get()

		self._parent = .wrapped(nil)
		self.tagName = node.tagName
		self.attributes = node.attributes
		self.position = node.position
		self.childNodes = node.childNodes
	}

	public func mutableCopy(shallow: Bool = true) -> MutableElementNode {
		let node = MutableElementNode(
			tagName: tagName
		)

		node.parent = parent?.mutableCopy()
		node.attributes = attributes
		node.position = position
		node.childNodes = childNodes.compactMap { node in
			switch node {
			case let elem as ImmutableElementNode:
				return elem.mutableCopy()
			case let text as ImmutableTextNode:
				return text.mutableCopy()
			default:
				return nil
			}
		}

		return node
	}

	public func with(parent: ElementType) -> ImmutableElementNode {
		var copy = self
		copy.parent = parent
		return copy
	}
}

extension ImmutableElementNode: Encodable {
	public func encode(to encoder: any Encoder) throws {
		var container = encoder.singleValueContainer()
		try container.encode(toHTML())
	}
}
