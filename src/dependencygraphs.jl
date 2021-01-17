using LightGraphs
import LightGraphs: add_vertex!, add_edge!, SimpleDiGraph
using LazyArtifacts

# Dependency graph struct creation
# --------------------------------
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
function IDSGraph(filename::AbstractString)
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

function LightGraphs.add_vertex!(dep::IDSGraph, vertex::Char)
    if !haskey(dep.mapping, vertex)
        add_vertex!(dep.graph)
        dep.mapping[vertex] = nv(dep.graph)
        push!(dep.reverse_mapping, vertex)
    end
    dep
end

function LightGraphs.add_edge!(dep::IDSGraph, from::Char, to::Char)
    add_vertex!(dep, from)
    add_vertex!(dep, to)
    add_edge!(dep.graph, dep.mapping[from], dep.mapping[to])
    dep
end

# new edge type
struct CharEdge <: LightGraphs.AbstractEdge{Char}
    src::Char
    dest::Char
end

LightGraphs.src(c::CharEdge) = c.src
LightGraphs.dst(c::CharEdge) = c.dest

# abstract graph interface
LightGraphs.vertices(dep::IDSGraph) = (v for v in dep.reverse_mapping)
LightGraphs.edges(dep::IDSGraph) = (CharEdge(src(edge), dst(edge)) for edge in edges(dep.graph))

Base.eltype(::Type{IDSGraph}) = Char

LightGraphs.edgetype(dep::IDSGraph) = CharEdge

#LightGraphs.has_contiguous_vertices(::Type{IDSGraph}) = false

LightGraphs.has_vertex(dep::IDSGraph, v) = haskey(dep.mapping, v)
LightGraphs.has_edge(dep::IDSGraph, s, d) =
    LightGraphs.has_edge(dep.graph, dep.mapping[s], dep.mapping[d])

LightGraphs.inneighbors(dep::IDSGraph, v) = collect(components(dep, v))
LightGraphs.outneighbors(dep::IDSGraph, v) = collect(compounds(dep, v))

LightGraphs.ne(dep::IDSGraph) = LightGraphs.ne(dep.graph)
LightGraphs.nv(dep::IDSGraph) = length(dep.reverse_mapping)

Base.zero(dep::IDSGraph) = IDSGraph()

LightGraphs.is_directed(::Type{IDSGraph}) = true

Base.getindex(dep::IDSGraph, char::Char) = dep.structures[char]
Base.length(dep::IDSGraph) = nv(dep.graph)


# Functions on dependency graphs
# ------------------------------
"""
    components(idsgraph, char)

The components
"""
components(dep::IDSGraph, char::Char) =
    (dep.reverse_mapping[code] for code in inneighbors(dep.graph, dep.mapping[char]))

compounds(dep::IDSGraph, char::Char) =
    (dep.reverse_mapping[code] for code in outneighbors(dep.graph, dep.mapping[char]))

function subgraph(condition, dep::IDSGraph)
    vlist = [dep.mapping[v] for v in vertices(dep) if condition(v)]
    length(vlist) == 0 && return IDSGraph()
    sg, vmap = induced_subgraph(dep.graph, vlist)

    reverse_mapping = [dep.reverse_mapping[vmap[sg_code]] for sg_code in 1:length(vlist)]
    mapping = Dict(char => sg_code for (sg_code, char) in enumerate(reverse_mapping))
    structures = Dict(char => structure for (char, structure) in dep.structures if haskey(mapping, char))

    IDSGraph(sg, mapping, reverse_mapping, structures)
end

topological_sort(dep::IDSGraph) =
    (dep.reverse_mapping[code] for code in LightGraphs.topological_sort_by_dfs(dep.graph))
