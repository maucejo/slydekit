#import "/.calepin/calepin.typ" as calepin
#import "../doc-utils.typ": *

#set document(title: [Appendix])
#metadata((tags: ("appendix"))) <website-metadata>

#html.elem("p", attrs: (style: "color: var(--calepin-color-link); font-size: 2em; font-weight: bold;"))[Appendix]

If you want to add additional content to your presentation, you can use the `appendix` function. This function allows you to create an appendix section in your presentation, which can be used to include supplementary information, references, or any other content that is not part of the main presentation.

For the built-in themes, the appendix slides are automatically numbered with a prefix "A." to distinguish them from the main slides. For example, the first appendix slide will be numbered as "A.1", the second as "A.2", and so on.

= Appendix declaration

To include an appendix in your presentation, you can use the `appendix` function as follows:
```typ
#show: appendix
```

Practically, a presentation including an appendix looks like this:
```typ
#import "@preview/slydekit:0.1.0": *

#show: slydekit.with(...)

= Main section

== A subsection

#lorem(10)

#show: appendix

= Appendix

== A subsection in the appendix

#lorem(10)
```

#calepin.elements.gallery(
  (
    ("../assets/components/basic-appendix1.png", "Topbar navigation style - Simple theme", [Appendix example - Slide 1]),
    ("../assets/components/basic-appendix2.png", "Topbar navigation style - Metropolis theme", [Appendix example - Slide 2]),
    ("../assets/components/basic-appendix3.png", "Topbar navigation style - Fancy theme", [Appendix example - Slide 3]),
    ("../assets/components/basic-appendix4.png", "Topbar navigation style - Cambfurt theme", [Appendix example - Slide 4]),
  ),
  columns: 2,
  max-width: 100%,
)

= Outline/Navigation styles

For the built-in themes, the appendix slides are automatically excluded from the minislide navigation style. Similarly, when the label `hide-toc` is used in the appendix declaration, the appendix slides are excluded from the main outlines built by `tableofcontents` and `progressive-outline` and a separate outline is created for the appendix slides. This allows you to keep the main presentation structure separate from the appendix content, while still providing a clear overview of the entire presentation.

== Without `hide-toc`

```typ
#import "@preview/slydekit:0.1.0": *

#show: slydekit.with(...)

#tableofcontents

= First section

== A subsection

#lorem(10)

= Second section

== Another subsection

#lorem(10)

#show: appendix

= Appendix

== A subsection in the appendix

#lorem(10)
```

#calepin.elements.gallery(
  (
    ("../assets/components/appendix-nohide1.png", "Topbar navigation style - Simple theme", [Outline example - Without hide-toc - Slide 1]),
    ("../assets/components/appendix-nohide2.png", "Topbar navigation style - Metropolis theme", [Outline example - Without hide-toc - Slide 2]),
    ("../assets/components/appendix-nohide3.png", "Topbar navigation style - Fancy theme", [Outline example - Without hide-toc - Slide 3]),
    ("../assets/components/appendix-nohide4.png", "Topbar navigation style - Cambfurt theme", [Outline example - Without hide-toc - Slide 4]),
    ("../assets/components/appendix-nohide5.png", "Topbar navigation style - Metropolis theme", [Outline example - Without hide-toc - Slide 5]),
    ("../assets/components/appendix-nohide6.png", "Topbar navigation style - Fancy theme", [Outline example - Without hide-toc - Slide 6]),
    ("../assets/components/appendix-nohide7.png", "Topbar navigation style - Cambfurt theme", [Outline example - Without hide-toc - Slide 7]),
  ),
  columns: 3,
  max-width: 100%,
)

== With `hide-toc`

```typ
#import "@preview/slydekit:0.1.0": *

#show: slydekit.with(...)

#tableofcontents

= First section

== A subsection

#lorem(10)

= Second section

== Another subsection

#lorem(10)

#show: appendix

= Appendix <hide-toc>

== A subsection in the appendix

#lorem(10)
```

#calepin.elements.gallery(
  (
    ("../assets/components/appendix-hide1.png", "Topbar navigation style - Simple theme", [Outline example - With hide-toc - Slide 1]),
    ("../assets/components/appendix-hide2.png", "Topbar navigation style - Metropolis theme", [Outline example - With hide-toc - Slide 2]),
    ("../assets/components/appendix-hide3.png", "Topbar navigation style - Fancy theme", [Outline example - With hide-toc - Slide 3]),
    ("../assets/components/appendix-hide4.png", "Topbar navigation style - Cambfurt theme", [Outline example - With hide-toc - Slide 4]),
    ("../assets/components/appendix-hide5.png", "Topbar navigation style - Metropolis theme", [Outline example - With hide-toc - Slide 5]),
    ("../assets/components/appendix-hide6.png", "Topbar navigation style - Fancy theme", [Outline example - With hide-toc - Slide 6]),
    ("../assets/components/appendix-hide7.png", "Topbar navigation style - Cambfurt theme", [Outline example - With hide-toc - Slide 7]),
  ),
  columns: 3,
  max-width: 100%,
)