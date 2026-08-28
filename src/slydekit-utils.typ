#import "slydekit-defaults.typ": *
#import "slydekit-animation.typ": split-at-pause, split-at-meanwhile, analyze-max-step

// Slides
#let slide(..args, steps: none, label: none) = {
  // Extraction and analysis of the positional arguments: title and body. If no title is provided, the first argument is the body. If two arguments are provided, the first is the title and the second is the body.
  let pos = args.pos()
  let (title, body) = if pos.len() == 0 {
    (none, [])
  } else if pos.len() == 1 {
    // Case : #slide[...] (no title, the only argument is the content)
    (none, pos.at(0))
  } else {
    // Case : #slide("Title")[...] (2 arguments : title then content)
    (pos.at(0), pos.at(1))
  }

  // Invisible marker for slide-parser only, placed first thing at each call, before any state mutation below. This is distinct from <sk-slide> further down: this one's own location is irrelevant, it exists purely so slide-parser can detect "an explicit #slide(..) call starts here" and close off whatever heading-driven slide was still accumulating, before this call's state updates (title, slide index, subslide total...) can leak into that preceding slide's body. <sk-slide> below stays exactly where it was, right after the pagebreak, since mini-slides and progressive-outline rely on its page location to delimit slides.
  [#metadata(none)<sk-slide-parser-boundary>]

  if title != none and title != [] {
    sk-states.current-slide-title.update(title)
    sk-states.slide-index.step()
  }

  // Split the body into parallel tracks at <meanwhile> boundaries, then each track into chunks at <pause> labels. With no <meanwhile> at all, this is a single track equal to the previous flat chunk list, so existing slides are unaffected.
  let tracks = split-at-meanwhile(body).map(split-at-pause)

  // Compute the total number of steps requested by uncover/only and <sk-pause> labels
  let max-reveal-step = analyze-max-step(body)
  let max-track-length = calc.max(..tracks.map(t => t.len()))
  let total = calc.max(max-track-length, max-reveal-step)
  if steps != none {total = calc.max(total, steps)}

  sk-states.subslide-total.update(total)

  pagebreak(weak: true)

  // Invisible marker, placed at each call, regardless of the title
  [#metadata(title)<sk-slide>]

  context {
    if sk-states.appendix.get() {
      sk-states.app-slide-number.step()
    } else {
      sk-states.slide-number.step()
    }
  }

  context {
    // Metadata to attach a label to the slide, if requested
    if label != none {
      [#metadata((kind: "slide"))#label]
    }

    // Native counters frozen at their value at the start of the slide.
    let number-targets = sk-states.frozen-counters.get()
    let saved-numbers = number-targets.map(c => c.get())
    let reset-numbers() = {
      for (c, val) in number-targets.zip(saved-numbers) {
        c.update(val)
      }
    }

    // Direct generation of the slide content, without subslides
    if sk-states.handout.get() {
      // Handout mode: a single page per slide, in its fully revealed state. Content gated on one exact step (only(2)[..], not uncover(from: 2)[..]) never appears here, since intermediate steps are never rendered. Each track is joined on its own: tracks is an array of arrays of chunks (one array per parallel track), so tracks.join() would try to join arrays together instead of content, this joins the chunks inside each track first.
      reset-numbers()
      sk-states.subslide-step.update(total)
      for chunks in tracks {
        chunks.join()
      }
    } else {
      for i in range(1, total + 1) {
        // Reset before every substep, including the last one, without exception: making an exception for the last one would make it inherit the increment left by the penultimate one and double the progression on the page that is actually kept (verified).
        reset-numbers()

        sk-states.subslide-step.update(i)
        if i > 1 {
          pagebreak(weak: true)
        }

        for chunks in tracks {
          for (idx, chunk) in chunks.enumerate() {
            if idx < i {
              chunk
            } else {
              hide(chunk)
            }
          }
        }
      }
    }

  }
}

#let formatted-number(type: "slide", at: none, force: false) = context {
  let resolve(item) = if at != none { item.at(at) } else { item.get() }

  if force or resolve(sk-states.section-numbering) {
    let fmt = if resolve(sk-states.appendix) {
      sk-states.numbering-pattern.get().appendix
    } else {
      sk-states.numbering-pattern.get().section
    }

    let sec-num = resolve(counter(heading)).first()

    if type == "slide" {
      let slide-idx = resolve(sk-states.slide-index).first()
      numbering(fmt, sec-num, slide-idx)
    } else if type == "section" {
      numbering(fmt, sec-num)
    }
  }
}

#let slide-subtitle(fill-number: none) = context {
  let title = sk-states.current-slide-title.get()

  let fill-num = if fill-number != none {
    text(fill: fill-number)[#formatted-number()]
  } else {
    formatted-number()
  }


  [#fill-num #title]
}

// Heading-driven slides
#let heading-slide(heading, body) = {
  if heading.has("child") and heading.has("styles") {
    return heading.func()(heading-slide(heading.child, body), heading.styles)
  }

  if heading.has("label") {
    slide(heading.body, body, label: heading.label)
  } else {
    slide(heading.body, body)
  }
}

#let flush-slide(heading, chunks) = {
  if heading != none {
    heading-slide(heading, chunks.join())
  } else if chunks.len() > 0 {
    chunks.join()
  } else {
    none
  }
}

