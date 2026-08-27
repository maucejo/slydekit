#import "../../src/slydekit.typ": *
#import "@preview/zebraw:0.6.3": *
#import "@preview/codly:1.3.0": *
#import "@preview/codly-languages:0.1.10": *
#codly(languages: codly-languages)

#show: slydekit

#let code = ```python
def fib(n):
  if n <= 1:
    return n
  return fib(n-1) + fib(n-2)
```

== Code animation - Raw renderer

#code-reveal(
  highlight-lines: ("2": 2, "4": 3),
  hide-lines: ("3": 2, "4": 3)
)[#code]

== Code animation - Codly renderer

#show: codly-init
#code-reveal(
  highlight-lines: ("2": 2, "4": 3),
  hide-lines: ("3": 2, "4": 3),
  renderer: codly-renderer(codly, highlight-color: rgb("#a6b0e8")))[#code]

== Code animation - Zebraw renderer

#code-reveal(
  highlight-lines: ("2": 2, "4": 3),
  hide-lines: ("3": 2, "4": 3),
  renderer: zebraw-renderer(zebraw)
)[#code]

