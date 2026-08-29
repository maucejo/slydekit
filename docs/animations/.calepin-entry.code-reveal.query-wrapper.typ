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

#set document(title: [Code animation])
#metadata((tags: ("animations", "code-reveal", "codly", "zebraw"))) <website-metadata>

#html.elem("p", attrs: (style: "color: var(--calepin-color-link); font-size: 2em; font-weight: bold;"))[Code animation]

The code animation feature allows you to highlight specific lines of code in a step-by-step manner during a presentation. This can be particularly useful for explaining complex code snippets or algorithms, as it enables the presenter to focus the audience's attention on one part of the code at a time.

= Basics

Slydekit provides the `code-reveal` function that can be used to create this effect.

```typ
#let code-reveal(
  highlight-lines: (:),
  hide-lines: (:),
  renderer: raw-renderer(),
  body,
)
```

#argument-callout("highlight-lines", [dictionary], default: [(:)])[Lines to highlight during the code reveal animation.

The dictionary keys are strings representing the line numbers of the code snippet, and the values are either integers or arrays of integers indicating the subslide numbers on which the corresponding lines should be highlighted. For example, `("2": 1, "4": 2)` means that line 2 will be highlighted on subslide 1, and line 4 will be highlighted on subslide 2.]

#argument-callout("hide-lines", [dictionary], default: [(:)])[Lines to hide during the code reveal animation.

The dictionary keys are strings representing the line numbers of the code snippet, and the values are either integers or arrays of integers indicating the subslide numbers from which the corresponding lines should be visible. For example, `("3": 2, "4": 3)` means that line 3 will be visible from subslide 2, and line 4 will be visible from subslide 3.]

#argument-callout("renderer", [function], default: [raw-renderer()])[The function used to render the code snippet. This can be a custom renderer or one of the provided renderers, namely `raw-renderer`, `codly-renderer`, or `zebraw-renderer`.]

#argument-callout("..args", [list])[Additional arguments to be passed to the renderer function. These arguments can be used to customize the appearance of the code snippet and are specific to the chosen renderer.]

#argument-callout("body", [content])[The code snippet to be animated. This should be a block of code written in the desired programming language, enclosed within triple backticks (```` ``` ````) and optionally specifying the language for syntax highlighting.]

= Renderers

Slydekit provides three built-in renderers for the `code-reveal` function: `raw-renderer`, `codly-renderer`, and `zebraw-renderer`. Each renderer has its own set of customization options and can be used to achieve different visual effects for the code animation.

== Native Typst raw renderer

```typ
#let raw-renderer(
  highlight-color: luma(90%),
  ..args
)
```

#argument-callout("highlight-color", [color], default: [luma(90%)])[The color used to highlight the active lines of code. This can be any valid color value in Typst, such as a named color, a hex code, or an RGB value.]

#argument-callout("..args", [list])[Additional arguments to be passed to the `raw` function. See the #link("https://typst.app/docs/reference/text/raw/", "Typst documentation") for the `raw` function for the complete list of available arguments.]

````typ
#import "@preview/slydekit:0.4.0": *

#show: slydekit

#let code = ```python
def fib(n):
  if n <= 1:
      return n
  return fib(n-1) + fib(n-2)
```

== Code animation - Raw renderer

#code-reveal(
  highlight-lines: ("2": 2, "4": 3),
  hide-lines: ("3": 2, "4": 3)
)[#code]
````

#calepin.elements.gallery(
  (
    ("../assets/animations/raw-renderer1.png", "Step 1"),
    ("../assets/animations/raw-renderer2.png", "Step 2"),
    ("../assets/animations/raw-renderer3.png", "Step 3"),
  ),
  columns: 3,
  max-width: 100%,
)

== Codly renderer

```typ
#let codly-renderer(
  codly-fn,
  highlight-color: luma(90%),
  ..args
)
```

#argument-callout("codly-fn", [function])[The Codly function used to render the code snippet. This must be the `codly` function.

#calepin.elements.callout[
  The fact that the `codly` function is used as an argument avoids having `codly` as a direct dependency of Slydekit, which would require the user to install the `codly` package. Instead, the user can choose to use `codly` or not, depending on their needs.
]
]

#argument-callout("highlight-color", [color], default: [luma(90%)])[The color used to highlight the active lines of code. This can be any valid color value in Typst, such as a named color, a hex code, or an RGB value.]

#argument-callout("..args", [list])[Additional arguments to be passed to the `codly` function. See the #link("https://github.com/Dherse/codly/blob/main/docs.pdf", "Codly documentation") for the complete list of available arguments.]

````typ
#import "@preview/slydekit:0.4.0": *
#import "@preview/codly:1.3.0": *
#import "@preview/codly-languages:0.1.10": *

#show: codly-init
#codly(languages: codly-languages)

#show: slydekit

#let code = ```python
def fib(n):
  if n <= 1:
      return n
  return fib(n-1) + fib(n-2)
```

== Code animation - Codly renderer

#show: codly-init
#code-reveal(
  highlight-lines: ("2": 2, "4": 3),
  hide-lines: ("3": 2, "4": 3),
  renderer: codly-renderer(codly, highlight-color: rgb("#a6b0e8")))[#code]
````

#calepin.elements.gallery(
  (
    ("../assets/animations/codly-renderer1.png", "Step 1"),
    ("../assets/animations/codly-renderer2.png", "Step 2"),
    ("../assets/animations/codly-renderer3.png", "Step 3"),
  ),
  columns: 3,
  max-width: 100%,
)

== Zebraw renderer

```typ
#let zebraw-renderer(
  zebraw-fn,
  highlight-color: rgb("e0f5f2"),
  ..args
)
```

#argument-callout("zebraw-fn", [function])[The Zebraw function used to render the code snippet. This must be the `zebraw` function.

#calepin.elements.callout[
  The fact that the `zebraw` function is used as an argument avoids having `zebraw` as a direct dependency of Slydekit, which would require the user to install the `zebraw` package. Instead, the user can choose to use `zebraw` or not, depending on their needs.
]
]

#argument-callout("highlight-color", [color], default: [rgb("e0f5f2")])[The color used to highlight the active lines of code. This can be any valid color value in Typst, such as a named color, a hex code, or an RGB value.]

#argument-callout("..args", [list])[Additional arguments to be passed to the `zebraw` function. See the #link("https://github.com/hongjr03/typst-zebraw", "Zebraw documentation") for the complete list of available arguments.]

````typ
#import "@preview/slydekit:0.4.0": *
#import "@preview/zebraw:0.6.3": *

#show: slydekit

#let code = ```python
def fib(n):
  if n <= 1:
      return n
  return fib(n-1) + fib(n-2)
```

== Code animation - Zebraw renderer

#show: zebraw-init
#code-reveal(
  highlight-lines: ("2": 2, "4": 3),
  hide-lines: ("3": 2, "4": 3),
  renderer: zebraw-renderer(zebraw)
)[#code]
````

#calepin.elements.gallery(
  (
    ("../assets/animations/zebraw-renderer1.png", "Step 1"),
    ("../assets/animations/zebraw-renderer2.png", "Step 2"),
    ("../assets/animations/zebraw-renderer3.png", "Step 3"),
  ),
  columns: 3,
  max-width: 100%,
)