// Helper function to flatten content and extract nested markers
#let flatten-sequence(body) = {
  if type(body) != content {
    return ()
  }
  if body.func() == [].func() {
    // If it's a sequence, we recursively flatten all its children into a flat array
    body.children.map(flatten-sequence).join()
  } else {
    (body,)
  }
}

#let style-body-with-pauses(style-wrapper, body) = {
  let output = ()
  let current-body = ()

  for child in body {
    if child.has("label") and (
      child.label == <pause> or child.label == <sk-slide-parser-boundary>
    ) {
      if current-body.len() > 0 {
        output.push(style-wrapper.func()(current-body.join(), style-wrapper.styles))
      }
      output.push(child)
      current-body = ()
    } else {
      current-body.push(child)
    }
  }

  if current-body.len() > 0 {
    output.push(style-wrapper.func()(current-body.join(), style-wrapper.styles))
  }

  output.join()
}

#let expose-styled-headings(body) = {
  let children = if type(body) == array {
    body
  } else if type(body) == content and body.func() == [].func() {
    body.children
  } else {
    return body
  }

  let output = ()
  for child in children {
    if child.func() == [].func() {
      for nested in expose-styled-headings(child.children) {
        output.push(nested)
      }
    } else if child.has("child") and child.has("styles") and child.child.func() == [].func() {
      let current-body = ()
      let nested-children = expose-styled-headings(child.child.children)
      for nested in nested-children {
        let is-heading = nested.func() == heading and (
          nested.depth == 1 or nested.depth == 2
        )
        let is-slide-boundary = nested.has("label") and (
          nested.label == <sk-slide-parser-boundary>
        )
        if is-heading or is-slide-boundary {
          if current-body.len() > 0 {
            output.push(style-body-with-pauses(child, current-body))
          }
          if is-heading {
            output.push(child.func()(nested, child.styles))
          } else {
            output.push(nested)
          }
          current-body = ()
        } else {
          current-body.push(nested)
        }
      }
      if current-body.len() > 0 {
        output.push(style-body-with-pauses(child, current-body))
      }
    } else {
      output.push(child)
    }
  }

  output
}

// Detects the invisible <sk-slide-parser-boundary> marker placed at the very start of every explicit #slide(..) call, before any state mutation. Distinct from <sk-slide> (used by mini-slides/progressive-outline for page-based slide counting), which stays after the pagebreak and is passed through untouched once this boundary has been detected.
#let is-slide-marker(child) = (
  child.func() == metadata and child.has("label") and child.label == <sk-slide-parser-boundary>
)

