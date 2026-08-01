#import "slydekit-defaults.typ": *
#import "slydekit-animation.typ": split-at-pause, analyze-max-step, analyze-local-max-step

// Slides
#let slide(title, steps: none, label:none, body) = {
  if title != [] {
    sk-states.current-slide-title.update(title)
  }

  // 1. Découpage aux emplacements <pause>
  let chunks = split-at-pause(body)

  // 2. Calcul du nombre d'étapes (maximum entre les <pause>, les uncover/only et les local-reveal)
  let max-reveal-step = analyze-max-step(body)
  let max-local-reveal-step = 1
  for (idx, chunk) in chunks.enumerate() {
    let local-max = analyze-local-max-step(chunk)
    // idx est base-0, les étapes sont base-1
    max-local-reveal-step = calc.max(max-local-reveal-step, idx + local-max)
  }

  let total = calc.max(chunks.len(), max-reveal-step, max-local-reveal-step)
  if steps != none {
    total = calc.max(total, steps)
  }

  sk-states.subslide-total.update(total)

  pagebreak(weak: true)

  // Marqueur invisible, posé à chaque appel, indépendamment du titre
  [#metadata(title)<sk-slide>]

  context {
    if sk-states.appendix.get() {
      sk-states.app-count.step()
    } else {
      sk-states.slide-number.step()
    }

    // Metadonnées pour attacher un label à la diapositive, si demandé
    if label != none {
      [#metadata((kind: "slide"))#label]
    }

    // 3. Génération directe des sous-diapositives
    for i in range(1, total + 1) {
      sk-states.subslide-step.update(i)
      if i > 1 {
        pagebreak(weak: true)
      }

      for (idx, chunk) in chunks.enumerate() {
        if idx < i {
          sk-states.pause-index.update(idx + 1)
          chunk
        } else {
          hide(chunk)
        }
      }
    }
  }
}

// Appendix
#let appendix(body) = context {
  pagebreak(weak: true)
  sk-states.appendix.update(true)
  counter(heading).update(0)

  body
}

// Hide new section slide
#let hide-new-section-slide(body) = {
  show heading.where(level: 1): none
  body
}

// Conditional set-show
#let show-if(cond, func) = body => if cond { func(body) } else { body }

// Row images
#let row-img(logo) = {
  let n = logo.len()
  grid(
    columns: (1fr,)*n,
    column-gutter: 1fr,
    ..logo.enumerate().map(((i, item)) => {
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
#let section-progress-bar(color1, color2) = context {
  let current-sec = query(heading.where(level: 1)
    .before(here()))
    .filter(h => not sk-states.appendix.at(h.location()))
    .len()

  let total-sec = query(heading.where(level: 1))
    .filter(h => not sk-states.appendix.at(h.location()))
    .len()

  let ratio = if total-sec > 0 { current-sec / total-sec } else { 1 }

  grid(
    columns: (ratio*100%, 1fr),
    cell(fill: color1),
    cell(fill: color2)
  )
}

#let progress-bar(color1, color2, height: 2pt) = context {
  let current-page = sk-states.slide-number.get().first()
  let total-page = sk-states.slide-number.final().first()

  let ratio = if total-page > 0 { current-page / total-page } else { 1 }

  block(
    width: 100%,
    grid(
      columns: (ratio*100%, 1fr),
      rows: height,
      gutter: 0pt,
      cell(fill: color1),
      cell(fill: color2)
    )
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

#let show-ref(it) = {
let el = it.element
  if el == none { return it }

  // 1. Détection des diapositives créées via #slide(..., label: <...>)
  let is-metadata-slide = (
    el.func() == metadata
    and type(el.value) == dictionary
    and el.value.at("kind", default: none) == "slide"
  )

  // 2. Détection des diapositives créées via == Titre <...>
  let is-heading-slide = (
    el.func() == heading
    and el.has("level")
    and el.level == 2
  )

  if is-metadata-slide or is-heading-slide {
    let loc = el.location()
    let is-app = sk-states.appendix.at(loc)

    let base-num = if is-app {
      sk-states.app-count.at(loc).first()
    } else {
      sk-states.slide-number.at(loc).first()
    }

    // Un heading se trouvant juste avant le .step(), on lui ajoute +1.
    // Pour un metadata, le .step() ayant déjà eu lieu, on garde base-num.
    let num = if is-heading-slide { base-num + 1 } else { base-num }
    let prefix = if is-app { "A." } else { "" }

    link(loc, [#prefix#num])
  } else {
    it
  }
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