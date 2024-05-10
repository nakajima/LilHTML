//
//  CSS.swift
//
//
//  Created by Pat Nakajima on 5/9/24.
//

import Foundation

public struct Selectar: Codable {
	public struct Segment: Codable, Equatable, CustomDebugStringConvertible {
		public static func == (lhs: Selectar.Segment, rhs: Selectar.Segment) -> Bool {
			lhs.tagName == rhs.tagName && lhs.containsText == rhs.containsText && lhs.attributes == rhs.attributes
		}
		
		public var tagName: TagName?
		public var containsText: String?
		public var attributes: [String: String] = [:]

		public init(tagName: TagName? = nil, containsText: String? = nil, attributes: [String : String] = [:]) {
			self.tagName = tagName
			self.containsText = containsText
			self.attributes = attributes
		}

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
			if element.is(.article) {

			}

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

		public var debugDescription: String {
			"Selectar.Segment(tagName: \(String(describing: tagName)), attributes: \(attributes.debugDescription)"
		}
	}

	public var segments: [Segment]
}

extension Selectar.Segment: ExpressibleBySelectorSegment {
	public var selectorSegment: Selectar.Segment { self }
}

public protocol ExpressibleBySelector {
	var selector: Selectar { get }
}

public protocol ExpressibleBySelectorSegment: Codable {
	var selectorSegment: Selectar.Segment { get }
}

public extension ExpressibleBySelectorSegment {
	static func / (lhs: Self, rhs: any ExpressibleBySelectorSegment) -> [Selectar.Segment] {
		if let lhs = lhs as? Array<Selectar.Segment> {
			var result = lhs
			result.append(rhs.selectorSegment)
			return result
		} else {
			return [lhs.selectorSegment, rhs.selectorSegment]
		}
	}
}

extension Array: ExpressibleBySelector where Element == Selectar.Segment {
	public var selector: Selectar {
		Selectar(segments: self)
	}
	

	public static func / (lhs: Self, rhs: Selectar.Segment) -> [Selectar.Segment] {
		var result = lhs
		result.append(rhs.selectorSegment)
		return result
	}
}

extension TagName: ExpressibleBySelectorSegment {
	public var selectorSegment: Selectar.Segment {
		.init(tagName: self)
	}
}

