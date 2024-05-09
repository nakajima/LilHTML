//
//  ElementNode+Equatable.swift
//
//
//  Created by Pat Nakajima on 5/2/24.
//

import Foundation

extension ElementNode: Equatable {
	public static func == (lhs: ElementNode, rhs: ElementNode) -> Bool {
		lhs.same(as: rhs)
	}

	public static func == (lhs: ElementNode, rhs: any Node) -> Bool {
		lhs.same(as: rhs)
	}

	public func same(as other: any Node) -> Bool {
		if let other = other as? ElementNode {
			return same(as: other)
		}

		return false
	}

	func same(as other: ElementNode) -> Bool {
		guard tagName == other.tagName, attributes == other.attributes else {
			return false
		}

		if childNodes.count != other.childNodes.count {
			return false
		}

		for (i, otherChild) in other.childNodes.enumerated() {
			if childNodes[i].same(as: otherChild) {
				continue
			}

			return false
		}

		return true
	}
}
