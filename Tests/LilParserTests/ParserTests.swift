//
//  ParserTests.swift
//
//
//  Created by Pat Nakajima on 5/2/24.
//

import Foundation
import LilParser
import XCTest

class ParserTests: XCTestCase {
	func html(_ name: String) -> String {
		return try! String(contentsOf: Bundle.module.url(forResource: name, withExtension: "html")!)
	}

	func testParsePerformance() {
		let html = html("basic")

		measure {
			for _ in 0 ..< 1000 {
				_ = try! Parser(html: html).parse()!.get()
			}
		}
	}

	func testBasic() throws {
		let parsed = try Parser(html: html("basic")).parse()!.get()
		XCTAssertEqual(6, parsed.find(.p).count)
		XCTAssertEqual(9, parsed.find(.p, .strong).count)

		for _ in 0 ..< 1000 {
			_ = parsed.find(.p, .strong)
		}
	}
}
