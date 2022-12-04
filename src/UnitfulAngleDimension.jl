"""
Extends Unitful.jl to include Angle as an independent dimension in order to facilitate
[dispatching](https://docs.julialang.org/en/v1/manual/methods/#Methods).

Please see the [Documentation](https://cmichelenstrofer.github.io/UnitfulAngleDimension/)
for more information.

!!! note "Not SI"
    *Angle* is not an SI base dimension.

# Exports
$(EXPORTS)

# Examples
```jldoctest
julia> 1.0ua"turn"
1.0 τ

julia> 1.0ua"rad" - 1.0ua"°"
0.9825467074800567 rad

julia> cos(45ua"°")
0.7071067811865476
```
"""
module UnitfulAngleDimension

using Unitful: Unitful  # extend: has_unit_spacing,
using Unitful: minute, promotion, rad, s, 𝐓
using Unitful: Dimension, DimensionlessQuantity, Frequency, FrequencyFreeUnits, MixedUnits,
    NoDims, NoUnits, Number, Quantity, Time, Unitlike, Unit, Units
using Unitful: @dimension, @refunit, @derived_dimension, @unit
using Unitful: dimension, register, ustrip
using UnitfulEquivalences: Equivalence, @eqrelation
using DocStringExtensions: EXPORTS
# using Base: Base  # See `base.jl` for extended functions in Base

export @ua_str


"""
    𝐀

A dimension representing Angle.

!!! note "Not SI"
    *Angle* is not an SI base dimension.
"""
@dimension 𝐀 "𝐀" Angle true

# SI units
""""
    radᵃ

The radian, a unit of angle.

There are 2π rad in a circle.
The radian is the SI unit of angle.
Unlike `Unitful.rad`, which follows SI and is therefor dimensionless,
`radᵃ` has dimensions of Angle.
Accepts SI prefixes.

Dimension: [`UnitfulAngleDimension.𝐀`](@ref).

# Examples
```jldoctest
julia> 1.0ua"rad" + 20.0ua"mrad"
1.02 rad
```
"""
@refunit radᵃ "rad" Radianᵃ 𝐀 true true

"""
    °ᵃ

The degree, a unit of angle.

There are 360° in a circle.
The degree is an SI-accepted unit of angle.
Unlike `Unitful.°`, which follows SI and is therefor dimensionless,
`°ᵃ` has dimensions of Angle.
Does not accepts SI prefixes.

Dimension: [`UnitfulAngleDimension.𝐀`](@ref).

# Examples
```jldoctest
julia> 1ua"°"
1 °
```
"""
@unit °ᵃ "°" Degreeᵃ radᵃ*π/180 false
Unitful.has_unit_spacing(u::Units{(Unit{:Degreeᵃ, 𝐀}(0, 1//1),), 𝐀}) = false

# constants
"""
    θ₀

A quantity equal to the central angle of a plane circular sector whose arc length is
equal to that of its radius.
It has a value of exactly 1 rad or approximately 57.2958°.
Used as the defining constant of Angle dimension in several proposed SI extension systems.

Dimensions: 𝐀.

See also [`UnitfulAngleDimension.radᵃ`](@ref).
"""
const θ₀ = (1//1)radᵃ

# other functionalities
include("units.jl") # other units of angle
include("base.jl") # extend Base functions for units of angle
include("uamacro.jl")  # string macro for using dimensionful units
include("derived.jl")  # units and functionalities for derived dimensions

# register
const localpromotion = promotion
function __init__()
    register(UnitfulAngleDimension)
    merge!(promotion, localpromotion)
end

end
