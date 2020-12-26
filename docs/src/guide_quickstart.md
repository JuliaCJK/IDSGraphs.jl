# Quick Start Guide
First, make sure you've installed the package.

## Creating IDS Graphs
The package mainly revolves around the `IDSGraph` struct and operations on it. This graph has "components" as vertices, with an edge from component A to component B if B is a subcomponent of A. If you call the no-parameter constructor, we just get an empty graph
```@example
julia> using IDSGraphs
julia> IDSGraph()
```

However, this isn't that useful, as we'd have to construct all the relationships ourselves. IDSGraphs can also load a default graph based on data from the [CHISE project](http://www.chise.org/) (this is not licensed under the same MIT license as the code). You can pass a symbol for which dataset to load, for several "default" datasets. Otherwise, you can load an IDS file from disk as well.
```@example
julia> IDSGraph(:ids)
```
Check the documentation for the constructor for supported symbols. These will be downloaded the first time as an artifact.

You can also construct a graph from an IDS file on disk by passing in a filename
```julia-repl
julia> IDSGraph("local/path/to/file/custom-ids.txt")
```
