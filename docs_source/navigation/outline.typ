#import "/.calepin/calepin.typ" as calepin
#import "../doc-utils.typ": *

#set document(title: [Outlines])
#metadata((tags: ("animations", "outline", "toc", "progressive outline"))) <website-metadata>

#html.elem("p", attrs: (style: "font-size: 2em; font-weight: bold;"))[Outlines]

In Slydekit, you can create an outline using the `tableofcontents` command.

```typ
#import "@preview/slydekit:0.1.0": *

#show: slydekit.with(...)

// Title slide
#title-slide

// Insert a table of contents
#tableofcontents
```

If you want to create a custom theme, Slydekit provides two helper functions to create a table of contents.

== `toc` command

The `toc` command creates a simple table of contents with the current theme primary color. Actually, `tableofcontents` is just a wrapper around `toc`, that includes the title slide and the table of contents in a single slide.

You can see the source code of the `toc` command in the `slydekit-outline.typ` file. You can customize the table of contents by changing the parameters of the `toc` command.