#let unstyled-heading(child) = {
  if child.func() == heading {
    child
  } else if child.has("child") and child.has("styles") {
    unstyled-heading(child.child)
  } else {
    none
  }
}

#let slide-parser(body) = {
  if body.has("child") and body.has("styles") {
    return body.func()(slide-parser(body.child), body.styles)
  }

  // Extract headings from style wrappers while retaining their styled bodies.
  let children = expose-styled-headings(flatten-sequence(body))

  let current-heading = none
  let current-body = ()
  let output = ()
  // True once an explicit #slide(..) marker has been seen since the last heading, meaning the rest of its already-resolved content must be passed through untouched rather than accumulated into current-body.
  let in-explicit-slide = false

  for child in children {
    let parsed-heading = unstyled-heading(child)

    if parsed-heading != none and (parsed-heading.depth == 1 or parsed-heading.depth == 2) {
      let flushed = flush-slide(current-heading, current-body)
      if flushed != none { output.push(flushed) }
      current-body = ()
      in-explicit-slide = false

      if parsed-heading.depth == 2 {
        current-heading = child
      } else {
        current-heading = none
        output.push(child)
      }
    } else if is-slide-marker(child) {
      // Boundary of an explicit #slide(..) call: since the marker is now the very first thing slide() emits, nothing belonging to this call has been accumulated yet. Whatever was pending for the enclosing heading is complete as of right here, close it off. The marker itself is internal to slide-parser and is dropped here, not passed through — it carries no value and mini-slides/progressive-outline
      // rely on <sk-slide> further down instead.
      let flushed = flush-slide(current-heading, current-body)
      if flushed != none { output.push(flushed) }
      current-body = ()
      current-heading = none
      in-explicit-slide = true
    } else if in-explicit-slide {
      // Remaining content of an already-resolved explicit #slide(..) call: pass through as-is, it must not be re-split by the enclosing heading.
      output.push(child)
    } else if child.has("child") and child.has("styles") and current-heading == none {
      output.push(child.func()(slide-parser(child.child), child.styles))
    } else {
      current-body.push(child)
    }
  }

  let flushed = flush-slide(current-heading, current-body)
  if flushed != none { output.push(flushed) }

  output.join()
}

// Appendix
//
// #show: appendix transforms the rest of the document into a single opaque argument passed to this function (verified: body.children, viewed from outside appendix(), contains only one child of type sequence at this point). The appendix's == headings are therefore never visible to the slide-parser applied at the document level. We run the splitter again here, on the appendix's own body, where it finds the appendix headings as a flat list.
#let appendix(body) = context {
  // pagebreak(weak: true)
  sk-states.appendix.update(true)
  counter(heading).update(0)
  sk-states.slide-index.update(0)

  // body
  slide-parser(body)
}

// Hide new section slide
#let hide-new-section-slide(body) = {
  show heading.where(level: 1): none
  body
}

// Row images
#let row-img(logos) = {
  let n = logos.len()
  grid(
    columns: (1fr,)*n,
    column-gutter: 1fr,
    ..logos.enumerate().map(((i, item)) => {
      if n == 1 {
        align(right + horizon)[#item]
      } else if i == 0 {
        align(left + horizon)[#item]
      } else if i == n - 1 {
        align(right + horizon)[#item]
      } else {
        align(center + horizon)[#item]
      }
    })
  )
}

// Cell
#let cell = block.with(
  width: 100%,
  height: 100%,
  above: 0pt,
  below: 0pt,
  outset: 0pt,
  breakable: false,
)

// Full-width block helper (page bleed)
#let full-width(fill: none, anchor: top, body) = context {
  let margin = page.margin
  let margin-left = if type(margin) == dictionary {
    margin.at("left", default: margin.at("x", default: 0pt))
  } else {
    margin
  }
  let margin-right = if type(margin) == dictionary {
    margin.at("right", default: margin.at("x", default: 0pt))
  } else {
    margin
  }

  place(
    anchor,
    dx: -margin-left,
    box(
      width: 100% + margin-left + margin-right,
      height: 100%,
      fill: fill,
      body,
    ),
  )
}

// Section progress bar
#let progress-bar(ratio, active-color, inactive-color, row-height: (), gutter: ()) = {
  grid(
    columns: (ratio*100%, 1fr),
    rows: row-height,
    gutter: gutter,
    cell(fill: active-color),
    cell(fill: inactive-color)
  )
}

