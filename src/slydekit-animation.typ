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

  return chunks
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

// Recursive traversal of the AST to determine the maximum local step
// requested by helpers anchored to their current chunk.
#let analyze-local-max-step(body) = {
  let rec(it) = {
    if type(it) == content {
      let current-max = 1

      if it.has("label") and it.label == <sk-local-reveal> and it.has("value") {
        let val = it.value
        let upper = if val.explicit.len() > 0 {
          calc.max(..val.explicit)
        } else if val.to != none {
          val.to
        } else { val.from }
        current-max = calc.max(current-max, upper)
      }

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

// #let _local-reveal(..args) = {
//   let pos = args.pos()
//   let body = pos.last()
//   let explicit = pos.slice(0, -1)
//   let from = args.named().at("from", default: 1)
//   let to = args.named().at("to", default: none)
//   let hide-color = args.named().at("hide-color", default: none)
//   let reserved = args.named().at("reserved", default: true)
//   let cover-fn = args.named().at("cover-fn", default: none)

//   let anim-content = context {
//     let step = sk-states.subslide-step.get().first()
//     let chunk-start = sk-states.pause-index.get().first()
//     let local-step = step - chunk-start + 1

//     let visible = if explicit.len() > 0 {
//         local-step in explicit
//       } else {
//         local-step >= from and (to == none or local-step <= to)
//       }

//     if visible {
//       body
//     } else if cover-fn != none {
//       cover-fn(body)
//     } else if reserved {
//       if hide-color != none {
//         text(fill: hide-color, body)
//       } else {
//         hide(body)
//       }
//     } else {
//       none
//     }
//   }

//   [#metadata((
//     explicit: explicit,
//     from: from,
//     to: to,
//   ))<sk-local-reveal>#anim-content]
// }

#let pause = <pause>
#let uncover = _reveal
#let only = _reveal.with(reserved: false)

// // Displays an alternative among several, one per step, without breaking the layout (sizing based on the largest option)
// #let alternatives(start: 1, ..options) = {
//   let opts = options.pos()
//   let n = opts.len()

//   if n == 0 { return none }

//   let anim-content = context {
//     let sizes = opts.map(o => measure(o))
//     let w = calc.max(..sizes.map(s => s.width))
//     let h = calc.max(..sizes.map(s => s.height))

//     let step = sk-states.subslide-step.get().first()
//     let chunk-start = sk-states.pause-index.get().first()
//     let local-step = step - chunk-start + 1
//     let idx = calc.min(calc.max(local-step - start + 1, 1), n)

//     box(width: w, height: h, opts.at(idx - 1))
//   }

//   [#metadata((explicit: (), from: start, to: start + n - 1))<sk-local-reveal>#anim-content]
// }

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

// // // Reveals each item of a list, enumeration, or term list on its own step, without needing to insert a #pause manually
// // #let item-by-item(start: 1, body) = {
// //   let target = body

// //   if target.func() == [].func() {
// //     let found = none
// //     for child in target.children {
// //       if child.func() in (list, enum, terms) {
// //         found = child
// //         break
// //       }
// //     }
// //     if found == none { return body }
// //     target = found
// //   }

// //   if target.func() not in (list, enum, terms) {
// //     return body
// //   }

// //   let wrapped = target.children.enumerate().map(((i, it)) => _local-reveal(from: start + i, it.body))

// //   if target.func() == list {
// //     list(..wrapped)
// //   } else if target.func() == enum {
// //     enum(..wrapped)
// //   } else {
// //     terms(..wrapped)
// //   }
// // }

// // Parallel track: local split by <pause>, counted independently of the main flow, but synchronized on the same subslide clock. Replaces the use of #meanwhile from Touying: instead of a marker inserted in the flow, we wrap each parallel branch in track(..).
// #let track(body) = {
//   let chunks = split-at-pause(body)
//   let n = chunks.len()

//   let anim-content = context {
//     let step = sk-states.subslide-step.get().first()
//     let chunk-start = sk-states.pause-index.get().first()
//     let local-step = step - chunk-start + 1
//     let idx = calc.min(calc.max(local-step, 1), n)
//     chunks.slice(0, idx).join()
//   }

//   [#metadata((explicit: (), from: 1, to: n))<sk-local-reveal>#anim-content]
// }

// #let meanwhile = []