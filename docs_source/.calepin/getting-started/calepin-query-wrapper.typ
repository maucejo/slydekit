#let _calepin-document-element = document
#import "/.calepin/calepin.typ": *
#let document = _calepin-document-element



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
#import "@preview/zebraw:0.6.3": *

#show: zebraw-init

#let argument-callout(name, type, default, body) = html.elem("div", attrs: (
  style: "position: relative; margin: 1.2em 0; padding: 1.1rem 1.1rem 0rem 1.1rem; border: 1px solid #d7ccff; border-left: 4px solid #7b61d1; border-radius: 0.9rem; background: linear-gradient(135deg, #faf7ff, #f3eeff); box-shadow: 0 6px 18px rgba(101, 76, 163, 0.08); margin-bottom: 2.5em;"
))[
  #html.elem("div", attrs: (
    style: "position: absolute; top: -0.8rem; left: 0.8rem; padding: 0.2rem 0.55rem; font-weight: 700; font-size: 0.8rem; color: #654ca3; background: #f3eeff; border: 1px solid #d7ccff; border-radius: 999px;"
  ))[Argument]

  #html.elem("div", attrs: (style: "margin-top: 0.4rem; display: flex; justify-content: space-between; align-items: baseline; gap: 1rem; font-family: ui-monospace, monospace;"))[
    #html.elem("div", attrs: (style: "display: inline-block;"))[
      #html.elem("code", attrs: (style: "color: #654ca3; font-weight: 700;"))[#name -- default: #default]
    ]
    #html.elem("div", attrs: (style: "margin-left: auto; display: inline-block;"))[
      #html.elem("span", attrs: (style: "color: #7a7a7a;"))[#type]
    ]
  ]

  #body
]

#set document(title: [Getting started])
#metadata((tags: ("getting started", "import", "basic usage"))) <website-metadata>

#html.elem("p", attrs: (style: "font-size: 2em; font-weight: bold;"))[Getting started]

This section introduces the basic workflow for creating presentations with Slydekit. You will first learn how to import the template and configure the main presentation settings. Then, a minimal example will demonstrate the core structure of a Slydekit document, including how to create slides and organize content.

= Import the template

To use the `slydekit` template, you need to include the following line at the beginning of your `typ` file:

#zebraw(
  numbering: false,
```Typst
#import "@preview/slydekit:0.1.0": *
```
)

= Template initialization

After importing the template, you have to initialize the template by a show rule with the `#slydekit` command. This function takes a set of optional arguments that allow you to customize the presentation's appearance and behavior.

#zebraw(
  numbering: false,
```Typst
#show: slydekit.with(
  title: "Title",
  subtitle: "Subtitle",
  short-title: "Short title",
  author: "Author",
  date: "Date",
  institution: "Institution",
  contact: none,
  theme: simple,
  fonts: none,
  colors: none,
  lang: "en",
  aspect-ratio: "16-9",
  navigation: "topbar",
  title-logo: (),
  slide-logo: none,
  handout: false,
)
```
)

#html.elem("div", attrs: (style: "margin-top: 2.5em;"))[]

#argument-callout("title", [string | content], ["Title"])[
Main title of the presentation
]

#argument-callout("subtitle", [string | content], ["Subtitle"])[
Optional subtitle for the presentation
]

#argument-callout("short-title", [string | content], ["Short title"])[
Shorter version of the title for use in headers or footers
]

#argument-callout("author", [string | content], ["Author"])[
Name of the author(s) or presenter(s)
]

#argument-callout("date", [string | content], ["Date"])[
Date of the presentation
]

#argument-callout("institution", [string | content], ["Institution"])[
Name of the institution or organization associated with the presentation
]

#argument-callout("contact", [string | content], [none])[
Contact information for the author(s) or presenter(s), such as an email address or website (optional)
]

#argument-callout("theme", [theme], [simple])[
The theme to be used for the presentation. Available themes include `simple`, `fancy`, `metropolis`, `cambfurt`, and `chalkboard`. You can also create your own custom theme by defining a new theme in your Typst document.
]

#argument-callout("fonts", [dictionary], [none])[
Custom fonts to be used in the presentation. You can specify a set of fonts to override the default fonts provided by the selected theme. If not specified, the theme's default fonts will be used.
]

#argument-callout("colors", [dictionary], [none])[
Custom colors to be used in the presentation. You can specify a set of colors to override the default colors provided by the selected theme. If not specified, the theme's default colors will be used.
]

#argument-callout("lang", [string], ["en"])[
Language of the presentation. This can be set to any valid language code (e.g., "en" for English, "fr" for French, etc.). The language setting affects the localization of certain elements in the presentation, such as the table of contents and navigation labels.
]

#argument-callout("aspect-ratio", [string], ["16-9"])[
Aspect ratio of the slides. Common values include "16-9" for widescreen presentations and "4-3" for standard presentations. This setting determines the dimensions of the slides and how they will be displayed on different screens and devices.
]

#argument-callout("navigation", [string], ["topbar"])[
Navigation style for the presentation. Available options include "topbar" for a top navigation bar, "minislide" for a mini slide navigation, and other custom navigation styles that can be defined in your Typst document. This setting affects how users can navigate through the slides during the presentation.
]

#argument-callout("title-logo", [array], [()])[
Logo to be displayed on the title slide. You can provide an image file (e.g., PNG, SVG) to be displayed alongside the title and subtitle on the first slide of the presentation.
]

#argument-callout("slide-logo", [image], [none])[
Logo to be displayed on each slide. You can provide an image file (e.g., PNG, SVG) to be displayed in a consistent location on every slide of the presentation. This is useful for branding or to include a small logo throughout the presentation.
]

#argument-callout("handout", [bool], [false])[
Whether to generate a handout version of the presentation. If set to `true`, the presentation will be formatted for printing or distribution as a handout, which may include additional notes or a different layout suitable for paper or PDF distribution. If set to `false`, the presentation will be formatted for on-screen viewing.
]

= Basic usage
