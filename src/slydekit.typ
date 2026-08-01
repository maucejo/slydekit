#import "slydekit-animation.typ": *
#import "slydekit-deps.typ": *
#import "slydekit-defaults.typ": *
#import "slydekit-themes.typ": *
#import "slydekit-utils.typ": *

#let slydekit(
  title: "Title",
  subtitle: "Subtitle",
  short-title: "Short title",
  author: "Author",
  date: "Date",
  institution: "Institution",
  contact: none,
  theme: simple,
  fonts: none,
  colors: none,
  lang: "fr",
  aspect-ratio: "16-9",
  navigation: "topbar",
  title-logo: (),
  slide-logo: none,
  handout: false,
  body
) = context {
  // Page setup
  set page(
    paper: "presentation-" + aspect-ratio,
    margin: margins,
  )

  // Localization
  let sk-lang = if default-language.contains(lang) {lang} else {"en"}

  // Paragraph styles
  set par(justify: true)

  // Page alignment
  set align(horizon)

  // Footnote style
  set footnote.entry(separator: none, clearance: 0.25em)
  show footnote.entry: it => context {
    set text(size: 0.75em)
    if sk-states.is-footcite.at(it.note.location()) {
      it.note.body
    } else {
      it
    }
  }

  // Bibliography style
  set bibliography(title: none)
  show bibliography: set text(size: 0.85em)

  // Theme
  let sk-theme = metropolis + theme
  show: sk-theme.theme.with(colors: colors, fonts: fonts)

  // Title page
  let sk-pres-info = (title: title, subtitle: subtitle, short-title: short-title, author: author, date: date, institution: institution, contact: contact, logo: title-logo)

  // Update states
  sk-states.navigation.update(navigation)
  sk-states.pres-info.update(sk-pres-info)
  sk-states.localization.update(json("resources/i18n/" + sk-lang + ".json"))
  sk-states.theme.update(sk-theme)
  sk-states.logo.update(slide-logo)
  sk-states.handout.update(handout)

  show selector(<hide-toc>): set heading(outlined: false)

  show selector(<hide>): {
    show heading.where(level: 1): none
  }

  // Fonts
  show: set-text.with(lang: sk-lang)

  body
}