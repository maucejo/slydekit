#import "/.calepin/calepin.typ" as calepin
#import "../doc-utils.typ": *

#set document(title: [Localization])
#metadata((tags: ("localization"))) <website-metadata>


#html.elem("p", attrs: (style: "color: var(--calepin-color-link); font-size: 2em; font-weight: bold;"))[Localization]

The localization feature in Slydekit allows you to create presentations in different languages. You can specify the language of your presentation using the `lang` parameter in the `slydekit` function. The default language is English (`"en"`), but you can change it to any supported language by providing the appropriate language code.

Currently supported languages are:
- Chinese (`"zh"`)
- English (`"en"`)
- French (`"fr"`)
- German (`"de"`)
- Italian (`"it"`)
- Spanish (`"es"`)
- Portuguese (`"pt"`)

To use a language that is not supported by default, you can modify the `states.localization` dictionary when initializing the template. For instance, to add support for Dutch, you can do the following `#states.localization.update(json("path_to_file/dutch.json"))`. For the english version, the JSON  file is as follows:
```json
{
    "note": "Note",
    "proof": "Proof",
    "tip": "Tip",
    "outline": "Outline",
    "warning": "Warning"
}
```
