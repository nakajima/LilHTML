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

extension TagName: ExpressibleBySelectorSegment {
	public var selectorSegment: Selector.Segment {
		.init(tagName: self)
	}
}

public extension ExpressibleBySelectorSegment where Self == Selector.Segment {
	static var custom: Selector.Segment { .init(tagName: .custom) }
	static var mediaStream: Selector.Segment { .init(tagName: .mediaStream) }
	static var a: Selector.Segment { .init(tagName: .a) }
	static var abbr: Selector.Segment { .init(tagName: .abbr) }
	static var acronym: Selector.Segment { .init(tagName: .acronym) }
	static var address: Selector.Segment { .init(tagName: .address) }
	static var area: Selector.Segment { .init(tagName: .area) }
	static var article: Selector.Segment { .init(tagName: .article) }
	static var aside: Selector.Segment { .init(tagName: .aside) }
	static var audio: Selector.Segment { .init(tagName: .audio) }
	static var b: Selector.Segment { .init(tagName: .b) }
	static var base: Selector.Segment { .init(tagName: .base) }
	static var bdi: Selector.Segment { .init(tagName: .bdi) }
	static var bdo: Selector.Segment { .init(tagName: .bdo) }
	static var big: Selector.Segment { .init(tagName: .big) }
	static var blockquote: Selector.Segment { .init(tagName: .blockquote) }
	static var body: Selector.Segment { .init(tagName: .body) }
	static var br: Selector.Segment { .init(tagName: .br) }
	static var button: Selector.Segment { .init(tagName: .button) }
	static var canvas: Selector.Segment { .init(tagName: .canvas) }
	static var caption: Selector.Segment { .init(tagName: .caption) }
	static var center: Selector.Segment { .init(tagName: .center) }
	static var cite: Selector.Segment { .init(tagName: .cite) }
	static var code: Selector.Segment { .init(tagName: .code) }
	static var col: Selector.Segment { .init(tagName: .col) }
	static var colgroup: Selector.Segment { .init(tagName: .colgroup) }
	static var data: Selector.Segment { .init(tagName: .data) }
	static var datalist: Selector.Segment { .init(tagName: .datalist) }
	static var dd: Selector.Segment { .init(tagName: .dd) }
	static var del: Selector.Segment { .init(tagName: .del) }
	static var details: Selector.Segment { .init(tagName: .details) }
	static var dfn: Selector.Segment { .init(tagName: .dfn) }
	static var dialog: Selector.Segment { .init(tagName: .dialog) }
	static var dir: Selector.Segment { .init(tagName: .dir) }
	static var div: Selector.Segment { .init(tagName: .div) }
	static var dl: Selector.Segment { .init(tagName: .dl) }
	static var dt: Selector.Segment { .init(tagName: .dt) }
	static var em: Selector.Segment { .init(tagName: .em) }
	static var embed: Selector.Segment { .init(tagName: .embed) }
	static var fieldset: Selector.Segment { .init(tagName: .fieldset) }
	static var figcaption: Selector.Segment { .init(tagName: .figcaption) }
	static var figure: Selector.Segment { .init(tagName: .figure) }
	static var font: Selector.Segment { .init(tagName: .font) }
	static var footer: Selector.Segment { .init(tagName: .footer) }
	static var form: Selector.Segment { .init(tagName: .form) }
	static var frame: Selector.Segment { .init(tagName: .frame) }
	static var frameset: Selector.Segment { .init(tagName: .frameset) }
	static var h1: Selector.Segment { .init(tagName: .h1) }
	static var h2: Selector.Segment { .init(tagName: .h2) }
	static var h3: Selector.Segment { .init(tagName: .h3) }
	static var h4: Selector.Segment { .init(tagName: .h4) }
	static var h5: Selector.Segment { .init(tagName: .h5) }
	static var h6: Selector.Segment { .init(tagName: .h6) }
	static var head: Selector.Segment { .init(tagName: .head) }
	static var header: Selector.Segment { .init(tagName: .header) }
	static var headers: Selector.Segment { .init(tagName: .headers) }
	static var hgroup: Selector.Segment { .init(tagName: .hgroup) }
	static var hr: Selector.Segment { .init(tagName: .hr) }
	static var html: Selector.Segment { .init(tagName: .html) }
	static var i: Selector.Segment { .init(tagName: .i) }
	static var iframe: Selector.Segment { .init(tagName: .iframe) }
	static var img: Selector.Segment { .init(tagName: .img) }
	static var input: Selector.Segment { .init(tagName: .input) }
	static var ins: Selector.Segment { .init(tagName: .ins) }
	static var kbd: Selector.Segment { .init(tagName: .kbd) }
	static var label: Selector.Segment { .init(tagName: .label) }
	static var legend: Selector.Segment { .init(tagName: .legend) }
	static var li: Selector.Segment { .init(tagName: .li) }
	static var link: Selector.Segment { .init(tagName: .link) }
	static var main: Selector.Segment { .init(tagName: .main) }
	static var map: Selector.Segment { .init(tagName: .map) }
	static var mark: Selector.Segment { .init(tagName: .mark) }
	static var marquee: Selector.Segment { .init(tagName: .marquee) }
	static var math: Selector.Segment { .init(tagName: .math) }
	static var menu: Selector.Segment { .init(tagName: .menu) }
	static var menuitem: Selector.Segment { .init(tagName: .menuitem) }
	static var meta: Selector.Segment { .init(tagName: .meta) }
	static var meter: Selector.Segment { .init(tagName: .meter) }
	static var nav: Selector.Segment { .init(tagName: .nav) }
	static var nobr: Selector.Segment { .init(tagName: .nobr) }
	static var noembed: Selector.Segment { .init(tagName: .noembed) }
	static var noframes: Selector.Segment { .init(tagName: .noframes) }
	static var noscript: Selector.Segment { .init(tagName: .noscript) }
	static var object: Selector.Segment { .init(tagName: .object) }
	static var ol: Selector.Segment { .init(tagName: .ol) }
	static var optgroup: Selector.Segment { .init(tagName: .optgroup) }
	static var option: Selector.Segment { .init(tagName: .option) }
	static var output: Selector.Segment { .init(tagName: .output) }
	static var p: Selector.Segment { .init(tagName: .p) }
	static var param: Selector.Segment { .init(tagName: .param) }
	static var picture: Selector.Segment { .init(tagName: .picture) }
	static var plaintext: Selector.Segment { .init(tagName: .plaintext) }
	static var portal: Selector.Segment { .init(tagName: .portal) }
	static var pre: Selector.Segment { .init(tagName: .pre) }
	static var progress: Selector.Segment { .init(tagName: .progress) }
	static var q: Selector.Segment { .init(tagName: .q) }
	static var rb: Selector.Segment { .init(tagName: .rb) }
	static var rp: Selector.Segment { .init(tagName: .rp) }
	static var rt: Selector.Segment { .init(tagName: .rt) }
	static var rtc: Selector.Segment { .init(tagName: .rtc) }
	static var ruby: Selector.Segment { .init(tagName: .ruby) }
	static var s: Selector.Segment { .init(tagName: .s) }
	static var samp: Selector.Segment { .init(tagName: .samp) }
	static var scope: Selector.Segment { .init(tagName: .scope) }
	static var script: Selector.Segment { .init(tagName: .script) }
	static var search: Selector.Segment { .init(tagName: .search) }
	static var section: Selector.Segment { .init(tagName: .section) }
	static var select: Selector.Segment { .init(tagName: .select) }
	static var slot: Selector.Segment { .init(tagName: .slot) }
	static var small: Selector.Segment { .init(tagName: .small) }
	static var source: Selector.Segment { .init(tagName: .source) }
	static var span: Selector.Segment { .init(tagName: .span) }
	static var strike: Selector.Segment { .init(tagName: .strike) }
	static var strong: Selector.Segment { .init(tagName: .strong) }
	static var style: Selector.Segment { .init(tagName: .style) }
	static var sub: Selector.Segment { .init(tagName: .sub) }
	static var summary: Selector.Segment { .init(tagName: .summary) }
	static var sup: Selector.Segment { .init(tagName: .sup) }
	static var svg: Selector.Segment { .init(tagName: .svg) }
	static var table: Selector.Segment { .init(tagName: .table) }
	static var tbody: Selector.Segment { .init(tagName: .tbody) }
	static var td: Selector.Segment { .init(tagName: .td) }
	static var template: Selector.Segment { .init(tagName: .template) }
	static var textarea: Selector.Segment { .init(tagName: .textarea) }
	static var tfoot: Selector.Segment { .init(tagName: .tfoot) }
	static var th: Selector.Segment { .init(tagName: .th) }
	static var thead: Selector.Segment { .init(tagName: .thead) }
	static var time: Selector.Segment { .init(tagName: .time) }
	static var title: Selector.Segment { .init(tagName: .title) }
	static var tr: Selector.Segment { .init(tagName: .tr) }
	static var track: Selector.Segment { .init(tagName: .track) }
	static var tt: Selector.Segment { .init(tagName: .tt) }
	static var u: Selector.Segment { .init(tagName: .u) }
	static var ul: Selector.Segment { .init(tagName: .ul) }
	static var `var`: Selector.Segment { .init(tagName: .`var`) }
	static var video: Selector.Segment { .init(tagName: .video) }
	static var wbr: Selector.Segment { .init(tagName: .wbr) }
	static var xmp: Selector.Segment { .init(tagName: .xmp) }
}
