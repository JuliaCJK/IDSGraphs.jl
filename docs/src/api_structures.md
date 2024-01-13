# Character Structures

```@meta
CurrentModule = IDSGraphs
```

IDS files use Unicode *ideographic description characters* to describe how components of characters are put together (they occupy the range from U+2FF0 to U+2FFB). In IDSGraphs.jl, these relationships are represented as character structures, similar to a parse tree.

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

These are the simplest component relationships: 
components are all either horizontally or vertically stacked on top of each other, in a set of 2 or 3 components.

```@docs
LeftRightStructure
TopBottomStructure
VerticalThirdsStructure
HorizontalThirdsStructure
```


## Nested Relationships

Most relationships have one component in the "middle" with another component "around" the middle component.
The names reflect where the middle component is placed.

Note that not all of the expected positions are covered. There is no

- `LeftNestedStructure`
- `TopLeftNestedStructure`

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

There's one more relationship different from all the others:

```@docs
OverlapStructure
```

