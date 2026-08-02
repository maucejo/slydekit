#import "slydekit-defaults.typ": *

#let split-at-pause(body) = {
  // If body is not a sequence of elements, there are no pauses
  if body.func() != [].func() {
    return (body,)
  }

  let chunks = ()
  let current-chunk = ()

  for child in body.children {
    current-chunk.push(child)
    // As soon as an element has the <pause> label, we validate the current chunk
    if child.has("label") and child.label == <pause> {
      chunks.push(current-chunk.join())
      current-chunk = ()
    }
  }

  if current-chunk.len() > 0 {
    chunks.push(current-chunk.join())
  }

  // Always return at least one chunk, even if body ends up empty, so
  // callers spreading chunks.len() values into calc.max(..) never receive
  // a zero-length array
  if chunks.len() == 0 {
    chunks.push([])
  }

  return chunks
}

// Splits body into parallel tracks at <meanwhile> boundaries, mirroring split-at-pause exactly. Each track is then split-at-pause'd on its own by the caller (slide()), and all tracks advance on the same subslide clock, which reproduces Touying's #meanwhile: content after #meanwhile gets its own local pause chain instead of being appended to the one before it.
#let split-at-meanwhile(body) = {
  if body.func() != [].func() {
    return (body,)
  }

  let tracks = ()
  let current-track = ()

  for child in body.children {
    current-track.push(child)
    if child.has("label") and child.label == <meanwhile> {
      tracks.push(current-track.join())
      current-track = ()
    }
  }

  // Always push the trailing track, even if it's empty, so this always returns at least one track (a body with zero children, or a #meanwhile right at the end, would otherwise yield an empty array, and calc.max(..tracks.map(t => t.len())) in slide() requires at least one value)
  tracks.push(if current-track.len() > 0 { current-track.join() } else { [] })

  return tracks
}

// Recursive traversal of the AST to determine the maximum step requested by uncover/only
#let analyze-max-step(body) = {
  let rec(it) = {
    if type(it) == content {
      let current-max = 1

      // If the element is our animation metadata
      if it.has("label") and it.label == <sk-reveal> and it.has("value") {
        let val = it.value
        let upper = if val.explicit.len() > 0 {
          calc.max(..val.explicit)
        } else if val.to != none {
          val.to
        } else { val.from }
        current-max = calc.max(current-max, upper)
      }

      // Recursive inspection of the element's fields
      for (key, val) in it.fields() {
        current-max = calc.max(current-max, rec(val))
      }
      return current-max

    } else if type(it) == array {
      let current-max = 1
      for item in it {
        current-max = calc.max(current-max, rec(item))
      }
      return current-max

    } else if type(it) == dictionary {
      let current-max = 1
      for (key, val) in it {
        current-max = calc.max(current-max, rec(val))
      }
      return current-max

    } else {
      return 1
    }
  }

  rec(body)
}

#let _reveal(..args) = {
  let pos = args.pos()
  let body = pos.last()
  let explicit = pos.slice(0, -1)
  let from = args.named().at("from", default: 1)
  let to = args.named().at("to", default: none)
  let hide-color = args.named().at("hide-color", default: none)
  let reserved = args.named().at("reserved", default: true)
  let cover-fn = args.named().at("cover-fn", default: none)

  // Dynamic rendering of the element according to the current step
  let anim-content = context {
    let step = sk-states.subslide-step.get().first()
    let visible = if explicit.len() > 0 {
        step in explicit
      } else {
        step >= from and (to == none or step <= to)
      }

    if visible {
      body
    } else if cover-fn != none {
      // Allows a third-party package (Fletcher, CeTZ...) to provide its own masking
      cover-fn(body)
    } else if reserved {
      if hide-color != none {
        text(fill: hide-color, body)
      } else {
        hide(body)
      }
    } else {
      none
    }
  }

  // Metadata for the animation, to be used by the reveal() function
  [#metadata((
    explicit: explicit,
    from: from,
    to: to,
  ))<sk-reveal>#anim-content]
}

