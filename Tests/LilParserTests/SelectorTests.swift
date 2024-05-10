//
//  CSSSelectorTests.swift
//
//
//  Created by Pat Nakajima on 5/9/24.
//

import Foundation
import LilHTML
import XCTest

class SelectorTests: XCTestCase {
	func testDSL() throws {
		let result: Selectar = .div / .strong / .a[class: "sup"]
		let expected: Selectar = [.div, .strong, .a[class: "sup"]]
		XCTAssertEqual(expected, result)
	}

	func testMatching() throws {
		let html = """
		<article>
			<h2>Sup</h2>
		</article>
		"""

		let parsed = try! LilHTML.HTML(html: html).parse().get()
		let searched = parsed.search(.article / .h2)
		let result = searched.first!.textContent
		XCTAssertEqual("Sup", result.trimmingCharacters(in: .whitespacesAndNewlines))
	}

	func testSimpleClass() throws {
		let html = """
		<div>
			<article class="hello">
				<h2>Sup</h2>
			</article>
			<article>
				<h2>hi</h2>
			</article>
		</div>
		"""

		let parsed = try! LilHTML.HTML(html: html).parse().get()
		let searched = parsed.search(.any[class: "hello"] / .h2)
		let result = searched.first!.textContent
		XCTAssertEqual("Sup", result.trimmingCharacters(in: .whitespacesAndNewlines))
	}

	func testBasic() throws {
		let html = """
		<html>
			<body>
				<article class="first-article">
					<h2>Hello</h2>
				</article>
				<article>
					<h2><div>World</div></h2>
				</article>
				<article>
					<h2>Fizz</h2>
				</article>
				<article>
					<h2>Buzz</h2>
				</article>
			</body>
		</html>
		"""

		let doc = try HTML(html: html).parse().get()

		let articleHeaders = doc.search(.body / .article / .h2)
		XCTAssertEqual(4, articleHeaders.count, articleHeaders.map(\.toHTML).joined(separator: "\n"))
	}

	func testClass() throws {
		let html = """
		<html>
			<body>
				<article class="first-article">
					<h2>Hello</h2>
				</article>
				<article class="second-article">
					<h2>World</h2>
				</article>
				<article>
					<h2>Fizz</h2>
				</article>
				<article>
					<h2>Buzz</h2>
				</article>
			</body>
		</html>
		"""

		let doc = try HTML(html: html).parse().get()
		
		let header = doc.search(.any[class: "second-article"] / .h2)
		XCTAssertEqual(1, header.count, header.map(\.toHTML).joined())
		XCTAssertEqual("World", header[0].textContent.trimmingCharacters(in: .whitespacesAndNewlines), header.map(\.toHTML).joined())
	}
}
