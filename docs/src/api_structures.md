# Character Structures

IDS files use Unicode *ideographic description characters* to describe how components of characters are put together (they occupy the range from U+2FF0 to U+2FFB). In IDSGraphs.jl, these relationships are represented as a character structures, similar to a parse tree.

```@docs
IDSGraphs.parse(::AbstractString)
```


## Structure Hierarchy

```@docs
AbstractCharStructure
NestedStructure
Component
```


## Basic Relationships

```@docs
LeftRightStructure
TopBottomStructure
VerticalThirdsStructure
HorizontalThirdsStructure
```


## Nested Relationships

```@docs
CenterNestedStructure
BottomNestedStructure
TopNestedStructure
RightNestedStructure
BottomRightNestedStructure
BottomLeftNestedStructure
TopRightNestedStructure
```


## Overlap Relationship

```@docs
OverlapStructure
```

