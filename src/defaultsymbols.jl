#########

# This replicates the behavior of Unitful.DefaultSymbols in Unitful: pkgdefaults.jl but  
# replacing Uniful Angles with DimensionfulAngles
# `using DimensionfulAngles.DefaultSymbols` will bring the following into the calling namespace:
# - Dimensions 𝐋,𝐌,𝐓,𝐈,𝚯,𝐉,𝐍
# - Base and derived SI units, with SI prefixes
#   - Candela conflicts with `Base.cd` so it is not brought in (issue #102)
# - Degrees: °

baremodule DefaultSymbols
    import Unitful
    import DimensionfulAngles

    for u in (:𝐋,:𝐌,:𝐓,:𝐈,:𝚯,:𝐉,:𝐍)
        Core.eval(DefaultSymbols, Expr(:import, Expr(:(.), :Unitful, u)))
        Core.eval(DefaultSymbols, Expr(:export, u))
    end

    # angle_units = (:rad,:sr)
    # non_angle_units = filter(u -> !(u ∈ angle_units), Unitful.si_no_prefix)

    # for p in Unitful.si_prefixes
    #     for u in non_angle_units
    #         Core.eval(DefaultSymbols, Expr(:import, Expr(:(.), :Unitful, Symbol(p,u))))
    #         Core.eval(DefaultSymbols, Expr(:export, Symbol(p,u)))
    #     end
    #     # for u in angle_units
    #     #     Core.eval(DefaultSymbols, Expr(:import, Expr(:(.), :DimensionfulAngles, 
    #     #         Symbol(p,u,:ᵃ), :as, Symbol(p,u))))
    #     #     Core.eval(DefaultSymbols, Expr(:export, Symbol(p,u)))
    #     # end
    # end

    Core.eval(DefaultSymbols, Expr(:import, Expr(:(.), :Unitful, :°C)))
    Core.eval(DefaultSymbols, Expr(:export, :°C))

    Core.eval(DefaultSymbols, Expr(:import, Expr(:(.), :Unitful, :°)))
    Core.eval(DefaultSymbols, Expr(:export, :°))
end