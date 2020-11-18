module IDSFiles

export Component, LeftRightStructure, TopBottomStructure, VerticalThirdsStructure,
HorizontalThirdsStructure, CenterNestedStructure, BottomNestedStructure, TopNestedStructure,
RightNestedStructure, BottomRightNestedStructure, BottomLeftNestedStructure,
TopRightNestedStructure, OverlapStructure, CharStructure,

DependencyGraph

include("structures.jl")
include("dependencygraphs.jl")

end