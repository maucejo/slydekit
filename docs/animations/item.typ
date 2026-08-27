#import "/.calepin/calepin.typ" as calepin
#import "../doc-utils.typ": *

#set document(title: [One by one/Item by item])
#metadata((tags: ("animations", "item-by-item"))) <website-metadata>

#html.elem("p", attrs: (style: "color: var(--calepin-color-link); font-size: 2em; font-weight: bold;"))[One by one/Item by item]

Using `pause`can be tedious when you have a list of words or items  that you want to reveal one by one. Slydekit provides two convenient functions, `one-by-one` and `item-by-item`, to simplify this process.

#calepin.elements.callout[
  The implementation of `one-by-one` and `item-by-item` has been borrowed from the #link("https://polylux.dev/book/dynamic/obo-lbl.html", "Polylux") package, with some adaptations to fit the Slydekit framework.
]

= One by one

`one-by-one` is a function that allows you to reveal words or phrases one at a time. It is particularly useful for emphasizing key points in a sentence or phrase.

```typ
#let one-by-one(
  start: 1,
  hide-color: none,
  hide-fn: none,
  ..children
)
```

#argument-callout("start", "int", default: 1)[The starting step for the reveal. The first element will be revealed on this step.]

#argument-callout("hide-color", "color", default: none)[The color to use for hidden elements. If set to `none`, the hidden elements will be completely invisible.]

#argument-callout("hide-fn", "function", default: none)[A function that can be used to provide custom masking for hidden elements. If set to `none`, the default hiding behavior will be used.]

#argument-callout("..children", "list")[The list of words or phrases to be revealed one by one.]

```typ
== `one-by-one` example

#one-by-one[I am ][not a ][ robot]
```

#calepin.elements.gallery(
  (
    ("../assets/animations/one-by-one1.png", "Step 1"),
    ("../assets/animations/one-by-one2.png", "Step 2"),
    ("../assets/animations/one-by-one3.png", "Step 3"),
  ),
  columns: 3,
  max-width: 100%,
)

#calepin.elements.callout[
  The previous results can be obtained by using `pause` as follows:
  ```typ
  #slide[`#one-by-one` example][
    I am #pause not a #pause robot
  ]
  ```
]

= Item by item

`item-by-item` is a function that allows you to reveal items in a list one at a time. It is particularly useful for emphasizing key points in a list.

```typ
#let item-by-item(
  start: 1,
  hide-color: none,
  hide-fn: none,
  body
)
```

#argument-callout("start", "int", default: 1)[The starting step for the reveal. The first element will be revealed on this step.]

#argument-callout("hide-color", "color", default: none)[The color to use for hidden elements. If set to `none`, the hidden elements will be completely invisible.]

#argument-callout("hide-fn", "function", default: none)[A function that can be used to provide custom masking for hidden elements. If set to `none`, the default hiding behavior will be used.]

#argument-callout("body", "content")[The list of items to be revealed one by one. This can be a list, enumeration, or terms.]

```typ
== `item-by-item` example

#item-by-item[
  - I am the first item, visible on the first subslide
  - I am the second item, visible on the second subslide
  - I am the third item, visible on the third subslide
]
```

#calepin.elements.gallery(
  (
    ("../assets/animations/item-by-item1.png", "Step 1"),
    ("../assets/animations/item-by-item2.png", "Step 2"),
    ("../assets/animations/item-by-item3.png", "Step 3"),
  ),
  columns: 3,
  max-width: 100%,
)

#calepin.elements.callout[
  The previous results can be obtained by using `pause` as follows:
  ```typ
  == `item-by-item` example

  - I am the first item, visible on the first subslide
  #pause
  - I am the second item, visible on the second subslide
  #pause
  - I am the third item, visible on the third subslide
```
]