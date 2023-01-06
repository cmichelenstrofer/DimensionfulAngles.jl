using Documenter
using DocumenterCitations
using DimensionfulAngles
using Unitful

bib = CitationBibliography(joinpath(@__DIR__, "references.bib"))

function _filter_prefixed(base, x; exceptions = [nothing])
    n = length(base)
    if (typeof(x) <: Unitful.Unitlike &&
        length("$x") > n &&
        "$x"[(end - n + 1):end] == base &&
        "$x" ∉ exceptions)
        return true
    end
    return false
end

makedocs(bib;
         sitename = "DimensionfulAngles",
         format = Documenter.HTML(),
         modules = [DimensionfulAngles],
         pages = ["Home" => "index.md",
             "Angle as a dimension?" => "motivation.md",
             "Package Guide" => ["guide/intro.md",
                 "guide/units.md",
                 "guide/derived.md",
                 "guide/base.md"],
             "Relationship to proposed SI extensions." => "proposed.md",
             "Index" => "syntax.md"])

deploydocs(; repo = "github.com/cmichelenstrofer/DimensionfulAngles.jl.git")
