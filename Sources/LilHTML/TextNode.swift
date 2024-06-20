//
//  TextNode.swift
//
//
//  Created by Pat Nakajima on 5/13/24.
//

import Foundation

public protocol TextNode {
	associatedtype ElementType: Element

	var parent: ElementType? { get }
	var textContent: String { get }
	var position: Int { get }
}
