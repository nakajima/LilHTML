//
//  CSS.swift
//
//
//  Created by Pat Nakajima on 5/9/24.
//

import Foundation

public struct Selector {
	public struct Segment: ExpressibleBySelectorSegment {
		public var tagName: TagName?
		public var containsText: String?
		public var children: [Segment] = []
		public var attributes: [String: String] = [:]
		public var nextSibling: (any ExpressibleBySelectorSegment)?
		public var selectorSegment: Selector.Segment { self }

		public subscript(class className: String) -> Segment {
			var segment = self
			segment.attributes["class"] = className
			return segment
		}

		public func contains(_ string: String) -> Segment {
			var segment = self
			segment.containsText = string
			return segment
		}

		func matches(_ node: any Node) -> Bool {
			return switch node {
			case let node as ElementNode:
				matches(element: node)
			case _ as TextNode:
				false
			default:
				false
			}
		}

		func matches(element: ElementNode) -> Bool {
			if let tagName, tagName != element.tagName {
				return false
			}

			if let className = attributes["class"] {
				guard let elementClass = element["class"] else {
					return false
				}

				if !elementClass.components(separatedBy: .whitespaces).contains(className) {
					return false
				}
			}

			if let containsText {
				var contains = false

				for node in element.childNodes {
					guard let textNode = node as? TextNode else {
						continue
					}

					if textNode.textContent.contains(containsText) {
						contains = true
					}
				}

				return contains
			}

			return true
		}
	}

	public var segments: [Segment]
}

public protocol ExpressibleBySelector {
	var selector: Selector { get }
}

public protocol ExpressibleBySelectorSegment {
	var selectorSegment: Selector.Segment { get }
}

public extension ExpressibleBySelectorSegment {
	static func > (lhs: Self, rhs: any ExpressibleBySelectorSegment) -> Selector.Segment {
		var segment = lhs.selectorSegment
		segment.children.append(rhs.selectorSegment)
		return segment
	}

	static func / (lhs: Self, rhs: any ExpressibleBySelectorSegment) -> Selector.Segment {
		var segment = rhs.selectorSegment
		segment.children.append(lhs.selectorSegment)
		return segment
	}
}

//
// extension Array: ExpressibleBySelector where Element: ExpressibleBySelectorSegment {
//	public var selector: Selector {
//		Selector(segments: map(\.selectorSegment))
//	}
// }

extension TagName: ExpressibleBySelectorSegment {
	public var selectorSegment: Selector.Segment {
		.init(tagName: self)
	}
}

public extension ExpressibleBySelectorSegment where Self == TagName {
	static var h2: Selector.Segment {
		Selector.Segment(tagName: TagName(rawValue: "H2")!)
	}

	static var body: Selector.Segment {
		Selector.Segment(tagName: TagName(rawValue: "BODY")!)
	}

	static var article: Selector.Segment {
		Selector.Segment(tagName: TagName(rawValue: "ARTICLE")!)
	}
}
