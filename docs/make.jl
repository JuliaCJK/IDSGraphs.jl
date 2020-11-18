push!(LOAD_PATH, "../src/")

using Documenter, IDSFiles

makedocs(
    sitename="IDSFiles.jl Documentation",
    format=Documenter.HTML(
        prettyurls=get(ENV, "CI", nothing) == "true"
    ),
    modules=[IDSFiles],
    pages=[
    "Documentation Home" => "index.md",
        "API Reference" => [
            "Structures" => "api_structures.md",
            "Component Dependency Graphs" => "api_depgraphs.md"
        ]
    ]
)

deploydocs(
    repo = "github.com/tmthyln/IDSFiles.jl.git",
    devbranch = "main",
    devurl="latest"
    )
