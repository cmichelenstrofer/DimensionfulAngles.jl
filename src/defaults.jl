# Submodule for importing default units
#
# Adapted from Unitful.jl/src/pkgdefaults.jl
# Copyright (c) 2016: California Institute of Technology and other contributors.

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

    - Candela conflicts with `Base.cd` so it is brought in as `cdᵤ`.

- Degrees: °

All angles and derived units imported removing the ᵃ superscript.

!!! note "Potential conflict with other packages"

    All angles are imported removing the ᵃ superscript.
    This means, e.g., `°` == `u"°ᵃ"` instead of `u"°"`.
    This may cause conflicts with other packages that assume angles are the dimensionless
    ones from `Unitful`.

"""
baremodule DefaultSymbols
    import Unitful
    import DimensionfulAngles
    using Base: filter, ∈, !

    __angle_units = (:rad, :sr, :lm, :lx)
    __non_angle_units = filter(u -> !(u ∈ __angle_units), Unitful.si_no_prefix)

    # Unitful Dimensions
    for u in (:𝐋,:𝐌,:𝐓,:𝐈,:𝚯,:𝐉,:𝐍)
        Core.eval(DefaultSymbols, Expr(:import, Expr(:(.), :Unitful, u)))
        Core.eval(DefaultSymbols, Expr(:export, u))
    end

    # DimensionfulAngles Dimensions
    Core.eval(DefaultSymbols, Expr(:import, Expr(:(.), :DimensionfulAngles, :𝐀)))
    Core.eval(DefaultSymbols, Expr(:export, :𝐀))

    # units
    for p in Unitful.si_prefixes
        # Unitful units
        for u in __non_angle_units
            Core.eval(DefaultSymbols, Expr(:import, Expr(:(.), :Unitful, Symbol(p,u))))
            Core.eval(DefaultSymbols, Expr(:export, Symbol(p,u)))
        end
        # DimensionfulAngles units
        for u in __angle_units
            Core.eval(
                DefaultSymbols,
                Expr(:import, Expr(:(.), :DimensionfulAngles, Symbol(p,u,:ᵃ)))
            )
            Core.eval(DefaultSymbols, Expr(:(=), Symbol(p,u), Symbol(p,u,:ᵃ)))
            Core.eval(DefaultSymbols, Expr(:export, Symbol(p,u)))
        end
    end

    # degrees Celsius
    Core.eval(DefaultSymbols, Expr(:import, Expr(:(.), :Unitful, :°C)))
    Core.eval(DefaultSymbols, Expr(:export, :°C))

    # DimensionfulAngles degree
    Core.eval(DefaultSymbols, Expr(:import, Expr(:(.), :DimensionfulAngles, :°ᵃ)))
    Core.eval(DefaultSymbols, Expr(:(=), :°, :°ᵃ))
    Core.eval(DefaultSymbols, Expr(:export, :°))

    # candela
    u = :cd
    for p in Unitful.si_prefixes
        Core.eval(DefaultSymbols, Expr(:import, Expr(:(.), :Unitful, Symbol(p,u))))
        Core.eval(DefaultSymbols, Expr(:(=), Symbol(p,u,:ᵤ), Symbol(p,u)))
        Core.eval(DefaultSymbols, Expr(:export, Symbol(p,u,:ᵤ)))
    end
end
