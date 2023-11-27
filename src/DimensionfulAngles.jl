"""
Extends Unitful.jl to include Angle as an independent dimension in order to facilitate
[dispatching](https://docs.julialang.org/en/v1/manual/methods/#Methods).

See the [Documentation](https://cmichelenstrofer.github.io/DimensionfulAngles/) for more
information.

!!! note "Not SI"

    *Angle* is not an SI base dimension.

# Examples

```jldoctest
julia> using DimensionfulAngles

julia> 1.0ua"turn"
1.0 τ

julia> 1.0ua"rad" - 1.0ua"°"
0.9825467074800567 rad

julia> cos(45ua"°")
0.7071067811865476
```
"""
module DimensionfulAngles

# using Base: Base  # extend: see `base.jl` for full list of functions extended
using Unitful: Unitful  # extend: has_unit_spacing, uconvert
using Unitful: minute, promotion, rad, rpm, rps, s, sr, 𝐓, 𝐋, °
using Unitful: Dimension, Dimensions, DimensionlessQuantity, FreeUnits, Frequency
using Unitful: FrequencyFreeUnits, Length, MixedUnits, NoDims, NoUnits, Number, Quantity
using Unitful: Time, Unitlike, Unit, Units, Wavenumber
using Unitful: @dimension, @refunit, @derived_dimension, @unit
using Unitful: dimension, register, uconvert, unit, ustrip
using UnitfulEquivalences: Equivalence, @eqrelation
using UnitfulAngles: turn, doubleTurn, halfTurn, quadrant, sextant, octant, clockPosition
using UnitfulAngles: hourAngle, compassPoint, hexacontade, brad, diameterPart, grad
using UnitfulAngles: arcminute, arcsecond
# using UnitfulAngles: mas, μas, pas # UnitfulAngles PR #34

export @ua_str
export θ₀
export Periodic
export sexagesimal, show_sexagesimal
# export 𝐀, Angle, AngleUnits, AngleFreeUnits
# export SolidAngle, SolidAngleUnits, SolidAngleFreeUnits
# export AngularVelocity, AngularVelocityUnits, AngularVelocityFreeUnits
# export AngularAcceleration, AngularAccelerationUnits, AngularAccelerationFreeUnits
# export AngularPeriod, AngularPeriodUnits, AngularPeriodFreeUnits
# export AngularWavenumber, AngularWavenumberUnits, AngularWavenumberFreeUnits
# export AngularWavelength, AngularWavelengthUnits, AngularWavelengthFreeUnits

"""
    𝐀

A dimension representing Angle.

!!! note "Not SI"

    *Angle* is not an SI base dimension.
"""
@dimension 𝐀 "𝐀" Angle true

