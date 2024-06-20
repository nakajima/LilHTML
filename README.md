# LilHTML

It's lil html parser with ample opportunities for optimization.

It uses libxml2 to parse an HTML string into a pure Swift tree, rather than just wrapping a libxml2 tree.

When you call `Parser.parse` with some HTML, you get back a mutable tree consisting of `MutableElementNode`s and `MutableTextNode`s. These are reference types that let you manipulate the tree. If you want value semantics you can call `immutableCopy()` on the tree to get it as structs.

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
XCTAssertEqual(1, footerParagraphs.count) // Passes!

// Search by attribute
let firstParagraph = parsed.find(attributes: ["class": .contains("one")])
XCTAssertEqual(1, firstParagraph.count) // Passes!
```
