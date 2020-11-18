# Character Structures
IDS files use Unicode *ideographic description characters* to describe how components of characters are put together (they occupy the range from U+2FF0 to U+2FFB). In IDSFiles.jl, these relationships are represented as a character structures, similar to a parse tree.

```@docs
AbstractCharStructure
```

```@docs
Component
```

```@docs
LeftRightStructure
TopBottomStructure
VerticalThirdsStructure
HorizontalThirdsStructure
```