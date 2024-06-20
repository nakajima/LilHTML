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
		<div id="readability-content"><div class="page" id="readability-page-1"><div id="article-body" data-readability-score="59.14704231082181"><p><strong>At this year's Superbooth trade show, one of the most exciting announcements was the next phase of Korg's</strong><a data-before-rewrite-localise="https://www.musicradar.com/news/korg-acoustic-synthesis-phase8" href="https://www.musicradar.com/news/korg-acoustic-synthesis-phase8" data-analytics-id="inline-link"><strong>Acoustic Synthesis</strong></a><strong>prototype, a curious hybrid of acoustic instrument and synthesizer that produces sound by electromagnetically stimulating tuned metal resonators.</strong></p><p>Acoustic Synthesis phase_8 was developed at Korg's Berlin HQ, an outpost headed up by renowned instrument designer Tatsuya "Tats" Takahashi, the brains behind the brand's hugely popular Volca series and several other Korg products.</p><p>Reverb has given us an exciting behind-the-scenes glimpse into the experimentally-minded workshop in a video tour shared this week. "This is where all the exciting things happen," says Tats as he shows Reverb around. "The idea with this space is that we're very spontaneous and hands-on and we try things out as soon as ideas come up - this is where the ideas become physical things."</p><p>Tats shows off several of the Acoustic Synthesis prototypes, pointing out that each developer on the five-person team has produced their own unique version of the instrument, equipped with different resonators and visual styles. When a commercial version of the instrument is released - which Tats says should be within a year's time - the user will be able to customize their own in the same fashion.</p><p>"We're really into the idea that with our instruments, people get to customize it, modify it, make it their own thing - we think that it's a really important thing for machines to become part of you, so you can create music with it," he says.</p><p>Later in the video, Tats takes Reverb into Korg Berlin's studio, showing us how a player can physically interact with Acoustic Synthesis' resonators to manipulate their sound. "Most synths, because they're purely electronic, you only access them through knobs and switches and faders," he explains.</p><p>"But we wanted to create something that felt a bit more alive, taking the nature of the sound-making outside of the box, for you to be able to interact with it."</p><div data-readability-score="7.185124746156077" id="slice-container-newsletterForm-articleInbodyContent-ucspmfPjCqmJ8TpXs2shcX"><div data-hydrate="true" data-readability-score="11.074403829416886"><div data-readability-score="19.03969973890339"><section data-readability-score="0.29000000000000004"><h2>Get the MusicRadar Newsletter</h2></section><section data-readability-score="4.597847025495751"><p>Want all the hottest music and gear news, reviews, deals, features and more, direct to your inbox? Sign up here.</p></section></div></div></div><p>Find out more on <a data-merchant-id="444018" href="https://www.awin1.com/awclick.php?awinmid=67144&awinaffid=103504&clickref=mrd-gb-3628360679367419900&p=https%3A%2F%2Freverb.com%2Fnews%2Fvideo-inside-korg-berlin-home-of-acoustic-electronic-synthesis" data-url="https://reverb.com/news/video-inside-korg-berlin-home-of-acoustic-electronic-synthesis" data-merchant-network="AW" data-merchant-url="reverb.com" data-merchant-name="reverb.com" data-hl-processed="hawklinks" referrerpolicy="no-referrer-when-downgrade" data-google-interstitial="false" data-analytics-id="inline-link" target="_blank" data-placeholder-url="https://www.awin1.com/awclick.php?awinmid=67144&awinaffid=103504&clickref=hawk-custom-tracking&p=https%3A%2F%2Freverb.com%2Fnews%2Fvideo-inside-korg-berlin-home-of-acoustic-electronic-synthesis" rel="sponsored noopener">Reverb's website</a> or revisit our 2023 interview with Tats below.</p></div></div></div>
		"""

		let parsed = try HTML(html: html).parse().get()

		for _ in 0 ..< 1000 {
			_ = parsed.find(.p, .strong)
		}
	}
}
