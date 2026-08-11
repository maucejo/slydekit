#let _calepin-document-element = document
#import "/.calepin/calepin.typ": *
#let document = _calepin-document-element

#let _calepin-expected-generation = "153c6a3052aa465b-1349cde127705c16"
#let _calepin-verify-generation() = {
  let path = sys.inputs.at("calepin-results", default: none)
  if path != none and path != "" {
    let actual = json(path).at("generation", default: "")
    if actual != _calepin-expected-generation {
      panic("Calepin results changed while this render was starting; Typst will retry with the completed build")
    }
  }
}
#_calepin-verify-generation()



#let _raw-chunk-langs = ("python", "r", "mermaid", "dot", "tikz", "d2")
#show raw.where(block: true, lang: "typ", theme: auto): it => _without-raw-chunk-transforms(() => _html-themed-raw-block(it))
#show raw.where(block: true, lang: "typst", theme: auto): it => _without-raw-chunk-transforms(() => _html-themed-raw-block(it))
#show raw.where(block: true, lang: "python", theme: auto): it => if _disable-raw-chunk-transforms.get() { _html-themed-raw-block(it) } else { chunk_from_raw_plain("python", it) }
#show raw.where(block: true, lang: "r", theme: auto): it => if _disable-raw-chunk-transforms.get() { _html-themed-raw-block(it) } else { chunk_from_raw_plain("r", it) }
#show raw.where(block: true, lang: "mermaid", theme: auto): it => if _disable-raw-chunk-transforms.get() { _html-themed-raw-block(it) } else { chunk_from_raw_plain("mermaid", it) }
#show raw.where(block: true, lang: "dot", theme: auto): it => if _disable-raw-chunk-transforms.get() { _html-themed-raw-block(it) } else { chunk_from_raw_plain("dot", it) }
#show raw.where(block: true, lang: "tikz", theme: auto): it => if _disable-raw-chunk-transforms.get() { _html-themed-raw-block(it) } else { chunk_from_raw_plain("tikz", it) }
#show raw.where(block: true, lang: "d2", theme: auto): it => if _disable-raw-chunk-transforms.get() { _html-themed-raw-block(it) } else { chunk_from_raw_plain("d2", it) }

#show raw.where(block: true, theme: auto): it => {
  if _is-query() {
    it
  } else if _disable-raw-chunk-transforms.get() {
    _html-themed-raw-block(it)
  } else if it.has("lang") and it.lang != none and _raw-chunk-langs.contains(it.lang) and _fenced-chunks-runs(
    it.lang,
    _resolve-options(it.lang, _call-defaults).at("fenced-chunks"),
  ) {
    chunk_from_raw_plain(it.lang, it)
  } else {
    _html-themed-raw-block(it)
  }
}

#show heading: it => {
  if _is-html() and "label" in it.fields() {
    std.html.elem("calepin-heading-anchor", attrs: (data-id: str(it.label)))
  }
  it
}

// Notebook theme
#import "/.calepin/calepin.typ": _html-themed-raw-block, _is-query, chunk_from_raw_plain

// Body text size, captured below at document-body level. Code blocks are sized
// relative to this rather than to `1em`, which would compound: a literal
// ```typ block is rendered by replacing its source `raw` element, so it renders
// inside Typst's already-reduced raw text context, whereas executed chunks are
// emitted as ordinary calls at body size. Anchoring to the captured body size
// gives both paths a single, matching reduction instead of shrinking twice.
#let _calepin-body-size = std.state("calepin-body-size", 11pt)

#show raw.where(block: true): it => {
  if it.theme != auto {
    context {
      set text(size: _calepin-body-size.get() * 0.8)
      it
    }
  } else if it.lang != none and (_is-query() or _raw-chunk-langs.contains(it.lang)) and _fenced-chunks-runs(
    it.lang,
    _resolve-options(it.lang, _call-defaults).at("fenced-chunks"),
  ) {
    chunk_from_raw_plain(it.lang, it)
  } else {
    _html-themed-raw-block(it)
  }
}

#context _calepin-body-size.update(text.size)

#import "/.calepin/calepin.typ" as calepin
#import "../doc-utils.typ": *

#set document(title: [One by one/Item by item])
#metadata((tags: ("animations", "item-by-item"))) <website-metadata>

#html.elem("p", attrs: (style: "color: var(--calepin-color-link); font-size: 2em; font-weight: bold;"))[One by one/Item by item]

Using `pause`can be tedious when you have a list of words or items  that you want to reveal one by one. Slydekit provides two convenient functions, `one-by-one` and `item-by-item`, to simplify this process.

#calepin.elements.callout[
  The implementation of `one-by-one` and `item-by-item` has been borrowed from the #link("https://polylux.dev/book/dynamic/obo-lbl.html", "Polylux") package, with some adaptations to fit the Slydekit framework.
]

= One by one

`one-by-one` is a function that allows you to reveal words or phrases one at a time. It is particularly useful for emphasizing key points in a sentence or phrase.

```typ
#let one-by-one(
  start: 1,
  hide-color: none,
  hide-fn: none
)
```

#argument-callout("start", "int", default: 1)[The starting step for the reveal. The first element will be revealed on this step.]

#argument-callout("hide-color", "color", default: none)[The color to use for hidden elements. If set to `none`, the hidden elements will be completely invisible.]

#argument-callout("hide-fn", "function", default: none)[A function that can be used to provide custom masking for hidden elements. If set to `none`, the default hiding behavior will be used.]

```typ
#slide[`#one-by-one` example][
  #one-by-one[I am ][not a ][ robot]
]
```

#calepin.elements.gallery(
  (
    ("../assets/animations/one-by-one1.png", "Step 1"),
    ("../assets/animations/one-by-one2.png", "Step 2"),
    ("../assets/animations/one-by-one3.png", "Step 3"),
  ),
  columns: 3,
  max-width: 100%,
)

#calepin.elements.callout[
  The previous results can be obtained by using `pause` as follows:
  ```typ
  #slide[`#one-by-one` example][
    I am #pause not a #pause robot
  ]
  ```
]

= Item by item

`item-by-item` is a function that allows you to reveal items in a list one at a time. It is particularly useful for emphasizing key points in a list.

```typ
#let item-by-item(
  start: 1,
  hide-color: none,
  hide-fn: none
)
```

#argument-callout("start", "int", default: 1)[The starting step for the reveal. The first element will be revealed on this step.]

#argument-callout("hide-color", "color", default: none)[The color to use for hidden elements. If set to `none`, the hidden elements will be completely invisible.]

#argument-callout("hide-fn", "function", default: none)[A function that can be used to provide custom masking for hidden elements. If set to `none`, the default hiding behavior will be used.]

```typ
#slide[`#item-by-item` example][
  #item-by-item[
    - I am the first item, visible on the first subslide
    - I am the second item, visible on the second subslide
    - I am the third item, visible on the third subslide
  ]
]
```

#calepin.elements.gallery(
  (
    ("../assets/animations/item-by-item1.png", "Step 1"),
    ("../assets/animations/item-by-item2.png", "Step 2"),
    ("../assets/animations/item-by-item3.png", "Step 3"),
  ),
  columns: 3,
  max-width: 100%,
)

#calepin.elements.callout[
  The previous results can be obtained by using `pause` as follows:
  ```typ
  #slide[`#item-by-item` example][
    - I am the first item, visible on the first subslide
    #pause
    - I am the second item, visible on the second subslide
    #pause
    - I am the third item, visible on the third subslide
  ]
```
]
