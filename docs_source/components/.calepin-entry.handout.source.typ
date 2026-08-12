#import "/.calepin/calepin.typ" as calepin
#import "../doc-utils.typ": *

#set document(title: [Handout mode])
#metadata((tags: ("handout", "mode"))) <website-metadata>


#html.elem("p", attrs: (style: "color: var(--calepin-color-link); font-size: 2em; font-weight: bold;"))[Handout mode]

The handout mode in Slydekit allows you to create a version of your presentation that is suitable for printing or sharing as a PDF. This mode is designed to provide a more compact and readable format, making it easier for your audience to follow along with your presentation.

By design, the handout mode keeps the same structure as the main presentation, but it removes any animated elements, while keeping the last state of the slide. This means that all content will be visible at once, without the need for any interactions or pauses.

#calepin.elements.callout(kind: "warning")[
  Animated elements that are not visible on the last state of a slide will not be included in the handout mode.
]

To enable the handout mode, you have to set the `handout` parameter to `true` in the `slydekit` function:
```typ
#show: slydekit.with(
  handout: true,
)
```