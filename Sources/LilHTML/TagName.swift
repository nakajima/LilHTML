//
//  TagName.swift
//
//
//  Created by Pat Nakajima on 5/2/24.
//

import Foundation

public enum TagName: String, Hashable, Codable, Sendable, CustomStringConvertible {
	public var description: String { rawValue }

	func lowercased() -> String {
		description.lowercased()
	}

	case custom = "CUSTOM"
	case mediaStream = "MEDIASTREAM"
	case a = "A"
	case abbr = "ABBR"
	case acronym = "ACRONYM"
	case address = "ADDRESS"
	case area = "AREA"
	case article = "ARTICLE"
	case aside = "ASIDE"
	case audio = "AUDIO"
	case b = "B"
	case base = "BASE"
	case bdi = "BDI"
	case bdo = "BDO"
	case big = "BIG"
	case blockquote = "BLOCKQUOTE"
	case body = "BODY"
	case br = "BR"
	case button = "BUTTON"
	case canvas = "CANVAS"
	case caption = "CAPTION"
	case center = "CENTER"
	case cite = "CITE"
	case code = "CODE"
	case col = "COL"
	case colgroup = "COLGROUP"
	case data = "DATA"
	case datalist = "DATALIST"
	case dd = "DD"
	case del = "DEL"
	case details = "DETAILS"
	case dfn = "DFN"
	case dialog = "DIALOG"
	case dir = "DIR"
	case div = "DIV"
	case dl = "DL"
	case dt = "DT"
	case em = "EM"
	case embed = "EMBED"
	case fieldset = "FIELDSET"
	case figcaption = "FIGCAPTION"
	case figure = "FIGURE"
	case font = "FONT"
	case footer = "FOOTER"
	case form = "FORM"
	case frame = "FRAME"
	case frameset = "FRAMESET"
	case h1 = "H1"
	case h2 = "H2"
	case h3 = "H3"
	case h4 = "H4"
	case h5 = "H5"
	case h6 = "H6"
	case head = "HEAD"
	case header = "HEADER"
	case headers = "HEADERS"
	case hgroup = "HGROUP"
	case hr = "HR"
	case html = "HTML"
	case i = "I"
	case iframe = "IFRAME"
	case img = "IMG"
	case input = "INPUT"
	case ins = "INS"
	case kbd = "KBD"
	case label = "LABEL"
	case legend = "LEGEND"
	case li = "LI"
	case link = "LINK"
	case main = "MAIN"
	case map = "MAP"
	case mark = "MARK"
	case marquee = "MARQUEE"
	case math = "MATH"
	case menu = "MENU"
	case menuitem = "MENUITEM"
	case meta = "META"
	case meter = "METER"
	case nav = "NAV"
	case nobr = "NOBR"
	case noembed = "NOEMBED"
	case noframes = "NOFRAMES"
	case noscript = "NOSCRIPT"
	case object = "OBJECT"
	case ol = "OL"
	case optgroup = "OPTGROUP"
	case option = "OPTION"
	case output = "OUTPUT"
	case p = "P"
	case param = "PARAM"
	case picture = "PICTURE"
	case plaintext = "PLAINTEXT"
	case portal = "PORTAL"
	case pre = "PRE"
	case progress = "PROGRESS"
	case q = "Q"
	case rb = "RB"
	case rp = "RP"
	case rt = "RT"
	case rtc = "RTC"
	case ruby = "RUBY"
	case s = "S"
	case samp = "SAMP"
	case scope = "SCOPE"
	case script = "SCRIPT"
	case search = "SEARCH"
	case section = "SECTION"
	case select = "SELECT"
	case slot = "SLOT"
	case small = "SMALL"
	case source = "SOURCE"
	case span = "SPAN"
	case strike = "STRIKE"
	case strong = "STRONG"
	case style = "STYLE"
	case sub = "SUB"
	case summary = "SUMMARY"
	case sup = "SUP"
	case svg = "SVG"
	case table = "TABLE"
	case tbody = "TBODY"
	case td = "TD"
	case template = "TEMPLATE"
	case textarea = "TEXTAREA"
	case tfoot = "TFOOT"
	case th = "TH"
	case thead = "THEAD"
	case time = "TIME"
	case title = "TITLE"
	case tr = "TR"
	case track = "TRACK"
	case tt = "TT"
	case u = "U"
	case ul = "UL"
	case `var` = "VAR"
	case video = "VIDEO"
	case wbr = "WBR"
	case xmp = "XMP"
}
