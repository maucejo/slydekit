#import "../../src/slydekit.typ": *

#show: slydekit.with(
  title: "Slydekit",
  subtitle: "Reusable animations",
  author: "John Doe",
  date: "2024-06-01",
  institution: "Université de Typst",
  contact: "john.doe@univ.typst.fr",
)

// A reusable animated block, written once.
#let steps-anim = [
  First point
  #pause
  Second point
  #pause
  Third point
  #pause
  Fourth point
]

// -- Split across slides: A(1-2) -> B -> A(3-) ---------------------------------------

== Animation A (part 1)

#render-animation(1, 2, steps-anim)

== Intermezzo B

Number 1
#pause
Number 2

== Animation A (part 2)

#render-animation(from: 3, steps-anim)

// -- Single-step windows + uncover/only inside the reusable block -----------

#let mixed-anim = [
  #only(1)[Only on global step 1]
  #uncover(from: 2)[Uncovered from global step 2]
  #pause
  Reached via #pause after the uncovers (global step 3)
  #pause
  And one more (global step 4)
]

== Mixed A -- window 1

#render-animation(1, mixed-anim)

== Mixed A -- window 2-3

#render-animation(2, 3, mixed-anim)

== Mixed A -- window 4 to end

#render-animation(from: 4, mixed-anim)

// -- Whole animation in one go (auto == inline behaviour) ------------------

== Full animation, rendered in one go

#render-animation(steps-anim)

// -- A layout wrapper around the pauses still animates --------------------

#let wrapped-anim = align(center)[
  Centered one
  #pause
  Centered two
  #pause
  Centered three
]

== Wrapped A -- part 1

#render-animation(1, 2, wrapped-anim)

== Wrapped A -- part 2

#render-animation(from: 3, wrapped-anim)

// -- Extra top-level #pause around a window still behaves ----------------

== Window with surrounding pause

Before the resumed animation.
#pause
#render-animation(from: 3, steps-anim)
#pause
After the resumed animation.
