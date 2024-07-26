using ClaudePrompting
using Documenter

DocMeta.setdocmeta!(ClaudePrompting, :DocTestSetup, :(using ClaudePrompting); recursive=true)

makedocs(;
    modules=[ClaudePrompting],
    authors="Kwang-Seuk <kjeong@bhug.ac.kr> and contributors",
    sitename="ClaudePrompting.jl",
    format=Documenter.HTML(;
        canonical="https://Kwang-Seuk.github.io/ClaudePrompting.jl",
        edit_link="master",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/Kwang-Seuk/ClaudePrompting.jl",
    devbranch="master",
)
