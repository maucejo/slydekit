#import "/.calepin/calepin.typ" as calepin
#import "../doc-utils.typ": *

#set document(title: [Slides])
#metadata((tags: ("slides"))) <website-metadata>

#html.elem("p", attrs: (style: "color: var(--calepin-color-link); font-size: 2em; font-weight: bold;"))[Slides]

= Generic slides

The main building block of the Slydekit framework is the `slide` function, which is used to create individual slides in a presentation.

```typ
#let slide(
  title,
  steps: none
  label: none,
  body
)
```

#argument-callout("title", [string | content])[
  The title of the slide.
]

#argument-callout("steps", [int | none], default: [none])[
  The number of steps in the slide. This is used to create incremental slides, where content is revealed step by step.
  This is required to animate slides using CeTZ or Fletcher, but optional for other animations.
]

#argument-callout("label", [label | none], default: [none])[
  An optional label for the slide. This can be used to reference the slide later in the presentation.
]

#argument-callout("body", [content])[
  The content of the slide.]

Practically, a slide can be defined in various ways:
```typ
// Markup-based slide + label
== Title <label>

Content of the slide

// Slide function + label
#slide("Title", label: <label>)[
  Content of the slide
]

// Slide function
#slide[
  Content of the slide
]
```

#calepin.elements.callout[
  `slide("Title")[...]` creates a slide with the specified title. When a slide is defined as `slide[...]`, its title is automatically inherited from the previous slide.
]

= Custom slides

There are several ways to define custom slides, which can be used to create slides with different layouts and styles. For instance, the `focus-slide` function used for capturing the audience's attention is defined as follows in the built-in themes:
```typ
// Focus slide of the simple theme
#let simple-focus-slide(body) = context {
  set page(header:none, footer: none, fill: sk-states.colors.get().focus)
  set align(center + horizon)
  text(size: 2em, fill: white)[*#body*]

  // Decrement the page counter to avoid counting the focus slide as a regular slide
  counter(page).update(n => n - 1)
}
```

If you want to create your own custom focus slide, that can use animations and other features, you can use the `slide` function to define it. For example:
```typ
#let my-focus-slide(..args) = {
  set align(center + horizon)
  set text(fill: white, size: 5em)
  set page(header: none, footer: none, fill: rgb("#5E8B65"))

  slide(..args)

  // Freeze the slide number to avoid incrementing it for focus slides
  sk-states.slide-number.update(n => n - 1)
}

```

Then, you can use it in your presentation like this:
```typ
#my-focus-slide[
  *Hey* #pause *ho!*
]
```

#calepin.elements.gallery(
  (
    ("../assets/components/my-focus-slide1.png", "Focus slide - Simple theme", [Custom Focus slide - Step 1]),
    ("../assets/components/my-focus-slide2.png", "Focus slide - Metropolis theme", [Custom Focus slide - Step 2]),
  ),
  columns: 2,
  max-width: 100%,
)