# Submodule for importing default units
#
# Adapted from Unitful.jl/src/pkgdefaults.jl
# Copyright (c) 2016: California Institute of Technology and other contributors.

angle_units = (:rad,:sr)
non_angle_units = filter(u -> !(u ∈ angle_units), Unitful.si_no_prefix)

"""
Imports default units into the workspace.

This replicates the behavior of `Unitful.DefaultSymbols` in `Unitful.jl/src/pkgdefaults.jl`
but replaces `Unitful` Angles with `DimensionfulAngles` angles.

# Examples

```julia-repl
julia> using DimensionfulAngles.DefaultSymbols
```

will bring the following into the calling namespace:

- Dimensions 𝐋,𝐌,𝐓,𝐈,𝚯,𝐉,𝐍 and 𝐀

- Base and derived SI units, with SI prefixes

    - Candela conflicts with `Base.cd` so it is not brought in (Unitful.jl issue #102)

- Degrees: °

All angles imported removing the ᵃ superscript.

!!! note "Potential conflict with other packages"

    All angles are imported removing the ᵃ superscript.
    This means, e.g., `°` == `u"°ᵃ"` instead of `u"°"`.
    This may cause conflicts with other packages that assume angles are the dimensionless
    ones from `Unitful`.

"""
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
