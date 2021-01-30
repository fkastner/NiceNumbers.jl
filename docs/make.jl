using Documenter, NiceNumbers

makedocs(;
    modules=[NiceNumbers],
    authors="Felix Kastner <kastner.felix@gmail.com>",
    repo="https://github.com/fkastner/NiceNumbers.jl/blob/{commit}{path}#L{line}",
    sitename="NiceNumbers.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://fkastner.github.io/NiceNumbers.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
        "Index" => "functions.md",
        "Example: SVD" => "example_svd.md"
    ],
    strict = true
)

deploydocs(;
    repo="github.com/fkastner/NiceNumbers.jl",
)
