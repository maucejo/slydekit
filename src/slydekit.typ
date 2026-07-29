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
  theme: metropolis,
  fonts: default-fonts,
  colors: none,
  lang: "fr",
  aspect-ratio: "16-9",
  navigation: "topbar",
  title-logo: (),
  slide-logo: none,
  body
) = {
  // Page setup
  set page(
    paper: "presentation-" + aspect-ratio,
    margin: margins,
  )

  // Fonts
  let sk-fonts = default-fonts + fonts
  set text(font: sk-fonts.body, size: sk-fonts.size, lang: lang, region: lang)
  show math.equation: set text(font: sk-fonts.math, size: sk-fonts.size)
  show raw: set text(font: sk-fonts.raw, size: sk-fonts.size)


  // Localization
  let sk-lang = if default-language.contains(lang) {lang} else {"en"}

  // Paragraph styles
  set par(justify: true)

  // Page alignment
  set align(horizon)

  // Theme
  let sk-theme = metropolis + theme
  show: sk-theme.theme.with(colors: colors)

  // Title page
  let sk-pres-info = (title: title, subtitle: subtitle, short-title: short-title, author: author, date: date, institution: institution, contact: contact, logo: title-logo)

  // Update states
  sk-states.navigation.update(navigation)
  sk-states.pres-info.update(sk-pres-info)
  sk-states.localization.update(json("resources/i18n/" + sk-lang + ".json"))
  sk-states.theme.update(sk-theme)
  sk-states.logo.update(slide-logo)

  show selector(<hide-toc>): set heading(outlined: false)

  show selector(<hide>): {
    show heading.where(level: 1): it => {
      none
    }
  }

  body
}