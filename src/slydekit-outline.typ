#import "slydekit-defaults.typ": *
#import "slydekit-utils.typ": *

#let adaptive-columns(
  gutter: 4%,
  max-count: 3,
  start: none,
  end: none,
  body,
) = layout(size => {
  let start-content = if start != none { start } else { [] }
  let end-content = if end != none { end } else { [] }

  let avail-height = size.height - measure(start-content).height - measure(end-content).height
  if avail-height <= 0pt or avail-height == calc.inf {
    return [
      #start-content
      #body
      #end-content
    ]
  }

  if max-count <= 1 {
    return [
      #start-content
      #body
      #end-content
    ]
  }

  // Résout gutter (ratio ou longueur) en longueur absolue, une seule fois,
  // pour que col-width soit une longueur pure — jamais une expression relative
  let gutter-length = if type(gutter) == ratio { gutter * size.width } else { gutter }

  let target-n = 1
  for cols in range(1, max-count + 1) {
    let col-width = (size.width - (cols - 1) * gutter-length) / cols
    let measured-h = measure(block(width: col-width, body)).height

    if (measured-h / cols) <= avail-height {
      target-n = cols
      break
    }
    target-n = cols
  }

  start-content
  if target-n == 1 {
    body
  } else {
    columns(target-n, gutter: gutter, body)
  }
  end-content
})

// #let toc = {
//   set outline.entry(fill: none)
//   show outline.entry: it => context {
//     show linebreak: none
//     let number = it.prefix()
//     let section = it.element.body
//     block(above: 1.5em, below: 0em)
//     [#text([#number], fill: sk-states.colors.get().primary) #section]
//   }

//   set align(horizon)
//   adaptive-columns(text(size: 1.2em, strong(outline(title:none, indent: 1em, depth: 1))))
// }

#let toc(display-appendix: "auto") = context {
  let current-is-appendix = sk-states.appendix.at(here())

  let hidden-pages = query(<hide-toc>).map(l => l.location().page())

  let is-section-hidden(s) = (
    (s.has("label") and s.label == <hide-toc>) or (s.location().page() in hidden-pages)
  )

  let is-appendix-visible(s) = {
    let s-is-appendix = sk-states.appendix.at(s.location())
    if display-appendix == "auto" or display-appendix == auto {
      s-is-appendix == current-is-appendix
    } else if display-appendix == true {
      true
    } else {
      not s-is-appendix
    }
  }

  let sections = query(heading.where(level: 1, outlined: true))
    .filter(s => is-appendix-visible(s) and not is-section-hidden(s))

  let entries = sections.map(s => {
    let num = formatted-number(type: "section", at: s.location(), force: true)
    block(above: 1.5em, below: 0em)[
      #link(s.location())[#text(fill: sk-states.colors.get().primary)[#num] #text(fill: black)[#s.body]]
    ]
  })

  set align(horizon)
  adaptive-columns(text(size: 1.2em, strong(entries.join())))
}

  set align(horizon)
  adaptive-columns(text(size: 1.2em, strong(entries.join())))
}

