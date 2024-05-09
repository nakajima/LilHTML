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
	func testBasic() throws {
		let html = """
		<html>
			<body>
				<article class="first-article">
					<h2>Hello</h2>
				</article>
				<article>
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

		let articleHeaders = doc.search(.body / .article / .h2)
		XCTAssertEqual(4, articleHeaders.count)
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
