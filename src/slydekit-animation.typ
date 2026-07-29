#import "slydekit-defaults.typ": *

#let split-at-pause(body) = {
  // Si body n'est pas une séquence d'éléments, il n'y a pas de pause
  if body.func() != [].func() {
    return (body,)
  }

  let chunks = ()
  let current-chunk = ()

  for child in body.children {
    current-chunk.push(child)
    // Dès qu'un élément porte l'étiquette <pause>, on valide le morceau courant
    if child.has("label") and child.label == <pause> {
      chunks.push(current-chunk.join())
      current-chunk = ()
    }
  }

  if current-chunk.len() > 0 {
    chunks.push(current-chunk.join())
  }

  return chunks
}

// Parcours récursif de l'AST pour déterminer l'étape maximale demandée par uncover/only
#let analyze-max-step(body) = {
  let rec(it) = {
    if type(it) == content {
      let current-max = 1

      // Si l'élément est notre métadonnée d'animation
      if it.has("label") and it.label == <sk-reveal> and it.has("value") {
        let val = it.value
        let upper = if val.explicit.len() > 0 {
          calc.max(..val.explicit)
        } else if val.to != none {
          val.to
        } else { val.from }
        current-max = calc.max(current-max, upper)
      }

      // Inspection récursive des champs de l'élément
      for (key, val) in it.fields() {
        current-max = calc.max(current-max, rec(val))
      }
      return current-max

    } else if type(it) == array {
      let current-max = 1
      for item in it {
        current-max = calc.max(current-max, rec(item))
      }
      return current-max

    } else if type(it) == dictionary {
      let current-max = 1
      for (key, val) in it {
        current-max = calc.max(current-max, rec(val))
      }
      return current-max

    } else {
      return 1
    }
  }

  rec(body)
}

#let _reveal(..args) = {
  let pos = args.pos()
  let body = pos.last()
  let explicit = pos.slice(0, -1)
  let from = args.named().at("from", default: 1)
  let to = args.named().at("to", default: none)
  let hide-color = args.named().at("hide-color", default: none)
  let reserved = args.named().at("reserved", default: true)

  // Rendu dynamique de l'élément selon l'étape courante
  let anim-content = context {
    let step = sk-states.subslide-step.get().first()
    let visible = if explicit.len() > 0 {
        step in explicit
      } else {
        step >= from and (to == none or step <= to)
      }

    if visible {
      body
    } else if reserved {
      if hide-color != none {
        text(fill: hide-color, body)
      } else {
        hide(body)
      }
    } else {
      none
    }
  }

  // Attachement de métadonnées invisibles pour l'analyse statique dans slide()
  [#metadata((
    explicit: explicit,
    from: from,
    to: to,
  ))<sk-reveal>#anim-content]
}

#let pause = <pause>
#let uncover = _reveal
#let only = _reveal.with(reserved: false)

// Reproduit la logique de visibilité de reveal(), mais renvoie un booléen
// au lieu de content, utilisable dans du code Typst ordinaire (cetz, etc.)
#let reveal(..explicit-or-range, body) = {
  let step = sk-states.subslide-step.get().first()
  let explicit = explicit-or-range.pos()
  let from = explicit-or-range.named().at("from", default: 1)
  let to = explicit-or-range.named().at("to", default: none)

  let visible = if explicit.len() > 0 {
    step in explicit
  } else {
    step >= from and (to == none or step <= to)
  }

  if visible {
    body
  } else {
    none
  }
}