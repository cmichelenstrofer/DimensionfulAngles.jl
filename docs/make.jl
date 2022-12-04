using Documenter
using UnitfulAngleDimension

makedocs(
    sitename = "UnitfulAngleDimension",
    format = Documenter.HTML(),
    modules = [UnitfulAngleDimension]
)

# Documenter can also automatically deploy documentation to gh-pages.
# See "Hosting Documentation" and deploydocs() in the Documenter manual
# for more information.
#=deploydocs(
    repo = "<repository url>"
)=#
