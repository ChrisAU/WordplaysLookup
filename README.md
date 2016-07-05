# WordplaysLookup

Finds definitions of words on the 'Wordplays.com' website and returns the first definition.

```
WordplaysLookup.find(word: "example") { definition in
  guard let definition = definition else {
    print("Word was not found")
    return
  }
  print(definition)
}
```
