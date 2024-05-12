//
//  MutableTextNode.swift
//
//
//  Created by Pat Nakajima on 5/2/24.
//

import Foundation

public class MutableTextNode: MutableNode, Hashable, Codable {
	public var position: Int = -1
	public weak var parent: MutableElementNode? = nil
	public var textContent: String

	enum CodingKeys: CodingKey {
		case position, textContent
	}

	public func hash(into hasher: inout Hasher) {
		hasher.combine(position)
		hasher.combine(textContent)
	}

	public init(parent: MutableElementNode?, textContent: String) {
		self.parent = parent
		self.textContent = textContent
	}

	public init(textContent: String) {
		self.textContent = textContent
	}

	public func copy() -> MutableTextNode {
		MutableTextNode(textContent: textContent)
	}

	public func immutableCopy() -> ImmutableTextNode {
		ImmutableTextNode(parent: parent?.immutableCopy(shallow: true), textContent: textContent, position: position)
	}
}
