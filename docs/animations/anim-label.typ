#import "/.calepin/calepin.typ" as calepin
#import "../doc-utils.typ": *

#set document(title: [Animated slide labels])
#metadata((tags: ("animations", "label"))) <website-metadata>

#html.elem("p", attrs: (style: "color: var(--calepin-color-link); font-size: 2em; font-weight: bold;"))[Animated slide labels]

Let imagine a scenario where you want tonavigate to a specific slide of an animation sequence. For this purpose you want to assign a label to a specific sub-slide, and then use that label to navigate directly to that slide using a link. Slydekit provides the `anim-label` function to this end.

```typ
#let anim-label(
  label,
  step: 1,
)
```

#argument-callout("label", [label])[The label to assign to the current sub-slide.]

#argument-callout("step", [integer], default: [1])[The step number of the current sub-slide. This is used to determine which sub-slide the label should be assigned to.]

== Example usage

```typ
// Slide with pause

== Slide with pause

Pause the animation at this point #anim-label(<my-label>, step: 1) and assign a label to the current sub-slide.
```