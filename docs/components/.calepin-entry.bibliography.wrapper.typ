#let _calepin-document-element = document
#import "/.calepin/calepin.typ": *
#let document = _calepin-document-element

#let _calepin-expected-generation = "ed50155d42c5cdaa-1349cde127705c16"
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



#show raw.where(block: true, lang: "typ", theme: auto): it => _without-raw-chunk-transforms(() => _html-themed-raw-block(it))
#show raw.where(block: true, lang: "typst", theme: auto): it => _without-raw-chunk-transforms(() => _html-themed-raw-block(it))
#show raw.where(block: true, lang: "python", theme: auto): it => if _disable-raw-chunk-transforms.get() { _html-themed-raw-block(it) } else { _fenced-chunk("python", it) }
#show raw.where(block: true, lang: "r", theme: auto): it => if _disable-raw-chunk-transforms.get() { _html-themed-raw-block(it) } else { _fenced-chunk("r", it) }
#show raw.where(block: true, lang: "mermaid", theme: auto): it => if _disable-raw-chunk-transforms.get() { _html-themed-raw-block(it) } else { _fenced-chunk("mermaid", it) }
#show raw.where(block: true, lang: "dot", theme: auto): it => if _disable-raw-chunk-transforms.get() { _html-themed-raw-block(it) } else { _fenced-chunk("dot", it) }
#show raw.where(block: true, lang: "tikz", theme: auto): it => if _disable-raw-chunk-transforms.get() { _html-themed-raw-block(it) } else { _fenced-chunk("tikz", it) }
#show raw.where(block: true, lang: "d2", theme: auto): it => if _disable-raw-chunk-transforms.get() { _html-themed-raw-block(it) } else { _fenced-chunk("d2", it) }

#show raw.where(block: true, theme: auto): it => {
  if _is-query() {
    it
  } else if _disable-raw-chunk-transforms.get() {
    _html-themed-raw-block(it)
  } else if it.has("lang") and it.lang != none and _raw-chunk-langs.contains(it.lang) and _fenced-chunks-runs(
    it.lang,
    _resolve-options(it.lang, _call-defaults).at("fenced-chunks"),
  ) {
    _fenced-chunk(it.lang, it)
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

#show: _default-chunk-chrome

// Notebook theme
#import "/.calepin/calepin.typ" as calepin
#import "../doc-utils.typ": *

#set document(title: [Bibliography])
#metadata((tags: ("bibliography", "citations"))) <website-metadata>


#html.elem("p", attrs: (style: "color: var(--calepin-color-link); font-size: 2em; font-weight: bold;"))[Bibliography]

Slydekit provides a built-in bibliography feature that allows you to manage and display references in your presentation. You can use the built-in Typst `#bibliography` function to include a bibliography section in your slides, and the `#footcite` function to create footnotes for citations.

```typ
#let footcite(
  key,
  supplement: none
)
```

#argument-callout("key", "label")[The citation key corresponding to the reference in the bibliography.]

#argument-callout("supplement", "string", default: [none])[An optional supplement to the citation. See the documentation of the #link("https://typst.app/docs/reference/model/cite/", "Typst cite function") for more information.]

This function can be used directly in your slides. Alternatively, you can use the `@` syntax to create a footnote for a citation. For example, `@knuth` creates a footnote for the reference with the citation key `knuth`. To call the function explicitly, use the `#footcite(<key>)` syntax, where `<key>` is the citation key.

```typ
#import "@preview/slydekit:0.4.0": *

#show: slydekit.with(...)

== Footcite example

#lorem(10)@knuth

== Bibliography
#bibliography(
  bytes(
    raw(lang: "bib",
    "@book{knuth,
      title={The Art of Computer Programming},
      author={Donald E. Knuth},
      year={1968},
      publisher={Addison-Wesley},
    }").text
  ),
  style: "ieee",
)
```

#calepin.elements.gallery(
  (
    ("../assets/components/bibliography1.png", "Bibliography - Footcite example", [Bibliography - Footcite example]),
    ("../assets/components/bibliography2.png", "Bibliography - Section example", [Bibliography - Section example]),
  ),
  columns: 2,
  max-width: 100%,
)
