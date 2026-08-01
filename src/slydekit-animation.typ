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

// Parcours récursif de l'AST pour déterminer l'étape locale maximale
// demandée par les helpers ancrés sur leur chunk courant.
#let analyze-local-max-step(body) = {
  let rec(it) = {
    if type(it) == content {
      let current-max = 1

      if it.has("label") and it.label == <sk-local-reveal> and it.has("value") {
        let val = it.value
        let upper = if val.explicit.len() > 0 {
          calc.max(..val.explicit)
        } else if val.to != none {
          val.to
        } else { val.from }
        current-max = calc.max(current-max, upper)
      }

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

// Variante locale de _reveal : la visibilité est calculée relativement au
// début du chunk courant (pause-index), pas depuis le début de la diapo.
#let _local-reveal(..args) = {
  let pos = args.pos()
  let body = pos.last()
  let explicit = pos.slice(0, -1)
  let from = args.named().at("from", default: 1)
  let to = args.named().at("to", default: none)
  let hide-color = args.named().at("hide-color", default: none)
  let reserved = args.named().at("reserved", default: true)
  let cover-fn = args.named().at("cover-fn", default: none)

  let anim-content = context {
    let step = sk-states.subslide-step.get().first()
    let chunk-start = sk-states.pause-index.get().first()
    let local-step = step - chunk-start + 1

    let visible = if explicit.len() > 0 {
        local-step in explicit
      } else {
        local-step >= from and (to == none or local-step <= to)
      }

    if visible {
      body
    } else if cover-fn != none {
      cover-fn(body)
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

  [#metadata((
    explicit: explicit,
    from: from,
    to: to,
  ))<sk-local-reveal>#anim-content]
}

#let pause = <pause>
#let uncover = _reveal
#let only = _reveal.with(reserved: false)

// Affiche une alternative parmi plusieurs (une par étape locale), en
// maintenant la mise en page stable (dimensionnement sur la plus grande option).
#let alternatives(start: 1, ..options) = {
  let opts = options.pos()
  let n = opts.len()

  if n == 0 { return none }

  let anim-content = context {
    let sizes = opts.map(o => measure(o))
    let w = calc.max(..sizes.map(s => s.width))
    let h = calc.max(..sizes.map(s => s.height))

    let step = sk-states.subslide-step.get().first()
    let chunk-start = sk-states.pause-index.get().first()
    let local-step = step - chunk-start + 1
    let idx = calc.min(calc.max(local-step - start + 1, 1), n)

    box(width: w, height: h, opts.at(idx - 1))
  }

  [#metadata((explicit: (), from: start, to: start + n - 1))<sk-local-reveal>#anim-content]
}

// Révèle chaque item d'une liste, énumération ou liste de termes sur sa
// propre étape locale, sans nécessiter l'insertion manuelle d'un #pause.
#let item-by-item(start: 1, body) = {
  let target = body

  if target.func() == [].func() {
    let found = none
    for child in target.children {
      if child.func() in (list, enum, terms) {
        found = child
        break
      }
    }
    if found == none { return body }
    target = found
  }

  if target.func() not in (list, enum, terms) {
    return body
  }

  let wrapped = target.children.enumerate().map(((i, it)) => _local-reveal(from: start + i, it.body))

  if target.func() == list {
    list(..wrapped)
  } else if target.func() == enum {
    enum(..wrapped)
  } else {
    terms(..wrapped)
  }
}

// Piste parallèle : découpe locale par <pause>, comptée indépendamment du
// flux principal mais synchronisée sur la même horloge de sous-diapositives.
// Remplace l'usage de #meanwhile de Touying.
#let track(body) = {
  let chunks = split-at-pause(body)
  let n = chunks.len()

  let anim-content = context {
    let step = sk-states.subslide-step.get().first()
    let chunk-start = sk-states.pause-index.get().first()
    let local-step = step - chunk-start + 1
    let idx = calc.min(calc.max(local-step, 1), n)
    chunks.slice(0, idx).join()
  }

  [#metadata((explicit: (), from: 1, to: n))<sk-local-reveal>#anim-content]
}

#let meanwhile = []

// Reproduit la logique de visibilité de reveal(), mais renvoie un booléen
// au lieu de content, utilisable dans du code Typst ordinaire (cetz, etc.)
#let reveal(..explicit-or-range, body, hide-fn: none) = {
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
    if hide-fn != none {
      hide-fn(body)
    }
  }
}