//
//  MutableTextNode+Equatable.swift
//
//
//  Created by Pat Nakajima on 5/2/24.
//

import Foundation

extension MutableTextNode: Equatable {
	public static func == (lhs: MutableTextNode, rhs: MutableTextNode) -> Bool {
		lhs.textContent == rhs.textContent
	}

	public static func == (lhs: MutableTextNode, rhs: any Node) -> Bool {
		lhs.same(as: rhs)
	}

	public func same(as other: any Node) -> Bool {
		if let other = other as? MutableTextNode {
			return textContent == other.textContent
		}

		return false
	}
}
