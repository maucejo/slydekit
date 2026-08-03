#let argument-callout(name, type, default, body) = html.elem("div", attrs: (
  style: "position: relative; margin: 1.2em 0; padding: 1.1rem 1.1rem 0rem 1.1rem; border: 1px solid #d7ccff; border-left: 4px solid #7b61d1; border-radius: 0.9rem; background: linear-gradient(135deg, #faf7ff, #f3eeff); box-shadow: 0 6px 18px rgba(101, 76, 163, 0.08); margin-bottom: 2.5em;"
))[
  #html.elem("div", attrs: (
    style: "position: absolute; top: -0.8rem; left: 0.8rem; padding: 0.2rem 0.55rem; font-weight: 700; font-size: 0.8rem; color: #654ca3; background: #f3eeff; border: 1px solid #d7ccff; border-radius: 999px;"
  ))[Argument]

  #html.elem("div", attrs: (style: "margin-top: 0.4rem; display: flex; justify-content: space-between; align-items: baseline; gap: 1rem; font-family: ui-monospace, monospace;"))[
    #html.elem("div", attrs: (style: "display: inline-block;"))[
      #html.elem("code", attrs: (style: "color: #654ca3; font-weight: 700;"))[#name -- default: #default]
    ]
    #html.elem("div", attrs: (style: "margin-left: auto; display: inline-block;"))[
      #html.elem("span", attrs: (style: "color: #7a7a7a;"))[#type]
    ]
  ]

  #body
]