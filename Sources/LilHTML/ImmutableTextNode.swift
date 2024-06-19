//
//  ImmutableTextNode.swift
//
//
//  Created by Pat Nakajima on 5/11/24.
//

import Foundation

public struct ImmutableTextNode: Hashable, Codable, ImmutableNode, TextNode {
	public var parent: ImmutableElementNode?
	public var textContent: String
	public var position: Int

	public static func == (lhs: Self, rhs: ImmutableTextNode) -> Bool {
		lhs.textContent == rhs.textContent
	}

	public static func == (lhs: Self, rhs: any Node) -> Bool {
		lhs.same(as: rhs)
	}

	public func same(as other: any Node) -> Bool {
		if let other = other as? MutableTextNode {
			return textContent == other.textContent
		}

		return false
	}

	public func with(parent: ElementType) -> ImmutableTextNode {
		var copy = self
		copy.parent = parent
		return copy
	}
}
