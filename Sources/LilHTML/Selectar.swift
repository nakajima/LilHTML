//
//  CSS.swift
//
//
//  Created by Pat Nakajima on 5/9/24.
//

import Foundation

public typealias Selectar = Array<SelectarSegment>

public struct SelectarSegment: Codable, Equatable, CustomDebugStringConvertible {
	public static func == (lhs: SelectarSegment, rhs: SelectarSegment) -> Bool {
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

	public subscript(class className: String) -> SelectarSegment {
		var segment = self
		segment.attributes["class"] = className
		return segment
	}

	public func contains(_ string: String) -> SelectarSegment {
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
		"SelectarSegment(tagName: \(String(describing: tagName)), attributes: \(attributes.debugDescription)"
	}
}

extension SelectarSegment: ExpressibleBySelectorSegment {
	public var selectorSegment: SelectarSegment { self }
}

public protocol ExpressibleBySelector {
	var selector: Selectar { get }
}

public protocol ExpressibleBySelectorSegment: Codable {
	var selectorSegment: SelectarSegment { get }
}

public extension ExpressibleBySelectorSegment {
	static func / (lhs: Self, rhs: any ExpressibleBySelectorSegment) -> [SelectarSegment] {
		if let lhs = lhs as? Array<SelectarSegment> {
			var result = lhs
			result.append(rhs.selectorSegment)
			return result
		} else {
			return [lhs.selectorSegment, rhs.selectorSegment]
		}
	}
}

extension Array: ExpressibleBySelector where Element == SelectarSegment {
	public var selector: Selectar {
		Selectar(self)
	}
	

