using LightGraphs
import LightGraphs: add_vertex!, add_edge!, SimpleDiGraph
using Pkg.Artifacts

# Dependency graph struct creation
# --------------------------------
struct IDSGraph <: AbstractGraph{Char}
    graph::SimpleDiGraph{UInt32}
    mapping::Dict{Char, UInt32}
    reverse_mapping::Vector{Char}
    structures::Dict{Char, CharStructure}
end
function IDSGraph()
     IDSGraph(
        SimpleDiGraph{UInt32}(),
        Dict{Char, UInt32}(),
        Vector{Char}(),
        Dict{Char, CharStructure}())
end
function IDSGraph(filename::AbstractString)
    pattern = r"^[^\s]+\s+([^\s])\s+(.+)$"

    dep = IDSGraph()

    for line in eachline(filename)
        startswith(line, "#") && continue

        m = match(pattern, line)
        m === nothing && continue
        char_str, ids_string = m.captures
        char = first(char_str)

        add_vertex!(dep, char)
        for component in filter(c -> c ∉ range('⿰', '⿻', step = 1) && c != char, ids_string)
            add_edge!(dep, component, char)
        end
        dep.structures[char] = parse(ids_string)
    end

    dep
end
function IDSGraph(src::Symbol)
    # artifact management
    if src == :ids
        artifact_toml = joinpath(@__DIR__, "Artifacts.toml")
        ids_hash = artifact_hash("ids", artifact_toml)

        if ids_hash === nothing || !artifact_exists(ids_hash)
            ids_hash = create_artifact() do artifact_dir
                ids_url = "https://raw.githubusercontent.com/cjkvi/cjkvi-ids/master/ids.txt"
                @info "Downloading IDS file from $(ids_url)..."
                download(ids_url, joinpath(artifact_dir, "ids.txt"))
            end

            bind_artifact!(artifact_toml, "ids", ids_hash)
        end

        filename = joinpath(artifact_path(ids_hash), "ids.txt")
    else
        throw(ArgumentError("unknown identifier $(src) for a IDS file"))
    end

    IDSGraph(filename)
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

function add_structure!(dep::IDSGraph, vertex::Char, structure::CharStructure)
    dep.structures[vertex] = structure
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

function subgraph(dep::IDSGraph, condition)
    vlist = [v for v in vertices(dep.graph) if condition(v)]
    length(vlist) == 0 && return IDSGraph()
    sg, vmap = induced_subgraph(dep.graph, vlist)

    reverse_mapping = [dep.reverse_mapping[vmap[sg_code]] for sg_code in 1:length(vlist)]
    mapping = Dict(char => sg_code for (sg_code, char) in enumerate(reverse_mapping))
    structures = Dict(char => structure for (char, structure) in dep.structures if haskey(mapping, char))

    IDSGraph(sg, mapping, reverse_mapping, structures)
end

topological_sort(dep::IDSGraph) =
    (dep.reverse_mapping[code] for code in LightGraphs.Traversals.topological_sort(dep.graph))
