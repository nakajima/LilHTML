//
//  Node+DebugDescription.swift
//
//
//  Created by Pat Nakajima on 5/2/24.
//

import Foundation

public extension Node {
	var debugDescription: String {
		generateDebugDescription(level: 0)
	}

	private func generateDebugDescription(level: Int) -> String {
		let indent = Array(repeating: "  ", count: level).joined() + "\(position):"
		switch self {
		case let text as MutableTextNode:
			return "\(indent) text \(text.textContent.debugDescription)"
		case let elem as MutableElementNode:
			var parts: [String] = [indent, elem.tagName.rawValue]

			if !elem.attributes.isEmpty {
				parts.append(elem.attributes.debugDescription)
			}

			if !elem.childNodes.isEmpty {
				parts.append(contentsOf: elem.childNodes.map {
					"\n" + $0.generateDebugDescription(level: level + 1)
				})
			}

			return parts.joined(separator: " ")
		default:
			return ""
		}
	}
}
