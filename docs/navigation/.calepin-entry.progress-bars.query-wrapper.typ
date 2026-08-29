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

#set document(title: [Progress bars])
#metadata((tags: ("outline", "toc", "progressive outline"))) <website-metadata>

#html.elem("p", attrs: (style: "color: var(--calepin-color-link); font-size: 2em; font-weight: bold;"))[Progress bars]

Slydekit provides progress bars to indicate either the progress of the section or the progress of the entire presentation. These function are intended to be used in a custom theme.

All the progress bars are built upon the `progress-bar` function, whose signature is:
```typ
#let progress-bar(
  ratio,
  active-color,
  inactive-color,
  row-height: (),
  gutter: ()
)
```

#argument-callout("ratio", [number])[
The ratio of the progress bar, which is a number between 0 and 1. For example, a ratio of 0.5 means that the progress bar is half filled.]

#argument-callout("active-color", [color])[
The color used to fill the active part of the progress bar.]

#argument-callout("inactive-color", [color])[
The color used to fill the inactive part of the progress bar.]

#argument-callout("row-height", [length], default: [()])[
The height of the progress bar. If not specified, the height will be determined by the content]

#argument-callout("gutter", [length], default: [()])[
The gutter between the active and inactive parts of the progress bar. If not specified, the gutter will be determined by the content]

= Section progress bar

Section progress bar is a horizontal bar that indicates the progress of the current section in relation to the total number of sections in the presentation.

```typ
#let section-progress-bar(active-color, inactive-color)
```

#argument-callout("active-color", [color])[
The color used to fill the active section indicator.]

#argument-callout("inactive-color", [color])[
The color used to fill the inactive section indicators.]

For example, in the `metropolis` theme, `section-progress-bar` is used as follows:
```typ
#let color-theme = (
  primary: rgb("#eb811b"),
  secondary: rgb("#d6c6b7"),
  focus: rgb("#23373b"),
  background: rgb("#fafafa"),
  header: rgb("#23373b"),
  footer: rgb("#23373b").lighten(20%),
)

#show heading.where(level: 1): it => {
    // Formatting the content
    ...

    // Using the section progress bar
    stack(
      dir: ttb,
      spacing: 0.5em,
      [*#it.body*],
      block(
        height: 2pt,
        width: 100%,
        spacing: 0pt,
        section-progress-bar(colors-theme.primary, colors-theme.secondary)
      ),
    )
  }
```

= Slide progress bar

Slide progress bar is a horizontal bar that indicates the progress of the current slide in relation to the total number of slides in the presentation.

```typ
#let slide-progress-bar(active-color, inactive-color, height: 2pt)
```

#argument-callout("active-color", [color])[
The color used to fill the active slide indicator.]

#argument-callout("inactive-color", [color])[
The color used to fill the inactive slide indicators.]

#argument-callout("height", [number], default: [2pt])[
The height of the progress bar. The default value is `2pt`.]

For example, in the `metropolis` theme, `slide-progress-bar` is used in the footer of the slide as follows:

```typ
let footer = context {
      // Footer content
      ...

      // Progress bar
      #full-width(anchor: bottom, slide-progress-bar(colors-theme.primary, colors-theme.secondary, height: 2.5pt))
    ]
  }
```
