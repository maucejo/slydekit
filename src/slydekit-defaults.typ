// States
#let sk-states = (
  app-count: counter("appendix"),
  appendix: state("appendix", false),
  colors: state("colors"),
  current-slide-title: state("current-slide-title", []),
  fonts: state("fonts"),
  is-footcite: state("is-footcite", false),
  logo: state("logo"),
  localization: state("localization"),
  navigation: state("navigation", "topbar"),
  pause-index: counter("pause-index"),
  pres-info: state("pres-info"),
  slide-number: counter("slide-number"),
  subslide-total: counter("subslide-total"),
  subslide-step: counter("subslide-step"),
  theme: state("theme"),
)

// Defaults
#let margins = (
  left: 2cm,
  right: 2cm,
  top: 2cm,
  bottom: 2cm,
)

#let default-fonts = (
  size: 20pt,
  body: "New Computer Modern",
  math: "New Computer Modern Math",
  raw: "DejaVu Sans Mono",
)

#let default-pres-info = (
  title: "Title",
  subtitle: "Subtitle",
  short-title: "Short title",
  author: "Author",
  date: "Date",
  institution: "Institution",
  contact: "contact@example.com",
  logo: none,
  header-footer-logo: none
)

#let default-colors = (
  primary: white,
  primary-light: white,
  secondary: white,
  background: white,
  neutral-dark: white,
  neutral-darkest: white,
)

#let default-language = ("en", "de", "fr",  "es", "it", "pt", "zh")

