# Additional angle units.
#
# Some parts adapted from UnitfulAngles.jl/src/UnitfulAngles.jl.
# Copyright (c) 2017: Yakir Luc Gagnon.
#
# Partly based on Wikipedia's Angle units table (https://en.wikipedia.org/wiki/Angle#Units).

function __unit_docstr(symb, name, def, ref, add = "")
    docs = """
        $(symb)ᵃ

    The $(name), a unit of angle defined as $(def).

    $(add)
    This differs from `UnitfulAngles.$(symb)` in that it contains units of angle.
    Does not accepts SI prefixes.

    Dimension: 𝐀.

    See also [`DimensionfulAngles.$(ref)ᵃ`](@ref).
    """
    return docs
end

# Based on degree
@doc __unit_docstr("arcminute", "minute of arc", "1°/60", "°")
@unit arcminuteᵃ "′" Arcminuteᵃ (1°ᵃ//60) false
Unitful.has_unit_spacing(u::Units{(Unit{:Arcminuteᵃ, 𝐀}(0, 1 // 1),), 𝐀}) = false

@doc __unit_docstr("arcsecond", "second of arc", "1°/3600", "°")
@unit arcsecondᵃ "″" Arcsecondᵃ (1°ᵃ//3600) false
Unitful.has_unit_spacing(u::Units{(Unit{:Arcsecondᵃ, 𝐀}(0, 1 // 1),), 𝐀}) = false

# Based on radian
@doc __unit_docstr("diameterPart", "diameter part", "1/60 rad", "rad")
@unit diameterPartᵃ "diameterPart" DiameterPartᵃ (1radᵃ//60) false

# Turn
@doc __unit_docstr(
    "turn", "turn", "2π rad", "rad",
    "Equivalent to a full cycle, revolution, or rotation."
)
@unit turnᵃ "τ" Turnᵃ (360°ᵃ) false

# Based on the turn
@doc __unit_docstr("doubleTurn", "double turn", "2 turn", "turn")
@unit doubleTurnᵃ "§" DoubleTurnᵃ 2turnᵃ false

@doc __unit_docstr("halfTurn", "half turn", "1/2 turn", "turn")
@unit halfTurnᵃ "π" HalfTurnᵃ (1turnᵃ//2) false

@doc __unit_docstr("quadrant", "quadrant", "1/4 turn", "turn")
@unit quadrantᵃ "⦜" Quadrantᵃ (1turnᵃ//4) false

@doc __unit_docstr("sextant", "sextant", "1/6 turn", "turn")
@unit sextantᵃ "sextant" Sextantᵃ (1turnᵃ//6) false

@doc __unit_docstr("octant", "octant", "1/8 turn", "turn")
@unit octantᵃ "octant" Octantᵃ (1turnᵃ//8) false

@doc __unit_docstr("clockPosition", "clock position", "1/12 turn", "turn")
@unit clockPositionᵃ "clockPosition" ClockPositionᵃ (1turnᵃ//12) false

@doc __unit_docstr("hourAngle", "hour angle", "1/24 turn", "turn")
@unit hourAngleᵃ "hourAngle" HourAngleᵃ (1turnᵃ//24) false

@doc __unit_docstr("compassPoint", "compass point", "1/32 turn", "turn",
                   ("[Other compass point definitions]" *
                    "(https://en.wikipedia.org/wiki/Points_of_the_compass) also exist."))
@unit compassPointᵃ "compassPoint" CompassPointᵃ (1turnᵃ//32) false

@doc __unit_docstr("hexacontade", "hexacontade", "1/60 turn", "turn")
@unit hexacontadeᵃ "hexacontade" Hexacontadeᵃ (1turnᵃ//60) false

@doc __unit_docstr("brad", "binary radian", "1/256 turn", "turn",
                   "Also known as the binary degree.")
@unit bradᵃ "brad" BinaryRadianᵃ (1turnᵃ//256) false

@doc __unit_docstr("grad", "gradian", "1/400 turn", "turn")
@unit gradᵃ "ᵍ" Gradianᵃ (1turnᵃ//400) false

# Astronomy
"""
    $asᵃ

The arcsecond, a unit of angle defined as 1°/3600.

This is an alternative symbol for [`DimensionfulAngles.arcsecondᵃ`](@ref) common in
astronomy.
Unlike `arcsecondᵃ`, `asᵃ` accepts SI prefixes.
`UnitfulAngles` has similar implementation; this differs in that it contains units of
angle.

!!! note "Abbreviation conflicts with `Unitful.jl`"
    - both attoseconds and arcseconds are abbreviated as `as`.
    - both decaseconds and deciarcseconds are abbreviated as `das`.

Dimension: 𝐀.

See also [`DimensionfulAngles.arcsecondᵃ`](@ref).
"""
@unit asᵃ "as" ArcsecondAstro 1arcsecondᵃ true true

@doc __unit_docstr("ʰ", "hour", "1/24 turn", "turn", "Equivalent to `hourAngleᵃ`.")
@unit ʰᵃ "ʰ" HourAstro (1turnᵃ//24) false
Unitful.has_unit_spacing(u::Units{(Unit{:HourAstro, 𝐀}(0, 1 // 1),), 𝐀}) = false

@doc __unit_docstr("ᵐ", "minute", "1ʰ/60", "ʰ")
@unit ᵐᵃ "ᵐ" MinuteAstro (1ʰᵃ//60) false
Unitful.has_unit_spacing(u::Units{(Unit{:MinuteAstro, 𝐀}(0, 1 // 1),), 𝐀}) = false

@doc __unit_docstr("ˢ", "second", "1ʰ/3600", "ʰ")
@unit ˢᵃ "ˢ" SecondAstro (1ʰᵃ//3600) false
Unitful.has_unit_spacing(u::Units{(Unit{:SecondAstro, 𝐀}(0, 1 // 1),), 𝐀}) = false

# Display other unit formats.
"""
    sexagesimal(x::Angle; base_unit::AngleUnits=°ᵃ)

Convert an angle to the triple (unit, minutes of unit, seconds of unit), where unit is
either degree (`°ᵃ`) or hour angle (`ʰᵃ`).

!!! note

    Minutes and seconds of a degree are different from minutes and seconds of an hour angle.
    In both cases a minute is 1/60ᵗʰ of the base unit and a second is 1/60ᵗʰ of that.

# Example

```jldoctest
julia> using DimensionfulAngles

julia> sexagesimal(20.2ua"°")
(20°, 11′, 59.99999999999746″)

julia> sexagesimal(20.2ua"°"; base_unit = ua"ʰ")
(1ʰ, 20ᵐ, 48.00000000000026ˢ)
```
"""
function sexagesimal(x::Angle; base_unit::AngleUnits = °ᵃ)
    base_unit in [°ᵃ, ʰᵃ] || throw(ArgumentError("`unit` must be `°ᵃ` or `ʰᵃ`."))
    base_unit == °ᵃ && ((minute_unit, second_unit) = (arcminuteᵃ, arcsecondᵃ))
    base_unit == ʰᵃ && ((minute_unit, second_unit) = (ᵐᵃ, ˢᵃ))
    base = trunc(Int, ustrip(x |> base_unit)) * base_unit
    minute = trunc(Int, ustrip((x - base) |> minute_unit)) * minute_unit
    second = ustrip((x - base - minute) |> second_unit) * second_unit
    return (base, minute, second)
end

"""
    show_sexagesimal(x::Angle; base_unit::AngleUnits=°ᵃ)

Print an angle in units (u), minutes of unit (m), and seconds of unit (s) where unit is
either degree (`°ᵃ`) or hour angle (`ʰ`).
For degrees it is printed as `u° m′ s″` and for hour angle as `uʰ mᵐ sˢ`.

# Example

```jldoctest
julia> using DimensionfulAngles

julia> show_sexagesimal(20.2ua"°")
20° 11′ 59.99999999999746″

julia> show_sexagesimal(20.2ua"°"; base_unit = ua"ʰ")
1ʰ 20ᵐ 48.00000000000026ˢ
```
"""
function show_sexagesimal(x::Angle; base_unit::AngleUnits = °ᵃ)
    base, minute, second = sexagesimal(x; base_unit = base_unit)
    print("$base $minute $second")
    return nothing
end
