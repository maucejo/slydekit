// HTML documentation helpers, adapted from the PDF manual (docs-pdf/docutils.typ)

// Type colors (CSS values)
#let default-type-color = "#eff0f3"
#let gradient-for-color-types = "linear-gradient(97deg, #7cd5ff 0%, #a6fbca 33%, #fff37c 66%, #ffa49d 100%)"
#let gradient-for-tiling = "repeating-linear-gradient(45deg, #ffd2ec 0 0.3em, #c6feff 0.3em 0.6em)"

#let colors = (
  "default": default-type-color,
  "default-param": "#b50256",
  "content": "#a6ebe6",
  "string": "#d1ffe2",
  "str": "#d1ffe2",
  "label": "#a7eaff",
  "none": "#ffcbc4",
  "auto": "#ffcbc4",
  "bool": "#ffedc1",
  "boolean": "#ffedc1",
  "integer": "#e7d9ff",
  "int": "#e7d9ff",
  "float": "#e7d9ff",
  "ratio": "#e7d9ff",
  "length": "#e7d9ff",
  "angle": "#e7d9ff",
  "relative length": "#e7d9ff",
  "relative": "#e7d9ff",
  "fraction": "#e7d9ff",
  "symbol": default-type-color,
  "array": default-type-color,
  "dictionary": default-type-color,
  "dict": default-type-color,
  "arguments": default-type-color,
  "args": "#4428c1",
  "selector": default-type-color,
  "module": default-type-color,
  "stroke": default-type-color,
  "function": "#f9dfff",
  "image": "#f9dfff",
  "counter": default-type-color,
  "color": gradient-for-color-types,
  "gradient": gradient-for-color-types,
  "tiling": gradient-for-tiling,
  "signature-func-name": "#4b69c6",
)

// Plain-text extraction from content (used to parse type specifications)
#let _to-str(it) = {
  if it == none { "" } else if type(it) == str { it } else if it.has("text") { it.text } else if it.has("children") {
    it.children.map(_to-str).join("")
  } else if it.has("body") { _to-str(it.body) } else if it == [ ] { " " } else { "" }
}

// Type pill
#let mtype(t) = {
  let t = _to-str(t).trim()
  let bg = colors.at(t, default: default-type-color)
  html.elem("span", attrs: (
    style: "display: inline-block; background: "
      + bg
      + "; color: #19181f; border-radius: 0.25em; padding: 0.1em 0.4em; font-size: 0.8em; font-family: ui-monospace, monospace; line-height: 1.4; white-space: nowrap;",
  ))[#t]
}

// Several type pills from a specification such as "string | content"
#let _types(spec) = {
  let parts = _to-str(spec).split("|").map(s => s.trim()).filter(s => s != "")
  for (i, p) in parts.enumerate() {
    if i > 0 {
      html.elem("span", attrs: (style: "margin: 0 0.25em; color: var(--calepin-color-text, inherit); opacity: 0.6;"))[|]
    }
    mtype(p)
  }
}

#let _box-style = "position: relative; margin: 2em 0 1.5em 0; padding: 1.1rem 0.9rem 0.1rem 0.9rem; border: 1px solid #b3b4b6; border-radius: 4px;"

#let _box-label(kind) = html.elem("div", attrs: (
  style: "position: absolute; top: -0.75em; left: 0.6rem; padding: 0 0.35rem; background: var(--calepin-color-background, white); line-height: 1.5;",
))[#kind]

// Argument box with name, default value and types
#let argument-callout(kind: "Argument", name, type, default: none, body) = html.elem("div", attrs: (style: _box-style))[
  #_box-label(kind)

  #html.elem("div", attrs: (
    style: "display: flex; justify-content: space-between; align-items: baseline; flex-wrap: wrap; gap: 0.5rem 1rem; font-size: 0.9em;",
  ))[
    #html.elem("span", attrs: (style: "font-family: ui-monospace, monospace;"))[
      #set smartquote(enabled: false)
      #html.elem("span", attrs: (style: "color: " + colors.args + ";"))[\<#name\>]#if (
        default != none
      ) [: #html.elem("span", attrs: (style: "color: " + colors.default-param + ";"))[#default]]
    ]
    #html.elem("span", attrs: (style: "margin-left: auto;"))[#_types(type)]
  ]

  #html.elem("br")
  #body
]

// Argument box without name/type header
#let argument-callout-(kind: "Argument", body) = html.elem("div", attrs: (style: _box-style))[
  #_box-label(kind)

  #html.elem("br")
  #body
]
