#import "/.calepin/calepin.typ" as calepin
#import "../doc-utils.typ": *

#set document(title: [Interrupted animations])
#metadata((tags: ("animations", "interrupted", "render-animation", "resume"))) <website-metadata>

#html.elem("p", attrs: (style: "color: var(--calepin-color-link); font-size: 2em; font-weight: bold;"))[Interrupted animations]

Sometimes an animation needs to be split across several slides. In this case, you reveal the first steps, switch to another slide to explain or show something else, then come back and continue the same animation from where it stopped.

The `render-animation` function makes this usecase possible. You write the animated content once and render it in windows. Every window re-displays the
earlier steps in their fully-revealed, static state and animates only the steps
it is responsible for.

= render-animation

```typ
#let render-animation(
  ..int-or-range,
  from: 1,
  to: none,
  body,
)
```

#argument-callout("int-or-range", [int], default: [(none)])[
Positional step numbers naming the window this call renders. A render window is
contiguous by nature (you cannot resume steps 2 and 4 while skipping 3 on one
slide), so a list is taken as its span:

#table(
  columns: (auto, 1fr),
  stroke: 0.5pt + luma(80%),
  [(nothing) + no `from:` / `to:`], [the whole animation (behaves like dropping `body` inline)],
  [`3`], [only global step 3],
  [`2, 4`], [global steps 2 through 4 (the span of the list)],
)
]

#argument-callout("from", [int], default: [1])[
First step of the window, when no positional step numbers are given. `from: 3`
renders global step 3 to the last step.
]

#argument-callout("to", [int | none], default: [none])[
Last step of the window. `none` means the animation's last step. `to: 2` renders
global steps 1 through 2.
]

#argument-callout("body", [content])[
The reusable animated block, passed last (as in `#uncover(2, body)`). It may use
any Slydekit animation vocabulary -- `#pause`, `#meanwhile`, `#uncover`, `#only`,
`#alternatives`, and pauses nested inside a layout wrapper such as
`#align(..)[..]` or `block(..)`. Bind it once with `#let my-anim = [ .. ]` and
pass the same value to every `render-animation` call.
]

Out-of-range values are clamped to the animation's real length.

= Example

```typ
#let derivation = [
  We start from the identity.
  #pause
  Apply the substitution $u = x^2$.
  #pause
  Integrate term by term.
  #pause
  And simplify the result.
]

== The setup

#render-animation(1, 2, derivation)

== A quick reminder

The chain rule states that $(f compose g)' = (f' compose g) dot g'$.

== Back to the derivation

#render-animation(from: 3, derivation)
```

On *The setup* the first two lines appear one after another. *A quick reminder*
is an ordinary slide in between. *Back to the derivation* shows the first two
lines already in place (no animation) and then reveals the last two, one per
step -- the audience never sees the animation restart.

#calepin.elements.callout(kind: "Note")[
The enclosing slide automatically gets exactly as many sub-steps as the window
asks for (`end - start + 1`), regardless of the absolute step numbers used inside
`body`. You never declare the slide's own `steps:` by hand for a `render-animation` call.
]

#calepin.elements.callout(kind: "Note")[
`render-animation` works by briefly re-pointing Slydekit's shared subslide clock
while it renders `body`, so packages that read that clock (CeTZ / Fletcher via
`#reveal`, `#anim-label`, ...) resume correctly too. In `handout: true` mode each
window collapses to a single page showing its final state.
]

#calepin.elements.callout(kind: "Note")[
When `from:` / `to:` are omitted and no step numbers are given, the whole
animation is rendered -- `render-animation(body)` behaves exactly like dropping
`body` inline. The window is always clamped to the animation's real length.
]
