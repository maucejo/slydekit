#import "/.calepin/calepin.typ" as calepin
#import "../doc-utils.typ": *

#set document(title: [One by one/Item by item])
#metadata((tags: ("animations", "item-by-item"))) <website-metadata>

#html.elem("p", attrs: (style: "color: var(--calepin-color-link); font-size: 2em; font-weight: bold;"))[One by one/Item by item]

Using `pause`can be tedious when you have a list of words or items  that you want to reveal one by one. Slydekit provides two convenient functions, `one-by-one` and `item-by-item`, to simplify this process.

#calepin.elements.callout[
  The implementation of `one-by-one` and `item-by-item` has been borrowed from the #link("https://typst.app/universe/package/polylux/", "Polylux") package, with some adaptations to fit the Slydekit framework.
]

= One by one

= Item by item