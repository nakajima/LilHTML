//
//  ImmutableNode.swift
//
//
//  Created by Pat Nakajima on 5/11/24.
//

import Foundation

public enum ImmutableNodeType: Codable {
	case element(ImmutableElementNode), text(ImmutableTextNode)
}

public protocol ImmutableNode: Sendable, Node {
	func with(parent: ElementType) -> Self
}

public extension ImmutableNode {
	var type: ImmutableNodeType? {
		switch self {
		case let elem as ImmutableElementNode:
			return .element(elem)
		case let text as ImmutableTextNode:
			return .text(text)
		default:
			return nil
		}
	}
}
