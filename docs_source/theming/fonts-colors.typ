#import "/.calepin/calepin.typ" as calepin
#import "../doc-utils.typ": *

#set document(title: [Fonts and colors])
#metadata((tags: ("theming", "fonts", "colors"))) <website-metadata>


#html.elem("p", attrs: (style: "font-size: 2em; font-weight: bold;"))[Fonts and colors customization]

Sometimes, you may want to use a built-in theme, but customize the fonts and colors used in your presentation to match your branding or personal preferences. Slydekit allows you to easily override the default fonts and colors by providing your own definitions.

= Fonts

To use a custom font set, you have to provide to `slydekit` a `fonts` argument with a dictionary containing the following keys:
#argument-callout(kind: "Key", "size", "string", default: ["20pt"])[
Size of the main text in the presentation.
]

#argument-callout(kind: "Key", "body", "string | array", default: ["New Computer Modern"])[
Font family for the main text in the presentation.
]

#argument-callout(kind: "Key", "math", "string | array", default: ["New Computer Modern Math"])[
Font family for mathematical symbols and equations in the presentation.
]

#argument-callout(kind: "Key", "raw", "string | array", default: ["DejaVu Sans Mono"])[
Font family for raw text, such as code snippets or monospaced text.
]

Let's say you want to use the "Lete Sans Math" font for mathematical symbols and equations, and "Roboto" or "Cascadia Code" (depending on the font availability) for raw text, with a font size of 25pt. You can define your custom fonts as follows:
```typ
#let my-fonts = (
  size: 25pt,
  math: "Lete Sans Math",
  raw: ("Roboto", "Cascadia Code")
)
```

Then, you can apply these custom fonts to your presentation by passing the `my-fonts` dictionary to the `slydekit` function:
```typ
#show: slydekit.with(
  fonts: my-fonts,
)
```

#calepin.elements.callout(kind: "Note")[
  It is not necessary to provide all the keys in the `fonts` dictionary. If you only want to change the font for mathematical symbols, you can just provide the `math` key, and the other fonts will remain as their default values.

  You can extend the fonts dictionary with additional keys, but they will not be used by the `slydekit` function. The only keys that are recognized are `size`, `body`, `math`, and `raw`. However, you can use the `sk-states.fonts` state to store additional font information and use it in your custom themes or styles.
]

= Colors

The colors cusotmization works similarly to the fonts customization. You can provide a `colors` argument to the `slydekit` function with a dictionary containing the following keys:
#argument-callout(kind: "Key", "primary", "color")[
Primary color of the presentation.
]

#argument-callout(kind: "Key", "secondary", "color")[
Secondary color.
]

#argument-callout(kind: "Key", "focus", "color")[
Background color of the focus slide.
]

#argument-callout(kind: "Key", "background", "color")[
Background color of the slides.
]

#argument-callout(kind: "Key", "header", "color")[
Color of the header.
]

#argument-callout(kind: "Key", "footer", "color")[
Color of the footer.
]

Let's say you want to use a different primary color, a light gray background, and a dark gray footer. You can define your custom colors as follows:
```typ
#let my-colors = (
  primary: rgb("#FF5733"),
  background: rgb("#F0F0F0"),
  footer: rgb("#333333")
)
```

Then, you can apply these custom colors to your presentation by passing the `my-colors` dictionary to the `slydekit` function:
```typ
#show: slydekit.with(
  colors: my-colors,
)
```

#calepin.elements.callout(kind: "Note")[
  While the `fonts` dictionary has a default set of fonts, that are applied during the slidekit initialization, the `colors` dictionary does not have a default set of colors. If you do not provide a `colors` argument to the `slydekit` function, no colors will be applied.

  This is a deliberate design choice, as it allows you to have a clean slate for your color customization. You can define your own color scheme without being constrained by a predefined set of colors.
]

