//
//  AttributeValue.swift
//
//
//  Created by Pat Nakajima on 5/5/24.
//

import Foundation

public struct AttributeValue: ExpressibleByStringLiteral {
	public typealias StringLiteralType = String

	public enum Comparison {
		case equals, contains
	}

	var value: String
	var comparison: Comparison

	public static func contains(_ value: String) -> AttributeValue {
		AttributeValue(value, comparison: .contains)
	}

	public init(stringLiteral: StringLiteralType) {
		self.value = stringLiteral
		self.comparison = .equals
	}

	public init(_ value: String, comparison: Comparison) {
		self.value = value
		self.comparison = comparison
	}

	func matches(value: String?) -> Bool {
		guard let value else {
			return false
		}

		return switch comparison {
		case .equals:
			self.value == value
		case .contains:
			value.contains(self.value)
		}
	}
}
