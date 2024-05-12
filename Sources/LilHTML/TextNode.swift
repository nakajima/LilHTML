//
//  TextNode.swift
//
//
//  Created by Pat Nakajima on 5/2/24.
//

import Foundation

public class TextNode: Node, Hashable, Codable {
	public var position: Int = -1
	public weak var parent: ElementNode? = nil
	public var textContent: String

	enum CodingKeys: CodingKey {
		case position, textContent
	}

	public func hash(into hasher: inout Hasher) {
		hasher.combine(position)
		hasher.combine(textContent)
	}

	public init(parent: ElementNode?, textContent: String) {
		self.parent = parent
		self.textContent = textContent
	}

	public init(textContent: String) {
		self.textContent = textContent
	}

	public func copy() -> TextNode {
		TextNode(textContent: textContent)
	}
}