// Display a progress bar at the bottom of the slide, showing the current section progress
// fill: color of the progress bar (default: primary color of the theme)
// alpha: transparency applied to inactive sections (default: 100%)
// display-subsection: whether to display bullets for each slide under the sections (default: true)
// linebreaks: whether to place the bullets on a new line under the section title (default: true)
// display-appendix: whether to display appendix sections (default: "auto", which shows main sections during the main presentation and switches to appendix during the appendix)
// - "auto" : Displays main sections during the main presentation and switches to appendix during the appendix.
// - true   : Always displays everything (main + appendix).
// - false  : Never displays appendix sections.
#let mini-slides(
  fill: none,
  alpha: 100%,
  display-subsection: true,
  section-numbering: false,
  linebreaks: true,
  display-appendix: "auto",
) = {
  show metadata.where(label: <sk-title>): it => it.value.short

  context {
    let theme-colors = sk-states.colors.get()
    let main-fill = if fill != none {
      fill
    } else {
      theme-colors.at("header", default: black)
    }

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

    let sections = query(heading.where(level: 1)).filter(is-visible)
    if sections.len() == 0 {
      return []
    }

    // Pages with hidden headings (== Titre <hide-toc>) : to be excluded from the count
    let hidden-pages = query(<hide-toc>).map(l => l.location().page())

    let all-slides = query(<sk-slide>)
      .filter(is-visible)
      .filter(h => h.location().page() not in hidden-pages)

    let current-page = here().page()
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

      let slides = all-slides.filter(h => (
        h.location().page() >= sec-page
        and h.location().page() < next-sec-page
      ))

      let col-content = {
        {
          show linebreak: none
          let num = if sk-states.section-numbering.get() {
            let fmt = if sk-states.appendix.get() {
              sk-states.numbering-pattern.get().appendix
            } else {
              sk-states.numbering-pattern.get().section
            }
            numbering(fmt, ..counter(heading).at(section.location()))
          } else {
            none
          }

          let title = [#num #section.body]
          link(section.location(), if is-current-sec { strong(title) } else { title })
        }

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
              if alpha < 100% {
                text(fill: main-fill.lighten(alpha), sym.circle.filled)
              } else {
                sym.circle.small
              }
              // sym.circle.small
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
}

#let progressive-outline(
  it,
  active-color,
  inactive-color,
  entry-size: 0.8575em,
  gutter: 4%,
  display-subsection: false,
  display-appendix: "auto",
) = context {
  set text(size: entry-size)
  show linebreak: none

  let current-is-appendix = sk-states.appendix.at(it.location())

  // Pages to exclude: == Titre <hide-toc> or #slide(..., label: <hide-toc>)[...]
  let hidden-pages = query(<hide-toc>).map(l => l.location().page())

  let it-hides-toc = (it.has("label") and it.label == <hide-toc>) or (it.location().page() in hidden-pages)

  // Si la section courante porte <hide-toc> et n'est PAS une annexe (ex: Bibliographie),
  // on ne produit aucun sommaire.
  if it-hides-toc and not current-is-appendix {
    return []
  }

  let all-sections = query(heading.where(level: 1, outlined: true))

  let is-section-hidden(s) = (
    (s.has("label") and s.label == <hide-toc>) or (s.location().page() in hidden-pages)
  )

  // Même logique de bascule que mini-slides :
  // "auto" -> ne montre que les sections de la même zone (annexe/principal) que 'it'
  // true   -> fusionne tout dans un seul sommaire, sections principales et annexes confondues
  // false  -> n'affiche jamais les annexes
  let is-appendix-visible(s) = {
    let s-is-appendix = sk-states.appendix.at(s.location())
    if display-appendix == "auto" or display-appendix == auto {
      s-is-appendix == current-is-appendix
    } else if display-appendix == true {
      true
    } else {
      not s-is-appendix
    }
  }

  let sections = all-sections.filter(s => is-appendix-visible(s) and not is-section-hidden(s))

  if sections.len() == 0 {
    return []
  }

  let current-idx = sections.position(s => s.location() == it.location())

  let entries = sections.enumerate().map(((idx, s)) => {
    let num = formatted-number(type: "section", at: s.location(), force: true)
    let is-current = (current-idx != none and idx == current-idx)
    let color = if is-current { active-color } else { inactive-color }

    let title = [#text(fill: color, weight: "bold")[#num] #s.body]

    let subsections = if display-subsection and is-current {
      // Find the very first level-1 heading after the current section (whether it is hidden or not)
      let all-next-headings = query(heading.where(level: 1))
        .filter(h => h.location().page() > s.location().page())

      let sec-page = s.location().page()
      let next-page = if all-next-headings.len() > 0 {
        all-next-headings.first().location().page()
      } else {
        calc.inf
      }

      let slides = query(<sk-slide>).filter(h => (
        h.location().page() >= sec-page
        and h.location().page() < next-page
        and h.value != none
        and h.location().page() not in hidden-pages
      ))

      if slides.len() > 0 {
        set text(size: 0.75em)
        v(0.5em)
        for h in slides {
          let sub-num = formatted-number(at: h.location(), force: true)
          block(inset: (left: 1em), above: 0.5em)[#text(fill: color)[#sub-num] #h.value]
          v(0.25em)
        }
        v(-0.75em)
      }
    } else { none }

    block(below: 1.5em)[
      #if is-current { title } else { text(fill: inactive-color)[#title] }
      #subsections
    ]
  })

  adaptive-columns(gutter: gutter, entries.join())
}

