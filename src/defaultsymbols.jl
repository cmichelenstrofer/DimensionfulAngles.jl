#########

# This replicates the behavior of Unitful.DefaultSymbols in Unitful: pkgdefaults.jl but  
# replacing Uniful Angles with DimensionfulAngles
# `using DimensionfulAngles.DefaultSymbols` will bring the following into the calling namespace:
# - Dimensions 𝐋,𝐌,𝐓,𝐈,𝚯,𝐉,𝐍 and 𝐀
# - Base and derived SI units, with SI prefixes
#   - Candela conflicts with `Base.cd` so it is not brought in (issue #102)
# - Degrees: ° 
# all angles imported removing the ᵃ
# note, this means that ° == u"°ᵃ" and ° != u"°"

angle_units = (:rad,:sr)
non_angle_units = filter(u -> !(u ∈ angle_units), Unitful.si_no_prefix)

baremodule DefaultSymbols
    import Unitful
    import DimensionfulAngles

    # Unitful Dimensions
    for u in (:𝐋,:𝐌,:𝐓,:𝐈,:𝚯,:𝐉,:𝐍)
        Core.eval(DefaultSymbols, Expr(:import, Expr(:(.), :Unitful, u)))
        Core.eval(DefaultSymbols, Expr(:export, u))
    end

    # DimensionfulAngles Dimension
    Core.eval(DefaultSymbols, Expr(:import, Expr(:(.), :DimensionfulAngles, :𝐀)))
    Core.eval(DefaultSymbols, Expr(:export, :𝐀))

    for p in Unitful.si_prefixes
        # Unitful units
        for u in DimensionfulAngles.non_angle_units
            Core.eval(DefaultSymbols, Expr(:import, Expr(:(.), :Unitful, Symbol(p,u))))
            Core.eval(DefaultSymbols, Expr(:export, Symbol(p,u)))
        end
        # DimensionfulAngles units
        for u in DimensionfulAngles.angle_units
            DAname = Symbol(p,u,:ᵃ)
            name   = Symbol(p,u)
            Core.eval(DefaultSymbols, Expr(:import, Expr(:(.), :DimensionfulAngles, DAname)))
            Core.eval(DefaultSymbols, Expr(:(=), name, DAname))
            Core.eval(DefaultSymbols, Expr(:export, name))
        end
    end

    Core.eval(DefaultSymbols, Expr(:import, Expr(:(.), :Unitful, :°C)))
    Core.eval(DefaultSymbols, Expr(:export, :°C))

    Core.eval(DefaultSymbols, Expr(:import, Expr(:(.), :DimensionfulAngles, :°ᵃ)))
    Core.eval(DefaultSymbols, Expr(:(=), :°, :°ᵃ))
    Core.eval(DefaultSymbols, Expr(:export, :°))
end