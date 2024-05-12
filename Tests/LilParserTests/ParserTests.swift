//
//  ParserTests.swift
//
//
//  Created by Pat Nakajima on 5/2/24.
//

import Foundation
import LilHTML
import XCTest

class ParserTests: XCTestCase {
	func html(_ name: String) -> String {
		return try! String(contentsOf: Bundle.module.url(forResource: name, withExtension: "html")!)
	}

	func testBasicUsage() throws {
		let parser = HTML(html: """
		<div>
			<div class="container">
				<h1>Hi it's lil tidy</h1>
				<article>
					<p class="one two">hello</p>
					<p>world</p>
				</article>
				<footer>
					<p>it's the footer</p>
				</footer>
			</div>
		</div>
		""")

		// Get an ElementNode
		let parsed = try parser.parse().get()

		// Search for tags
		let paragraphs = parsed.find(.p)
		XCTAssertEqual(3, paragraphs.count) // Passes!

		// Search for tags inside tags
		let footerParagraphs = parsed.find(.p, in: [.footer])
		XCTAssertEqual(1, footerParagraphs.count)

		// Search by attribute
		let firstParagraph = parsed.find(attributes: ["class": .contains("one")])
		XCTAssertEqual(1, firstParagraph.count)
	}

	func testCodable() throws {
		let parsed = try HTML(html: """
		<div>
			<div class="container">
				<h1>Hi it's lil tidy</h1>
				<article>
					<p class="one two">hello</p>
					<p>world</p>
				</article>
				<footer>
					<p>it's the footer</p>
				</footer>
			</div>
		</div>
		""").parse().get()

		let dumped = try JSONEncoder().encode(parsed)
		let loaded = try JSONDecoder().decode(MutableElementNode.self, from: dumped)
		print(String(data: dumped, encoding: .utf8)!)
		XCTAssertEqual(parsed, loaded)
	}

	func testImmutable() throws {
		let parsed = try HTML(html: """
		<div>
			<div class="container">
				<h1>Hi it's lil tidy</h1>
				<article>
					<p class="one two">hello</p>
					<p>world</p>
				</article>
				<footer>
					<p>it's the footer</p>
				</footer>
			</div>
		</div>
		""").parse().get()

		let immutable = parsed.immutableCopy()
		let immutableDump = try JSONEncoder().encode(parsed.immutableCopy())
		let mutable = try JSONDecoder().decode(MutableElementNode.self, from: immutableDump)
		print(immutable.debugDescription)
		XCTAssert(mutable.same(as: parsed))
	}

	func testParsePerformance() {
		let html = html("basic")

		measure {
			for _ in 0 ..< 1000 {
				_ = try! HTML(html: html).parse().get()
			}
		}
	}

	func testBasic() throws {
		let parsed = try HTML(html: html("basic")).parse().get()
		XCTAssertEqual(6, parsed.find(.p).count)
		XCTAssertEqual(9, parsed.find(.p, .strong).count)

		for _ in 0 ..< 1000 {
			_ = parsed.find(.p, .strong)
		}
	}
}
