//
//  Element+Equatable.swift
//
//
//  Created by Pat Nakajima on 5/2/24.
//

import Foundation

public extension Element where ElementType: Equatable {
	static func == (lhs: Self, rhs: ElementType) -> Bool {
		lhs.same(as: rhs)
	}

	static func == (lhs: Self, rhs: any Node) -> Bool {
		lhs.same(as: rhs)
	}

	func same(as other: any Node) -> Bool {
		if let other = other as? ElementType {
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

		return false
	}
}