	public static func / (lhs: Self, rhs: SelectarSegment) -> [SelectarSegment] {
		var result = lhs
		result.append(rhs.selectorSegment)
		return result
	}
}

extension TagName: ExpressibleBySelectorSegment {
	public var selectorSegment: SelectarSegment {
		.init(tagName: self)
	}
}

public extension ExpressibleBySelectorSegment where Self == SelectarSegment {
	static var `any`: SelectarSegment { .init() }
	static var custom: SelectarSegment { .init(tagName: .custom) }
	static var mediaStream: SelectarSegment { .init(tagName: .mediaStream) }
	static var a: SelectarSegment { .init(tagName: .a) }
	static var abbr: SelectarSegment { .init(tagName: .abbr) }
	static var acronym: SelectarSegment { .init(tagName: .acronym) }
	static var address: SelectarSegment { .init(tagName: .address) }
	static var area: SelectarSegment { .init(tagName: .area) }
	static var article: SelectarSegment { .init(tagName: .article) }
	static var aside: SelectarSegment { .init(tagName: .aside) }
	static var audio: SelectarSegment { .init(tagName: .audio) }
	static var b: SelectarSegment { .init(tagName: .b) }
	static var base: SelectarSegment { .init(tagName: .base) }
	static var bdi: SelectarSegment { .init(tagName: .bdi) }
	static var bdo: SelectarSegment { .init(tagName: .bdo) }
	static var big: SelectarSegment { .init(tagName: .big) }
	static var blockquote: SelectarSegment { .init(tagName: .blockquote) }
	static var body: SelectarSegment { .init(tagName: .body) }
	static var br: SelectarSegment { .init(tagName: .br) }
	static var button: SelectarSegment { .init(tagName: .button) }
	static var canvas: SelectarSegment { .init(tagName: .canvas) }
	static var caption: SelectarSegment { .init(tagName: .caption) }
	static var center: SelectarSegment { .init(tagName: .center) }
	static var cite: SelectarSegment { .init(tagName: .cite) }
	static var code: SelectarSegment { .init(tagName: .code) }
	static var col: SelectarSegment { .init(tagName: .col) }
	static var colgroup: SelectarSegment { .init(tagName: .colgroup) }
	static var data: SelectarSegment { .init(tagName: .data) }
	static var datalist: SelectarSegment { .init(tagName: .datalist) }
	static var dd: SelectarSegment { .init(tagName: .dd) }
	static var del: SelectarSegment { .init(tagName: .del) }
	static var details: SelectarSegment { .init(tagName: .details) }
	static var dfn: SelectarSegment { .init(tagName: .dfn) }
	static var dialog: SelectarSegment { .init(tagName: .dialog) }
	static var dir: SelectarSegment { .init(tagName: .dir) }
	static var div: SelectarSegment { .init(tagName: .div) }
	static var dl: SelectarSegment { .init(tagName: .dl) }
	static var dt: SelectarSegment { .init(tagName: .dt) }
	static var em: SelectarSegment { .init(tagName: .em) }
	static var embed: SelectarSegment { .init(tagName: .embed) }
	static var fieldset: SelectarSegment { .init(tagName: .fieldset) }
	static var figcaption: SelectarSegment { .init(tagName: .figcaption) }
	static var figure: SelectarSegment { .init(tagName: .figure) }
	static var font: SelectarSegment { .init(tagName: .font) }
	static var footer: SelectarSegment { .init(tagName: .footer) }
	static var form: SelectarSegment { .init(tagName: .form) }
	static var frame: SelectarSegment { .init(tagName: .frame) }
	static var frameset: SelectarSegment { .init(tagName: .frameset) }
	static var h1: SelectarSegment { .init(tagName: .h1) }
	static var h2: SelectarSegment { .init(tagName: .h2) }
	static var h3: SelectarSegment { .init(tagName: .h3) }
	static var h4: SelectarSegment { .init(tagName: .h4) }
	static var h5: SelectarSegment { .init(tagName: .h5) }
	static var h6: SelectarSegment { .init(tagName: .h6) }
	static var head: SelectarSegment { .init(tagName: .head) }
	static var header: SelectarSegment { .init(tagName: .header) }
	static var headers: SelectarSegment { .init(tagName: .headers) }
	static var hgroup: SelectarSegment { .init(tagName: .hgroup) }
	static var hr: SelectarSegment { .init(tagName: .hr) }
	static var html: SelectarSegment { .init(tagName: .html) }
	static var i: SelectarSegment { .init(tagName: .i) }
	static var iframe: SelectarSegment { .init(tagName: .iframe) }
	static var img: SelectarSegment { .init(tagName: .img) }
	static var input: SelectarSegment { .init(tagName: .input) }
	static var ins: SelectarSegment { .init(tagName: .ins) }
	static var kbd: SelectarSegment { .init(tagName: .kbd) }
	static var label: SelectarSegment { .init(tagName: .label) }
	static var legend: SelectarSegment { .init(tagName: .legend) }
	static var li: SelectarSegment { .init(tagName: .li) }
	static var link: SelectarSegment { .init(tagName: .link) }
	static var main: SelectarSegment { .init(tagName: .main) }
	static var map: SelectarSegment { .init(tagName: .map) }
	static var mark: SelectarSegment { .init(tagName: .mark) }
	static var marquee: SelectarSegment { .init(tagName: .marquee) }
	static var math: SelectarSegment { .init(tagName: .math) }
	static var menu: SelectarSegment { .init(tagName: .menu) }
	static var menuitem: SelectarSegment { .init(tagName: .menuitem) }
	static var meta: SelectarSegment { .init(tagName: .meta) }
	static var meter: SelectarSegment { .init(tagName: .meter) }
	static var nav: SelectarSegment { .init(tagName: .nav) }
	static var nobr: SelectarSegment { .init(tagName: .nobr) }
	static var noembed: SelectarSegment { .init(tagName: .noembed) }
	static var noframes: SelectarSegment { .init(tagName: .noframes) }
	static var noscript: SelectarSegment { .init(tagName: .noscript) }
	static var object: SelectarSegment { .init(tagName: .object) }
	static var ol: SelectarSegment { .init(tagName: .ol) }
	static var optgroup: SelectarSegment { .init(tagName: .optgroup) }
	static var option: SelectarSegment { .init(tagName: .option) }
	static var output: SelectarSegment { .init(tagName: .output) }
	static var p: SelectarSegment { .init(tagName: .p) }
	static var param: SelectarSegment { .init(tagName: .param) }
	static var picture: SelectarSegment { .init(tagName: .picture) }
	static var plaintext: SelectarSegment { .init(tagName: .plaintext) }
	static var portal: SelectarSegment { .init(tagName: .portal) }
	static var pre: SelectarSegment { .init(tagName: .pre) }
	static var progress: SelectarSegment { .init(tagName: .progress) }
	static var q: SelectarSegment { .init(tagName: .q) }
	static var rb: SelectarSegment { .init(tagName: .rb) }
	static var rp: SelectarSegment { .init(tagName: .rp) }
	static var rt: SelectarSegment { .init(tagName: .rt) }
	static var rtc: SelectarSegment { .init(tagName: .rtc) }
	static var ruby: SelectarSegment { .init(tagName: .ruby) }
	static var s: SelectarSegment { .init(tagName: .s) }
	static var samp: SelectarSegment { .init(tagName: .samp) }
	static var scope: SelectarSegment { .init(tagName: .scope) }
	static var script: SelectarSegment { .init(tagName: .script) }
	static var search: SelectarSegment { .init(tagName: .search) }
	static var section: SelectarSegment { .init(tagName: .section) }
	static var select: SelectarSegment { .init(tagName: .select) }
	static var slot: SelectarSegment { .init(tagName: .slot) }
	static var small: SelectarSegment { .init(tagName: .small) }
	static var source: SelectarSegment { .init(tagName: .source) }
	static var span: SelectarSegment { .init(tagName: .span) }
	static var strike: SelectarSegment { .init(tagName: .strike) }
	static var strong: SelectarSegment { .init(tagName: .strong) }
	static var style: SelectarSegment { .init(tagName: .style) }
	static var sub: SelectarSegment { .init(tagName: .sub) }
	static var summary: SelectarSegment { .init(tagName: .summary) }
	static var sup: SelectarSegment { .init(tagName: .sup) }
	static var svg: SelectarSegment { .init(tagName: .svg) }
	static var table: SelectarSegment { .init(tagName: .table) }
	static var tbody: SelectarSegment { .init(tagName: .tbody) }
	static var td: SelectarSegment { .init(tagName: .td) }
	static var template: SelectarSegment { .init(tagName: .template) }
	static var textarea: SelectarSegment { .init(tagName: .textarea) }
	static var tfoot: SelectarSegment { .init(tagName: .tfoot) }
	static var th: SelectarSegment { .init(tagName: .th) }
	static var thead: SelectarSegment { .init(tagName: .thead) }
	static var time: SelectarSegment { .init(tagName: .time) }
	static var title: SelectarSegment { .init(tagName: .title) }
	static var tr: SelectarSegment { .init(tagName: .tr) }
	static var track: SelectarSegment { .init(tagName: .track) }
	static var tt: SelectarSegment { .init(tagName: .tt) }
	static var u: SelectarSegment { .init(tagName: .u) }
	static var ul: SelectarSegment { .init(tagName: .ul) }
	static var `var`: SelectarSegment { .init(tagName: .`var`) }
	static var video: SelectarSegment { .init(tagName: .video) }
	static var wbr: SelectarSegment { .init(tagName: .wbr) }
	static var xmp: SelectarSegment { .init(tagName: .xmp) }
}
