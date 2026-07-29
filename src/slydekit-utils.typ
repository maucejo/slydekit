#import "slydekit-defaults.typ": *
#import "slydekit-animation.typ": split-at-pause, analyze-max-step

// Slides
#let slide(title, steps: none, label:none, body) = {
  if title != [] {
    sk-states.current-slide-title.update(title)
  }

  // 1. Découpage aux emplacements <pause>
  let chunks = split-at-pause(body)

  // 2. Calcul du nombre d'étapes (maximum entre les <pause> et les uncover/only)
  let max-reveal-step = analyze-max-step(body)
  let total = calc.max(chunks.len(), max-reveal-step)
  if steps != none {
    total = calc.max(total, steps)
  }

  sk-states.subslide-total.update(total)

  pagebreak(weak: true)

  // Marqueur invisible, posé à chaque appel, indépendamment du titre
  [#metadata(title)<sk-slide>]

  // Metadonnées pour attacher un label à la diapositive, si demandé
  [#metadata("")#label]

  context {
    if sk-states.appendix.get() {
      sk-states.app-count.step()
    } else {
      sk-states.slide-number.step()
    }

    // 3. Génération directe des sous-diapositives
    for i in range(1, total + 1) {
      sk-states.subslide-step.update(i)
      if i > 1 {
        pagebreak(weak: true)
      }

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


// Appendix
#let appendix(body) = context {
  pagebreak(weak: true)
  sk-states.appendix.update(true)
  counter(heading).update(0)

  body
}

// Hide new section slide
#let hide-new-section-slide(doc) = {
  show heading.where(level: 1): it => none
  doc
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
#let wideblock(fill: none, anchor: top, body) = context {
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

#let adaptive-columns(
  gutter: 4%,
  max-count: 3,
  start: none,
  end: none,
  body,
) = layout(size => {
  let n = calc.min(
    calc.ceil(
      measure(body).height
        / (size.height - measure(start).height - measure(end).height),
    ),
    max-count,
  )
  if n < 1 {
    n = 1
  }
  start
  if n == 1 {
    body
  } else {
    columns(n, body)
  }
  end
})

/// Affiche une barre de navigation (mini-slides) en haut de page.
///
/// - fill (color, none): Couleur du texte principal. Si `none`, utilise la couleur du thème.
/// - alpha (ratio): Transparence appliquée aux sections inactives (défaut: 50%).
/// - display-subsection (boolean): Affiche des puces (cercles) pour chaque diapositive sous les sections.
/// - linebreaks (boolean): Si `true`, place les puces sur une nouvelle ligne sous le titre de section.
/// - display-appendix (string, boolean):
///     - `"auto"` : Affiche les sections principales pendant la présentation, et bascule sur l'annexe pendant l'annexe.
///     - `true`   : Affiche toujours tout (principal + annexe).
///     - `false`  : Ne montre jamais les sections d'annexe.
#let mini-slides(
  fill: none,
  alpha: 50%,
  display-subsection: true,
  linebreaks: true,
  display-appendix: "auto",
) = context {
  // 1. Récupération de la couleur principale
  let theme-colors = sk-states.colors.get()
  let main-fill = if fill != none {
    fill
  } else {
    theme-colors.at("header", default: black)
  }

  let faded-fill = if type(main-fill) == color { main-fill.lighten(alpha) } else { main-fill }

  // 2. Détection du contexte courant (sommes-nous dans l'annexe ?)
  let current-is-appendix = sk-states.appendix.get()

  let is-visible(h) = {
    let is-heading-appendix = sk-states.appendix.at(h.location())

    if display-appendix == "auto" or display-appendix == auto {
      is-heading-appendix == current-is-appendix
    } else if display-appendix == true {
      true
    } else {
      not is-heading-appendix
    }
  }

  // 3. Sections : toujours de vrais headings de niveau 1
  let sections = query(heading.where(level: 1)).filter(is-visible)
  if sections.len() == 0 {
    return []
  }

  // 4. Diapositives : le marqueur posé par slide(), indépendant de == ou #slide(...)
  let all-slides = query(<sk-slide>).filter(is-visible)

  let current-page = here().page()

  // Index de la section active
  let current-sec-idx = sections.filter(s => s.location().page() <= current-page).len() - 1

  let cols = ()

  for (sec-idx, section) in sections.enumerate() {
    let next-section = if sec-idx + 1 < sections.len() {
      sections.at(sec-idx + 1)
    } else {
      none
    }

    let sec-page = section.location().page()
    let next-sec-page = if next-section != none {
      next-section.location().page()
    } else {
      calc.inf
    }

    let is-current-sec = (sec-idx == current-sec-idx)
    let sec-color = if is-current-sec { main-fill } else { faded-fill }

    // Diapositives rattachées à cette section, via le marqueur <sk-slide>
    let slides = all-slides.filter(h => (
      h.location().page() >= sec-page
      and h.location().page() < next-sec-page
    ))

    let col-content = {
      set text(fill: sec-color)

      link(section.location(), section.body)

      if display-subsection and slides.len() > 0 {
        if linebreaks {
          linebreak()
        } else {
          h(0.4em)
        }

        for (slide-idx, slide-h) in slides.enumerate() {
          let next-slide-page = if slide-idx + 1 < slides.len() {
            slides.at(slide-idx + 1).location().page()
          } else {
            next-sec-page
          }

          let slide-page = slide-h.location().page()
          let is-active-slide = (current-page >= slide-page and current-page < next-slide-page)

          let dot = if is-active-slide {
            sym.circle.filled
          } else {
            sym.circle.small
          }

          link(slide-h.location(), dot)

          if not linebreaks and slide-idx + 1 < slides.len() {
            h(0.25em)
          }
        }
      }
    }

    cols.push(align(center + top, col-content))
  }

  set text(size: 0.7em)
  grid(
    columns: cols.map(_ => auto).intersperse(1fr),
    ..cols.intersperse([])
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