public extension ExpressibleBySelectorSegment where Self == Selectar.Segment {
	static var `any`: Selectar.Segment { .init() }
	static var custom: Selectar.Segment { .init(tagName: .custom) }
	static var mediaStream: Selectar.Segment { .init(tagName: .mediaStream) }
	static var a: Selectar.Segment { .init(tagName: .a) }
	static var abbr: Selectar.Segment { .init(tagName: .abbr) }
	static var acronym: Selectar.Segment { .init(tagName: .acronym) }
	static var address: Selectar.Segment { .init(tagName: .address) }
	static var area: Selectar.Segment { .init(tagName: .area) }
	static var article: Selectar.Segment { .init(tagName: .article) }
	static var aside: Selectar.Segment { .init(tagName: .aside) }
	static var audio: Selectar.Segment { .init(tagName: .audio) }
	static var b: Selectar.Segment { .init(tagName: .b) }
	static var base: Selectar.Segment { .init(tagName: .base) }
	static var bdi: Selectar.Segment { .init(tagName: .bdi) }
	static var bdo: Selectar.Segment { .init(tagName: .bdo) }
	static var big: Selectar.Segment { .init(tagName: .big) }
	static var blockquote: Selectar.Segment { .init(tagName: .blockquote) }
	static var body: Selectar.Segment { .init(tagName: .body) }
	static var br: Selectar.Segment { .init(tagName: .br) }
	static var button: Selectar.Segment { .init(tagName: .button) }
	static var canvas: Selectar.Segment { .init(tagName: .canvas) }
	static var caption: Selectar.Segment { .init(tagName: .caption) }
	static var center: Selectar.Segment { .init(tagName: .center) }
	static var cite: Selectar.Segment { .init(tagName: .cite) }
	static var code: Selectar.Segment { .init(tagName: .code) }
	static var col: Selectar.Segment { .init(tagName: .col) }
	static var colgroup: Selectar.Segment { .init(tagName: .colgroup) }
	static var data: Selectar.Segment { .init(tagName: .data) }
	static var datalist: Selectar.Segment { .init(tagName: .datalist) }
	static var dd: Selectar.Segment { .init(tagName: .dd) }
	static var del: Selectar.Segment { .init(tagName: .del) }
	static var details: Selectar.Segment { .init(tagName: .details) }
	static var dfn: Selectar.Segment { .init(tagName: .dfn) }
	static var dialog: Selectar.Segment { .init(tagName: .dialog) }
	static var dir: Selectar.Segment { .init(tagName: .dir) }
	static var div: Selectar.Segment { .init(tagName: .div) }
	static var dl: Selectar.Segment { .init(tagName: .dl) }
	static var dt: Selectar.Segment { .init(tagName: .dt) }
	static var em: Selectar.Segment { .init(tagName: .em) }
	static var embed: Selectar.Segment { .init(tagName: .embed) }
	static var fieldset: Selectar.Segment { .init(tagName: .fieldset) }
	static var figcaption: Selectar.Segment { .init(tagName: .figcaption) }
	static var figure: Selectar.Segment { .init(tagName: .figure) }
	static var font: Selectar.Segment { .init(tagName: .font) }
	static var footer: Selectar.Segment { .init(tagName: .footer) }
	static var form: Selectar.Segment { .init(tagName: .form) }
	static var frame: Selectar.Segment { .init(tagName: .frame) }
	static var frameset: Selectar.Segment { .init(tagName: .frameset) }
	static var h1: Selectar.Segment { .init(tagName: .h1) }
	static var h2: Selectar.Segment { .init(tagName: .h2) }
	static var h3: Selectar.Segment { .init(tagName: .h3) }
	static var h4: Selectar.Segment { .init(tagName: .h4) }
	static var h5: Selectar.Segment { .init(tagName: .h5) }
	static var h6: Selectar.Segment { .init(tagName: .h6) }
	static var head: Selectar.Segment { .init(tagName: .head) }
	static var header: Selectar.Segment { .init(tagName: .header) }
	static var headers: Selectar.Segment { .init(tagName: .headers) }
	static var hgroup: Selectar.Segment { .init(tagName: .hgroup) }
	static var hr: Selectar.Segment { .init(tagName: .hr) }
	static var html: Selectar.Segment { .init(tagName: .html) }
	static var i: Selectar.Segment { .init(tagName: .i) }
	static var iframe: Selectar.Segment { .init(tagName: .iframe) }
	static var img: Selectar.Segment { .init(tagName: .img) }
	static var input: Selectar.Segment { .init(tagName: .input) }
	static var ins: Selectar.Segment { .init(tagName: .ins) }
	static var kbd: Selectar.Segment { .init(tagName: .kbd) }
	static var label: Selectar.Segment { .init(tagName: .label) }
	static var legend: Selectar.Segment { .init(tagName: .legend) }
	static var li: Selectar.Segment { .init(tagName: .li) }
	static var link: Selectar.Segment { .init(tagName: .link) }
	static var main: Selectar.Segment { .init(tagName: .main) }
	static var map: Selectar.Segment { .init(tagName: .map) }
	static var mark: Selectar.Segment { .init(tagName: .mark) }
	static var marquee: Selectar.Segment { .init(tagName: .marquee) }
	static var math: Selectar.Segment { .init(tagName: .math) }
	static var menu: Selectar.Segment { .init(tagName: .menu) }
	static var menuitem: Selectar.Segment { .init(tagName: .menuitem) }
	static var meta: Selectar.Segment { .init(tagName: .meta) }
	static var meter: Selectar.Segment { .init(tagName: .meter) }
	static var nav: Selectar.Segment { .init(tagName: .nav) }
	static var nobr: Selectar.Segment { .init(tagName: .nobr) }
	static var noembed: Selectar.Segment { .init(tagName: .noembed) }
	static var noframes: Selectar.Segment { .init(tagName: .noframes) }
	static var noscript: Selectar.Segment { .init(tagName: .noscript) }
	static var object: Selectar.Segment { .init(tagName: .object) }
	static var ol: Selectar.Segment { .init(tagName: .ol) }
	static var optgroup: Selectar.Segment { .init(tagName: .optgroup) }
	static var option: Selectar.Segment { .init(tagName: .option) }
	static var output: Selectar.Segment { .init(tagName: .output) }
	static var p: Selectar.Segment { .init(tagName: .p) }
	static var param: Selectar.Segment { .init(tagName: .param) }
	static var picture: Selectar.Segment { .init(tagName: .picture) }
	static var plaintext: Selectar.Segment { .init(tagName: .plaintext) }
	static var portal: Selectar.Segment { .init(tagName: .portal) }
	static var pre: Selectar.Segment { .init(tagName: .pre) }
	static var progress: Selectar.Segment { .init(tagName: .progress) }
	static var q: Selectar.Segment { .init(tagName: .q) }
	static var rb: Selectar.Segment { .init(tagName: .rb) }
	static var rp: Selectar.Segment { .init(tagName: .rp) }
	static var rt: Selectar.Segment { .init(tagName: .rt) }
	static var rtc: Selectar.Segment { .init(tagName: .rtc) }
	static var ruby: Selectar.Segment { .init(tagName: .ruby) }
	static var s: Selectar.Segment { .init(tagName: .s) }
	static var samp: Selectar.Segment { .init(tagName: .samp) }
	static var scope: Selectar.Segment { .init(tagName: .scope) }
	static var script: Selectar.Segment { .init(tagName: .script) }
	static var search: Selectar.Segment { .init(tagName: .search) }
	static var section: Selectar.Segment { .init(tagName: .section) }
	static var select: Selectar.Segment { .init(tagName: .select) }
	static var slot: Selectar.Segment { .init(tagName: .slot) }
	static var small: Selectar.Segment { .init(tagName: .small) }
	static var source: Selectar.Segment { .init(tagName: .source) }
	static var span: Selectar.Segment { .init(tagName: .span) }
	static var strike: Selectar.Segment { .init(tagName: .strike) }
	static var strong: Selectar.Segment { .init(tagName: .strong) }
	static var style: Selectar.Segment { .init(tagName: .style) }
	static var sub: Selectar.Segment { .init(tagName: .sub) }
	static var summary: Selectar.Segment { .init(tagName: .summary) }
	static var sup: Selectar.Segment { .init(tagName: .sup) }
	static var svg: Selectar.Segment { .init(tagName: .svg) }
	static var table: Selectar.Segment { .init(tagName: .table) }
	static var tbody: Selectar.Segment { .init(tagName: .tbody) }
	static var td: Selectar.Segment { .init(tagName: .td) }
	static var template: Selectar.Segment { .init(tagName: .template) }
	static var textarea: Selectar.Segment { .init(tagName: .textarea) }
	static var tfoot: Selectar.Segment { .init(tagName: .tfoot) }
	static var th: Selectar.Segment { .init(tagName: .th) }
	static var thead: Selectar.Segment { .init(tagName: .thead) }
	static var time: Selectar.Segment { .init(tagName: .time) }
	static var title: Selectar.Segment { .init(tagName: .title) }
	static var tr: Selectar.Segment { .init(tagName: .tr) }
	static var track: Selectar.Segment { .init(tagName: .track) }
	static var tt: Selectar.Segment { .init(tagName: .tt) }
	static var u: Selectar.Segment { .init(tagName: .u) }
	static var ul: Selectar.Segment { .init(tagName: .ul) }
	static var `var`: Selectar.Segment { .init(tagName: .`var`) }
	static var video: Selectar.Segment { .init(tagName: .video) }
	static var wbr: Selectar.Segment { .init(tagName: .wbr) }
	static var xmp: Selectar.Segment { .init(tagName: .xmp) }
}
