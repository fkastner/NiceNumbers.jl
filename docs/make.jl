using Documenter, NiceNumbers

makedocs(;
    modules = [NiceNumbers],
    authors = "Felix Kastner <kastner.felix@gmail.com>",
    repo = Remotes.GitHub("fkastner", "NiceNumbers.jl"),
    sitename = "NiceNumbers.jl",
    format = Documenter.HTML(;
        prettyurls = get(ENV, "CI", "false") == "true",
        canonical = "https://fkastner.github.io/NiceNumbers.jl",
        assets = String[],
    ),
    pages = [
        "Home" => "index.md",
        "Index" => "functions.md",
        "Example: SVD" => "example_svd.md"
    ]
)

deploydocs(;
    repo = "github.com/fkastner/NiceNumbers.jl",
    push_preview = true
)
