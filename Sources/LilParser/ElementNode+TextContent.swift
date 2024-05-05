//
//  ElementNode+TextContent.swift
//
//
//  Created by Pat Nakajima on 5/2/24.
//

import Foundation

public extension ElementNode {
	var textContent: String {
		childNodes.map(\.textContent).joined()
	}
}
