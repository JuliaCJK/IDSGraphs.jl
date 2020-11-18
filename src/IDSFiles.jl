module IDSFiles

using Pkg.Artifacts

# exports
export Component, LeftRightStructure, TopBottomStructure, VerticalThirdsStructure,
HorizontalThirdsStructure, CenterNestedStructure, BottomNestedStructure, TopNestedStructure,
RightNestedStructure, BottomRightNestedStructure, BottomLeftNestedStructure,
TopRightNestedStructure, OverlapStructure, CharStructure,

DependencyGraph

# code
include("structures.jl")
include("dependencygraphs.jl")

end