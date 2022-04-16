using Graphs
import Graphs: add_vertex!, add_edge!, SimpleDiGraph
using LazyArtifacts

# Dependency graph struct creation
# --------------------------------

"""
    IDSGraph([input])

Create a graph representation of IDS data; if no input is provided, an empty graph will be
created. The input can be a symbol representing a dataset to load, or it can be something
readable by `eachline`.

# Available IDS Datasets
* `:ids` - the default IDS file
"""
IDSGraph

struct IDSGraph <: AbstractGraph{Char}
    graph::SimpleDiGraph{UInt32}
    mapping::Dict{Char, UInt32}
    reverse_mapping::Vector{Char}
    structures::Dict{Char, AbstractCharStructure}
end

function IDSGraph()
     IDSGraph(
        SimpleDiGraph{UInt32}(),
        Dict{Char, UInt32}(),
        Vector{Char}(),
        Dict{Char, AbstractCharStructure}())
end
function IDSGraph(filename::Union{AbstractString, IO})
    dep = IDSGraph()

    for line in eachline(filename)
        startswith(line, "#") && continue

        m = match(r"^[^\s]+\s+([^\s])\s+(.+)$", line)
        m === nothing && continue
        char_str, ids_string = m.captures
        char = first(char_str)

        add_vertex!(dep, char)
        for component in filter(c -> c ∉ '⿰':'⿻' && c != char, ids_string)
            add_edge!(dep, component, char)
        end
        dep.structures[char] = parse(ids_string)
    end

    dep
end
function IDSGraph(src::Symbol)
    if src == :ids
        return IDSGraph(joinpath(artifact"ids", "ids.txt"))
    else
        throw(ArgumentError("unknown identifier $(src) for a IDS file"))
    end
end

function Graphs.add_vertex!(dep::IDSGraph, vertex::Char)
    if !haskey(dep.mapping, vertex)
        add_vertex!(dep.graph)
        dep.mapping[vertex] = nv(dep.graph)
        push!(dep.reverse_mapping, vertex)
    end
    dep
end

function Graphs.add_edge!(dep::IDSGraph, from::Char, to::Char)
    add_vertex!(dep, from)
    add_vertex!(dep, to)
    add_edge!(dep.graph, dep.mapping[from], dep.mapping[to])
    dep
end

# new edge type
"""Graph edge between 2 `Char` instances."""
struct CharEdge <: Graphs.AbstractEdge{Char}
    src::Char
    dest::Char
end

Graphs.src(c::CharEdge) = c.src
Graphs.dst(c::CharEdge) = c.dest

# abstract graph interface
Graphs.vertices(dep::IDSGraph) = (v for v in dep.reverse_mapping)
Graphs.edges(dep::IDSGraph) = (CharEdge(src(edge), dst(edge)) for edge in edges(dep.graph))

Base.eltype(::Type{IDSGraph}) = Char

Graphs.edgetype(dep::IDSGraph) = CharEdge

#Graphs.has_contiguous_vertices(::Type{IDSGraph}) = false

Graphs.has_vertex(dep::IDSGraph, v) = haskey(dep.mapping, v)
Graphs.has_edge(dep::IDSGraph, s, d) =
    Graphs.has_edge(dep.graph, dep.mapping[s], dep.mapping[d])

Graphs.inneighbors(dep::IDSGraph, v) = collect(components(dep, v))
Graphs.outneighbors(dep::IDSGraph, v) = collect(compounds(dep, v))

Graphs.ne(dep::IDSGraph) = Graphs.ne(dep.graph)
Graphs.nv(dep::IDSGraph) = length(dep.reverse_mapping)

Base.zero(dep::IDSGraph) = IDSGraph()

Graphs.is_directed(::Type{IDSGraph}) = true

Base.getindex(dep::IDSGraph, char::Char) = dep.structures[char]
Base.length(dep::IDSGraph) = nv(dep.graph)


# Functions on dependency graphs
# ------------------------------
"""
    components(idsgraph, char)

The components that make up a character.

# Examples
```julia-repl
julia> g = IDSGraph(:ids);

julia> collect(components(g, '㲉'))
5-element Vector{Char}:
 '一': Unicode U+4E00 (category Lo: Letter, other)
 '冖': Unicode U+5196 (category Lo: Letter, other)
 '士': Unicode U+58EB (category Lo: Letter, other)
 '殳': Unicode U+6BB3 (category Lo: Letter, other)
 '卵': Unicode U+5375 (category Lo: Letter, other)
```
"""
components(dep::IDSGraph, char::Char) =
    (dep.reverse_mapping[code] for code in inneighbors(dep.graph, dep.mapping[char]))

"""
    compounds(idsgraph, char)

The characters that are compounds of the given character.

# Examples
```julia-repl
julia> g = IDSGraph(:ids);

julia> collect(compounds(g, '毛'))
529-element Vector{Char}:
 '兞': Unicode U+515E (category Lo: Letter, other)
 '尾': Unicode U+5C3E (category Lo: Letter, other)
 '宒': Unicode U+5B92 (category Lo: Letter, other)
 '毳': Unicode U+6BF3 (category Lo: Letter, other)
 '旄': Unicode U+65C4 (category Lo: Letter, other)
 '枆': Unicode U+6786 (category Lo: Letter, other)
 ⋮
 '𭴎': Unicode U+2DD0E (category Lo: Letter, other)
 '𭸶': Unicode U+2DE36 (category Lo: Letter, other)
 '𮁠': Unicode U+2E060 (category Lo: Letter, other)
 '𮊐': Unicode U+2E290 (category Lo: Letter, other)
 '𮗥': Unicode U+2E5E5 (category Lo: Letter, other)
```
"""
compounds(dep::IDSGraph, char::Char) =
    (dep.reverse_mapping[code] for code in outneighbors(dep.graph, dep.mapping[char]))

"""
    subgraph(condition, idsgraph)

Create a subgraph keeping only vertices `v` where `condition(v) == true`.
"""
function subgraph(condition, dep::IDSGraph)
    vlist = [dep.mapping[v] for v in vertices(dep) if condition(v)]
    length(vlist) == 0 && return IDSGraph()
    sg, vmap = induced_subgraph(dep.graph, vlist)

    reverse_mapping = [dep.reverse_mapping[vmap[sg_code]] for sg_code in 1:length(vlist)]
    mapping = Dict(char => sg_code for (sg_code, char) in enumerate(reverse_mapping))
    structures = Dict(char => structure for (char, structure) in dep.structures if haskey(mapping, char))

    IDSGraph(sg, mapping, reverse_mapping, structures)
end

"""
    topological_sort(idsgraph)

Create a topological ordering of the characters in this IDS graph.s
"""
topological_sort(dep::IDSGraph) =
    (dep.reverse_mapping[code] for code in Graphs.topological_sort_by_dfs(dep.graph))
