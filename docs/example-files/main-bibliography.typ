#import "../../src/slydekit.typ": *

#show: slydekit.with(
  title: "Slydekit",
  subtitle: "An example of a presentation template using Typst",
  author: "John Doe",
  date: "2024-06-01",
  institution: "Université de Typst",
  contact: "john.doe@univ.typst.fr",
)

== Footcite example

#lorem(10)#footcite(<knuth>)

== Bibliography
#bibliography(
  bytes(
    // ```bib
    // @book{knuth,
    //   title={The Art of Computer Programming},
    //   author={Donald E. Knuth},
    //   year={1968},
    //   publisher={Addison-Wesley},
    // }
    // ```.text,
    raw(lang: "bib",
    "@book{knuth,
      title={The Art of Computer Programming},
      author={Donald E. Knuth},
      year={1968},
      publisher={Addison-Wesley},
    }").text
  ),
  style: "ieee",
)

