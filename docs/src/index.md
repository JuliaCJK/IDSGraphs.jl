# IDSGraphs.jl Documentation

This is a convenience package for reading and processing IDS files, which represent decompositions of CJK (Chinese, Japanese, Korean) language characters. Functionality is provided for the pipeline from reading IDS files to representing them as a graph of character component dependencies.

Still in early development! APIs have yet to be finalized, more basic features will be added, tests are currently non-existent, and documentation is sparse. Development is ongoing.

```@contents
```


## Installation

This package can be installed as usual via Pkg, either using

```julia-repl
julia> ] add IDSGraphs
```

or

```julia-repl
julia> using Pkg
julia> Pkg.install("IDSGraphs")
```
