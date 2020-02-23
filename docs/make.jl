using Documenter, NiceNumbers

makedocs(
    sitename = "NiceNumbers.jl",
    modules = [NiceNumbers],
    pages = [
        "Home" => "index.md"
    ],
    format = Documenter.HTML(prettyurls = get(ENV, "CI", nothing) == "true")
)

deploydocs(
    repo = "github.com/fkastner/NiceNumbers.jl.git"
)
