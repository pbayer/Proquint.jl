using Proquint
using Documenter

makedocs(;
    modules=[Proquint],
    authors="Paul Bayer",
    repo="https://github.com/pbayer/Proquint.jl/blob/{commit}{path}#L{line}",
    sitename="Proquint.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://pbayer.github.io/Proquint.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/pbayer/Proquint.jl",
)
