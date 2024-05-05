//
//  TextNode.swift
//
//
//  Created by Pat Nakajima on 5/2/24.
//

import Foundation

public class TextNode: Node {
	public var position: Int = -1
	public weak var parent: ElementNode?
	public var textContent: String

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
