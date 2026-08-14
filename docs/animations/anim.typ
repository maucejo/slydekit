#import "/.calepin/calepin.typ" as calepin
#import "../doc-utils.typ": *

#set document(title: [Animation system])
#metadata((tags: ("animations"))) <website-metadata>

#html.elem("p", attrs: (style: "color: var(--calepin-color-link); font-size: 2em; font-weight: bold;"))[Animation system]

The animation system in Slydekit allows you to create dynamic and interactive presentations by controlling the visibility and behavior of content on slides.

In Slydekit, animations must be encapuslated in a `slide` (See  #link("components/slide.html","Slide")). This means that you cannot apply animations to content outside of a slide context, i.e. in markup mode. This behavior is similar to that used in other presentation frameworks, such as #link("https://typst.app/universe/package/touying/", "Touying") or #link("https://typst.app/universe/package/minideck/","Minideck").

The animation system provides a set of predefined animations that can be used to enhance your presentations. These animations include

- `pause`, `uncover`, and `only`, which allow you to control the flow of your presentation and create engaging visual effects.

- `meanwhile` and `track`, which allows you to create parallel animations that can be used to illustrate complex concepts or processes.

- `item-by-item`, which allows you to reveal content one item at a time, creating a sense of anticipation and engagement.

- `reveal`, which allows you to reveal content in a specific order. This function is mainly used for integration with #link("https://typst.app/universe/package/cetz/", "CeTZ") and #link("https://typst.app/universe/package/fletcher/", "Fletcher").
