using Documenter, NiceNumbers

makedocs(
    sitename = "NiceNumbers.jl",
    modules = [NiceNumbers],
    pages = ["Home" => "index.md",
             "Index" => "functions.md",
             "Example: SVD" => "example_svd.md"],
    format = Documenter.HTML(prettyurls = get(ENV, "CI", nothing) == "true"),
    strict = true
)

deploydocs(repo = "github.com/fkastner/NiceNumbers.jl.git")
