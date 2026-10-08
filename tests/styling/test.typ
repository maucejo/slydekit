#import "../../src/slydekit.typ": *

#show: slydekit.with()

= Styled section

== First styled slide

#set math.equation(numbering: "(1)")

$
	a = b
$

```typst
Hello
```

== Second styled slide

The automatic slide splitter must still detect this heading.
== Text styling applies to math

#set text(size: 40pt, fill: red)
Text $a = b^2$

$ x = integral f $

#text(size: 10pt, fill: blue)[small $y = z$]
