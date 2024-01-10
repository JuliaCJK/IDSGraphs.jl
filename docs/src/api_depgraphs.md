# Character Dependency Graphs

IDS data is converted/represented as a graph where the vertices are components and the directed edges point from larger characters to the components of the characters. This graph type fully implements the AbstractGraph interface specified in Graphs. An `IDSGraph` is also indexable, which returns the character structure of that character.

```@docs
IDSGraph
```

Besides the functionality in `Graphs.jl`, there are a few other functions provided to work with the graph structure:

```@docs
components
compounds
IDSGraphs.subgraph
IDSGraphs.topological_sort
```