# SI units
"""
    radᵃ

The radian, a unit of angle.

There are 2π rad in a circle.
The radian is the SI unit of angle.
Unlike `Unitful.rad`, which follows SI and is therefor dimensionless,
`radᵃ` has dimensions of Angle.
Accepts SI prefixes.

Dimension: [`DimensionfulAngles.𝐀`](@ref).

# Examples

```jldoctest
julia> using DimensionfulAngles

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

Dimension: [`DimensionfulAngles.𝐀`](@ref).

# Examples

```jldoctest
julia> using DimensionfulAngles

julia> 1ua"°"
1°
```
"""
@unit °ᵃ "°" Degreeᵃ (1radᵃ * π/180) false
Unitful.has_unit_spacing(u::Units{(Unit{:Degreeᵃ, 𝐀}(0, 1 // 1),), 𝐀}) = false

# Constants
"""
    θ₀

A quantity equal to the central angle of a plane circular sector whose arc length is
equal to that of its radius.
It has a value of exactly 1 rad or approximately 57.2958°.
Used as the defining constant of Angle dimension in several proposed SI extension systems.

Dimensions: 𝐀.

See also [`DimensionfulAngles.radᵃ`](@ref).

# Examples

```jldoctest
julia> using DimensionfulAngles

julia> θ₀
1//1 rad

julia> θ₀ |> ua"°"
57.29577951308232°

julia> 2.1ua"rad" / θ₀
2.1
```
"""
const θ₀ = (1 // 1)radᵃ

# Convert to/from Unitful (SI)
function _convert_angles(x::Quantity, input_angle_unit::Units, input_dim::Dimensions,
    output_angle_unit::Units, angle_units::NTuple{N, Units} where N,
    )
    # convert all units in `angle_units` to common `input_angle_unit` unit.
    # cannot use `upreferred` because of `FixedUnits` and `ContextUnits`
    AngularUnits = [
        typeof(typeof(angle_unit).parameters[1][1]) for angle_unit in angle_units
    ]

    power = 0//1
    input_units = 1
    for iunit in typeof(x).parameters[3].parameters[1]
        ipower = iunit.power
        if typeof(iunit) ∈ AngularUnits
            power += ipower
            input_units *= uconvert(
                input_angle_unit^ipower,
                1Unitful.FreeUnits{(iunit,), input_dim^ipower, nothing}()
            )
        else
            input_units *= (
                1Unitful.FreeUnits{(iunit,), typeof(iunit).parameters[2]^ipower, nothing}()
            )
        end
    end
    input_units = unit(input_units)
    x = uconvert(input_units, x)
    # convert to output units/dimensions
    return x*input_angle_unit^-power*output_angle_unit^power
end

Unitful.uconvert(s::Symbol, x::Quantity) = Unitful.uconvert(Val{s}(), x)

function Unitful.uconvert(s::Val{:Unitful}, x::Quantity)
    angle_units = (
        radᵃ, °ᵃ, turnᵃ, doubleTurnᵃ, halfTurnᵃ, quadrantᵃ, sextantᵃ, octantᵃ,
        clockPositionᵃ, hourAngleᵃ, compassPointᵃ, hexacontadeᵃ, bradᵃ, diameterPartᵃ,
        gradᵃ, arcminuteᵃ, arcsecondᵃ, asᵃ, ʰᵃ, ᵐᵃ, ˢᵃ,
    )
    x = _convert_angles(x, radᵃ, 𝐀, rad, angle_units)
    # derived units that contain angles.
    x = _convert_angles(x, srᵃ, 𝐀^2, sr, (srᵃ,))
    x = _convert_angles(x, rpsᵃ, 𝐀*𝐓^-1, rps, (rpsᵃ,))
    x = _convert_angles(x, rpmᵃ, 𝐀*𝐓^-1, rpm, (rpmᵃ,))
    return x
end

function Unitful.uconvert(s::Val{:DimensionfulAngles}, x::Quantity)
    angle_units = (
        rad, °, turn, doubleTurn, halfTurn, quadrant, sextant, octant, clockPosition,
        hourAngle, compassPoint, hexacontade, brad, diameterPart, grad, arcminute,
        arcsecond,
        # TODO: mas, μas, pas  # UnitfulAngles PR #34
    )
    x = _convert_angles(x, rad, NoDims, radᵃ, angle_units)
    # derived units that contain angles.
    x = _convert_angles(x, sr, NoDims, srᵃ, (sr,))
    x = _convert_angles(x, rps, NoDims, rpsᵃ, (rps,))
    x = _convert_angles(x, rpm, NoDims, rpmᵃ, (rpm,))
    return x
end

# Other functionalities.
include("units.jl")  # Other units of angle.
include("derived.jl")  # Units and functionalities for derived dimensions.
include("uamacro.jl")  # String macro for using dimensionful units.
include("base.jl")  # Extend Base functions for units of angle.
include("defaults.jl") # Submodule to flood workspace with unit types.

# Register new units and dimensions with Unitful.jl.
const localpromotion = copy(promotion)
function __init__()
    register(DimensionfulAngles)
    merge!(promotion, localpromotion)
    return nothing
end

end
