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