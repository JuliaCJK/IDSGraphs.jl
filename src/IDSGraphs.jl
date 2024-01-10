module IDSGraphs

using LazyArtifacts

# exports
export

# structure
Component, LeftRightStructure, TopBottomStructure, VerticalThirdsStructure,
HorizontalThirdsStructure, CenterNestedStructure, BottomNestedStructure, TopNestedStructure,
RightNestedStructure, BottomRightNestedStructure, BottomLeftNestedStructure,
TopRightNestedStructure, OverlapStructure,

# graph & new graph-related functions (Graphs not reexported)
IDSGraph, components, compounds


include("structures.jl")
include("dependencygraphs.jl")

end