module IDSGraphs

using Pkg.Artifacts

# exports
export Component, LeftRightStructure, TopBottomStructure, VerticalThirdsStructure,
HorizontalThirdsStructure, CenterNestedStructure, BottomNestedStructure, TopNestedStructure,
RightNestedStructure, BottomRightNestedStructure, BottomLeftNestedStructure,
TopRightNestedStructure, OverlapStructure, CharStructure,

IDSGraph, components, compounds

# code
include("structures.jl")
include("dependencygraphs.jl")

end