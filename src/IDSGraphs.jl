module IDSGraphs

# exports
export

# structure
Component, LeftRightStructure, TopBottomStructure, VerticalThirdsStructure,
HorizontalThirdsStructure, CenterNestedStructure, BottomNestedStructure, TopNestedStructure,
RightNestedStructure, BottomRightNestedStructure, BottomLeftNestedStructure,
TopRightNestedStructure, OverlapStructure, CharStructure,

# graph & new graph-related functions (LightGraphs not reexported)
IDSGraph, components, compounds


include("structures.jl")
include("dependencygraphs.jl")

end