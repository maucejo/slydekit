#import "slydekit-defaults.typ": *

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

#let toc = {
  set outline.entry(fill: none)
  show outline.entry: it => context {
    show linebreak: none
    let number = it.prefix()
    let section = it.element.body
    block(above: 1.5em, below: 0em)
    [#text([#number], fill: sk-states.colors.get().primary)#sym.space.thin#section]
  }

  set align(horizon)
  adaptive-columns(text(size: 1.2em, strong(outline(title:none, indent: 1em, depth: 1))))
}

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

#let progressive-outline(
  it,
  active-color,
  inactive-color,
  entry-size: 0.8575em,
  max-count: 3,
  gutter: 4%,
  section-numbering: "1.1.",
  appendix-numbering: "A.1.",
) = context {
  set text(size: entry-size)

  let it-hides-toc = it.has("label") and it.label == <hide-toc>

  let sections = if it-hides-toc {
    (it,)
  } else {
    query(heading.where(level: 1, outlined: true))
      .filter(s => not (s.has("label") and s.label == <hide-toc>))
  }

  let current-idx = sections.position(s => s.location() == it.location())

  let entries = sections.enumerate().map(((idx, s)) => {
    let s-is-appendix = sk-states.appendix.at(s.location())
    let format = if s-is-appendix { appendix-numbering } else { section-numbering }

    let count = counter(heading).at(s.location())
    let num = numbering(format, ..count)
    let is-current = idx == current-idx
    let color = if is-current { active-color } else { inactive-color }

    let entry = [
      #text(fill: color, weight: "bold")[#num]#sym.space.thin#s.body
    ]

    block(below: 1.5em)[
      #if is-current {
        entry
      } else {
        text(fill: inactive-color)[#entry]
      }
    ]
  })

  adaptive-columns(gutter: gutter, max-count: max-count, entries.join())
}