#let section-progress-bar(active-color, inactive-color) = context {
  let current-sec = query(heading.where(level: 1)
    .before(here()))
    .filter(h => not sk-states.appendix.at(h.location()))
    .len()

  let total-sec = query(heading.where(level: 1))
    .filter(h => not sk-states.appendix.at(h.location()))
    .len()

  let ratio = if total-sec > 0 { current-sec / total-sec } else { 1 }

  progress-bar(ratio, active-color, inactive-color)
}

#let slide-progress-bar(active-color, inactive-color, height: 2pt) = context {
  let current-page = sk-states.slide-number.get().first()
  let total-page = sk-states.slide-number.final().first()

  let ratio = if total-page > 0 { current-page / total-page } else { 1 }

  block(
    width: 100%,
    progress-bar(ratio, active-color, inactive-color, row-height: height, gutter: 0pt)
  )
}

// Boxes - Utility
#let box-title(a, b) = {
  grid(columns: 2, column-gutter: 0.5em, align: (horizon),
    a,
    b
  )
}

#let colorize(svg, color) = {
  let blk = black.to-hex();
  if svg.contains(blk) {
    svg.replace(blk, color.to-hex())
  } else {
    svg.replace("<svg ", "<svg fill=\""+ color.to-hex() + "\" ")
  }
}

#let color-svg(
  path,
  color,
  ..args,
) = {
  let data = colorize(read(path), color)
  return image(bytes(data), ..args)
}

#let footcite(key, supplement: none) = context {
  let elems = query(bibliography)
  if elems.len() > 0 {
    super(cite(key, supplement: supplement))
    sk-states.is-footcite.update(true)
    hide(footnote(cite(key, form: "full", style: "resources/short_ref.csl")))
    sk-states.is-footcite.update(false)
  } else {
    panic("No bibliography found. Please add a bibliography to use notecite.")
  }
}

#let show-ref(it) = {
  let el = it.element
  // if el == none { return it }
  if el == none { return footcite(it.target) }

  // Detect slides created via #slide(..., label: <...>)
  let is-metadata-slide = (
    el.func() == metadata
    and type(el.value) == dictionary
    and el.value.at("kind", default: none) == "slide"
  )

  // Detect slides created via == Title <...>
  let is-heading-slide = (
    el.func() == heading
    and el.has("level")
    and el.level == 2
  )

  if is-metadata-slide or is-heading-slide {
    let loc = el.location()
    let is-app = sk-states.appendix.at(loc)

    let base-num = if is-app {
      sk-states.app-slide-number.at(loc).first()
    } else {
      sk-states.slide-number.at(loc).first()
    }

    // A heading just before the .step(), we add +1. For a metadata, the .step() has already occurred, we keep base-num.
    let num = if is-heading-slide { base-num + 1 } else { base-num }
    let prefix = if is-app { "A." } else { "" }

    link(loc, [#prefix#num])
  } else {
    it
  }
}

#let set-text(lang: "en", fonts: (:), body) = {
  set text(font: fonts.at("body", default: default-fonts.body), size: fonts.at("size", default: default-fonts.size), lang: lang, region: lang)
  show math.equation: set text(font: fonts.at("math", default: default-fonts.math), size: fonts.at("size", default: default-fonts.size))
  show raw: set text(font: fonts.at("raw", default: default-fonts.raw), size: fonts.at("size", default: default-fonts.size))

  body
}

// Short or long title
#let short-or-long(short, long) = [#metadata((short: short, long: long)) <sk-title>]