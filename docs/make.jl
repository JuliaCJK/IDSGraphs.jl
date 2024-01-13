push!(LOAD_PATH, "../src/")

using Documenter, IDSGraphs

DocMeta.setdocmeta!(IDSGraphs, :DocTestSetup, :(using IDSGraphs); recursive=true)

makedocs(
    sitename="IDSGraphs.jl Documentation",
    #modules=[IDSGraphs],
    pages=[
        "Home" => "index.md",
        "Quick Start" => "guide_quickstart.md",
        "API Reference" => [
            "Structures" => "api_structures.md",
            "Component Dependency Graphs" => "api_depgraphs.md",
            "Internals" => "api_internals.md",
        ]
    ],
    doctest=false,
)

if get(ENV, "CI", nothing) == "true"
    deploydocs(
        repo = "github.com/JuliaCJK/IDSGraphs.jl.git",
        devbranch = "main",
        devurl="latest",
    )
end
