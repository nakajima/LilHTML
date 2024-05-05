//
//  TextNode+Equatable.swift
//
//
//  Created by Pat Nakajima on 5/2/24.
//

import Foundation

extension TextNode: Equatable {
	public static func == (lhs: TextNode, rhs: TextNode) -> Bool {
		lhs.textContent == rhs.textContent
	}

	public static func == (lhs: TextNode, rhs: any Node) -> Bool {
		lhs.same(as: rhs)
	}

	public func same(as other: any Node) -> Bool {
		if let other = other as? TextNode {
			return textContent == other.textContent
		}

		return false
	}
}
