push!(LOAD_PATH, "../src/")

using Documenter, IDSFiles
using DataStructures

makedocs(
    sitename="IDSFiles.jl Documentation",
    format=Documenter.HTML(
        prettyurls=get(ENV, "CI", nothing) == "true"
    ),
    modules=[IDSFiles],
    pages=[
        "Home" => "index.md",
        "Quick Start" => "guide_quickstart.md",
        "API Reference" => [
            "Structures" => "api_structures.md",
            "Component Dependency Graphs" => "api_depgraphs.md",
            "Internals" => "api_internals.md"
        ]
    ]
)

deploydocs(
    repo = "github.com/tmthyln/IDSFiles.jl.git",
    devbranch = "main",
    devurl="latest"
    )
