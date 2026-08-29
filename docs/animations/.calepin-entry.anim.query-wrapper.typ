#let _calepin-document-element = document
#import "/.calepin/calepin.typ": *
#let document = _calepin-document-element



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

#set document(title: [Animation system])
#metadata((tags: ("animations"))) <website-metadata>

#html.elem("p", attrs: (style: "color: var(--calepin-color-link); font-size: 2em; font-weight: bold;"))[Animation system]

The animation system in Slydekit allows you to create dynamic and interactive presentations by controlling the visibility and behavior of content on slides.

// In Slydekit, animations must be encapuslated in a `slide` (See  #link("components/slide.html","Slide")). This means that you cannot apply animations to content outside of a slide context, i.e. in markup mode. This behavior is similar to that used in other presentation frameworks, such as #link("https://typst.app/universe/package/touying/", "Touying") or #link("https://typst.app/universe/package/minideck/","Minideck").

The animation system provides a set of predefined animations that can be used to enhance your presentations. These animations include

- `pause`, `uncover`, and `only`, which allow you to control the flow of your presentation and create engaging visual effects.

- `meanwhile` and `track`, which allows you to create parallel animations that can be used to illustrate complex concepts or processes.

- `item-by-item`, which allows you to reveal content one item at a time, creating a sense of anticipation and engagement.

- `draw-reveal`, which allows you to reveal content in a specific order. This function is mainly used for integration with #link("https://typst.app/universe/package/cetz/", "CeTZ") and #link("https://typst.app/universe/package/fletcher/", "Fletcher").