#let pause = <pause>
#let meanwhile = <meanwhile>
#let uncover = _reveal
#let only = _reveal.with(reserved: false)

// Reproduces the visibility logic of reveal(), but returns a boolean instead of content, usable in ordinary Typst code (cetz, etc.)
#let reveal(..explicit-or-range, body, hide-fn: none) = {
  let step = sk-states.subslide-step.get().first()
  let explicit = explicit-or-range.pos()
  let from = explicit-or-range.named().at("from", default: 1)
  let to = explicit-or-range.named().at("to", default: none)

  let visible = if explicit.len() > 0 {
    step in explicit
  } else {
    step >= from and (to == none or step <= to)
  }

  if visible {
    body
  } else {
    if hide-fn != none {
      hide-fn(body)
    }
  }
}

// Reveals each element of a list, enumeration, or terms on its own step. On the model of Polylux's item-by-item: we never reconstruct list(..)/enum(..)/terms(..), we simply filter the direct children of body that are list.item/enum.item/terms.item and reveal them one by one via one-by-one. Typst then visually groups these adjacent items, regardless of whether they are each wrapped in an uncover.
#let one-by-one(start: 1, hide-color: none, cover-fn: none, ..children) = {
  for (idx, child) in children.pos().enumerate() {
    uncover(from: start + idx, hide-color: hide-color, cover-fn: cover-fn, child)
  }
}

// Adapts a descriptor (integer = single step, dictionary (beginning: n) = open from n) to a call to only, the only vocabulary that alternatives needs
#let _only-for(descriptor, body) = {
  if type(descriptor) == dictionary {
    only(from: descriptor.beginning, body)
  } else {
    only(descriptor, body)
  }
}

// Displays different content per step, reserving the space of the largest among them. On the model of Polylux's alternatives-match/alternatives: each option is revealed by a separate only(..) call, so each declares its own <sk-reveal> metadata, without manual declaration of the number of steps.
#let alternatives-match(subslides-contents, position: bottom + left) = {
  let pairs = if type(subslides-contents) == dictionary {
    subslides-contents.pairs()
  } else {
    subslides-contents
  }

  context {
    for (descriptor, content) in pairs {
      _only-for(descriptor, content)
    }
  }
}

#let alternatives(start: 1, repeat-last: false, position: bottom + left, ..options) = {
  let contents = options.pos()
  let n = contents.len()

  if n == 0 { return none }

  let subslides = range(start, start + n)
  let descriptors = subslides.enumerate().map(((i, s)) => {
    if repeat-last and i == n - 1 { (beginning: s) } else { s }
  })

  [
    #metadata((explicit: (), from: start, to: start + n - 1))<sk-reveal>
    #alternatives-match(descriptors.zip(contents), position: position)
  ]
}

// Reveals each element of a list, enumeration, or terms on its own step. On the model of Polylux's item-by-item: we never reconstruct list(..)/enum(..)/terms(..), we simply filter the direct children of body that are list.item/enum.item/terms.item and reveal them one by one via one-by-one. Typst then visually groups these adjacent items, regardless of whether they are each wrapped in an uncover.
#let item-by-item(start: 1, hide-color: none, cover-fn: none, body) = {
  let is-item(it) = type(it) == content and it.func() in (
    list.item, enum.item, terms.item
  )
  let children = if type(body) == content and body.has("children") {
    body.children
  } else {
    body
  }
  one-by-one(start: start, hide-color: hide-color, cover-fn: cover-fn, ..children.filter(is-item))
}

// Parallel track: local split by <pause>, counted independently of the main flow, but synchronized on the same subslide clock. Replaces the use of #meanwhile from Touying: instead of a marker inserted in the flow, we wrap each parallel branch in track(..).
#let track(body) = {
  let chunks = split-at-pause(body)
  let n = chunks.len()

  let anim-content = context {
    let step = sk-states.subslide-step.get().first()
    let idx = calc.min(calc.max(step, 1), n)
    chunks.slice(0, idx).join()
  }

  [#metadata((explicit: (), from: 1, to: n))<sk-reveal>#anim-content]
}