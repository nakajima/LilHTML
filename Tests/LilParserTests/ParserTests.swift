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
				<h1>Hi it's & lil tidy</h1>
				<article>
					<p class="one two">hello</p>
					<p><a href="/foo?fizz=buzz&hello=world">world</a></p>
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

		XCTAssertEqual(parsed.toHTML(), loaded.toHTML())
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

		XCTAssertEqual(parsed.toHTML(), immutable.toHTML())

		let immutableDump = try JSONEncoder().encode(immutable)
		let mutable = try JSONDecoder().decode(MutableElementNode.self, from: immutableDump)

		// Make sure we can round trip to immutable then back
		XCTAssertEqual(mutable.toHTML(), parsed.toHTML())
	}

	func testImmutableToMutable() throws {
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
		let mutable = immutable.mutableCopy()
		XCTAssert(mutable.same(as: parsed))
	}

	func testImmutableMusicRadar() throws {
		let text = html("musicradar")
		let html = try HTML(html: text).parse().get().immutableCopy()

		let links = html.search(.a[class: "article-link"])
		XCTAssertEqual(33, links.count)
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

	func testParsing() throws {
		let html = """
		<main class="container"><h2 class="site-name"><a href="/">Pat’s Tech Weblog</a></h2><article class="post-body"><h1><code>git commit -m first</code></h1><p>Hey this is my new blog. Hope you enjoy.</p></article><footer><p><hr>Posted <time datetime="2024-05-03T00:00:00Z">May 3, 2024</time> in <a href="/tag/meta" class="tag">meta</a></p><p>Hi I’m Pat. This is my weblog. You can say hi on <a href="https://mastodon.social/@fancypat" rel="me">Mastodon</a>. I’m also on <a href="https://github.com/nakajima">GitHub</a>.</p><p>The markdown lives <a href="https://github.com/nakajima/patstechweblog.com">here</a> and I generate the HTML with <a href="https://github.com/nakajima/ohno">this</a>.</p><script>
			window.addEventListener('hashchange', function() {
				for (const footnote of document.querySelectorAll('.current')) {
					footnote.classList.remove('current')
				}

				if (/footnote-link-\\d/.test(document.location.hash)) {
					// Remove footnote hash when going back
					history.replaceState("", document.title, window.location.pathname + window.location.search)
				} else if (/footnote-\\d/.test(document.location.hash)) {
					// Highlight current footnote
					const highlightedFootnote = document.querySelector(document.location.hash)
					if (highlightedFootnote) {
						highlightedFootnote.classList.add('current')
					}
				}
			})
		</script></footer></main>
		"""

		// Just make sure it doesn't error
		_ = try HTML(html: html).parse().get()
	}
}
