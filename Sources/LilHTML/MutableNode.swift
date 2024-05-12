//
//  MutableNode.swift
//
//
//  Created by Pat Nakajima on 5/11/24.
//

import Foundation

public protocol MutableNode: AnyObject, Node where ElementType == MutableElementNode {
	var parent: ElementType? { get set }
	var position: Int { get set }

	func replace<Replacement: MutableNode>(with: Replacement)
	func remove() -> Self
}

public enum MutableNodeType: Codable {
	case element(MutableElementNode), text(MutableTextNode)
}

public extension MutableNode {
	@discardableResult func remove() -> Self {
		if let parent {
			parent.removeChild(self)
		}

		return self
	}

	var type: MutableNodeType? {
		switch self {
		case let elem as MutableElementNode:
			.element(elem)
		case let text as MutableTextNode:
			.text(text)
		default:
			nil
		}
	}
}
