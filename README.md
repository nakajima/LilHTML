# Lil Parser

It's lil html parser with ample opportunities for optimization.

## Usage

```swift
let parser = Parser(html: """
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
```
