# Additional angle units.
#
# Some parts adapted from UnitfulAngles.jl/src/UnitfulAngles.jl.
# Copyright (c) 2017: Yakir Luc Gagnon.
#
# Partly based on Wikipedia's Angle units table (https://en.wikipedia.org/wiki/Angle#Units).

function _unit_docstr(symb, name, def, ref, add="")
    docs = """
        $(symb)ᵃ

    The $(name), a unit of angle defined as $(def).

    $(add)
    This differs from `UnitfulAngles.$(symb)` in that it contains units of angle.
    Does not accepts SI prefixes.

    Dimension: 𝐀.

    See also [`UnitfulAngleDimension.$(ref)ᵃ`](@ref).
    """
    return docs
end

# based on degree
@doc _unit_docstr("arcminute", "minute of arc", "1°/60", "°")
@unit arcminuteᵃ "′" Arcminuteᵃ °ᵃ//60 false
Unitful.has_unit_spacing(u::Units{(Unit{:Arcminuteᵃ, 𝐀}(0, 1//1),), 𝐀}) = false

@doc _unit_docstr("arcsecond", "second of arc", "1°/3600", "°")
@unit arcsecondᵃ "″" Arcsecondᵃ °ᵃ//3600 false
Unitful.has_unit_spacing(u::Units{(Unit{:Arcsecondᵃ, 𝐀}(0, 1//1),), 𝐀}) = false

# based on radian
@doc _unit_docstr("diameterPart", "diameter part", "1/60 rad", "rad")
@unit diameterPartᵃ "diameterPart" DiameterPartᵃ radᵃ//60 false

@doc _unit_docstr("turn", "turn", "2π rad", "rad",
    "Equivalent to a full cycle, revolution, or rotation."
)
@unit turnᵃ "τ" Turnᵃ 2π * radᵃ false

# based on the turn
@doc _unit_docstr("doubleTurn", "double turn", "2 turn", "turn")
@unit doubleTurnᵃ "§" DoubleTurnᵃ 2turnᵃ false

@doc _unit_docstr("halfTurn", "half turn", "1/2 turn", "turn")
@unit halfTurnᵃ "π" HalfTurnᵃ turnᵃ//2 false

@doc _unit_docstr("quadrant", "quadrant", "1/4 turn", "turn")
@unit quadrantᵃ "⦜" Quadrantᵃ turnᵃ//4 false

@doc _unit_docstr("sextant", "sextant", "1/6 turn", "turn")
@unit sextantᵃ "sextant" Sextantᵃ turnᵃ//6 false

@doc _unit_docstr("octant", "octant", "1/8 turn", "turn")
@unit octantᵃ "octant" Octantᵃ turnᵃ//8 false

@doc _unit_docstr("clockPosition", "clock position", "1/12 turn", "turn")
@unit clockPositionᵃ "clockPosition" ClockPositionᵃ turnᵃ//12 false

@doc _unit_docstr("hourAngle", "hour angle", "1/24 turn", "turn")
@unit hourAngleᵃ "hourAngle" HourAngleᵃ turnᵃ//24 false

@doc _unit_docstr("compassPoint", "compass point", "1/32 turn", "turn",
    "[Other compass point definitions](https://en.wikipedia.org/wiki/Points_of_the_compass)
    also exist."
)
@unit compassPointᵃ "compassPoint" CompassPointᵃ turnᵃ//32 false

@doc _unit_docstr("hexacontade", "hexacontade", "1/60 turn", "turn")
@unit hexacontadeᵃ "hexacontade" Hexacontadeᵃ turnᵃ//60 false

@doc _unit_docstr("brad", "binary radian", "1/256 turn", "turn",
    "Also known as the binary degree."
)
@unit bradᵃ "brad" BinaryRadianᵃ turnᵃ//256 false

@doc _unit_docstr("grad", "gradian", "1/400 turn", "turn")
@unit gradᵃ "ᵍ" Gradianᵃ turnᵃ//400 false

# astronomy
"""
    $asᵃ

The arcsecond, a unit of angle defined as 1°/3600.

This is an alternative symbol for [`UnitfulAngleDimension.$arcsecondᵃ`](@ref) common in
astronomy.
Unlike `arcsecondᵃ`, `asᵃ` accepts SI prefixes.
`UnitfulAngles` has similar implementation, which differs in that it contains units of
angle.

!!! note "Abbreviation conflicts with `Unitful.jl`"
    - both attoseconds and arcseconds are abbreviated as `as`.
    - both decaseconds and deciarcseconds are abbreviated as `das`.

Dimension: 𝐀.

See also [`UnitfulAngleDimension.arcsecondᵃ`](@ref).
"""
@unit asᵃ "as" ArcsecondAstro 1arcsecondᵃ true true

@doc _unit_docstr("ʰ", "hour", "1/24 turn", "turn", "Equivalent to `hourAngleᵃ`.")
@unit ʰᵃ "ʰ" HourAstro turnᵃ//24 false
Unitful.has_unit_spacing(u::Units{(Unit{:HourAstro, 𝐀}(0, 1//1),), 𝐀}) = false

@doc _unit_docstr("ᵐ", "minute", "1ʰ/60", "ʰ")
@unit ᵐᵃ "ᵐ" MinuteAstro ʰᵃ//60 false
Unitful.has_unit_spacing(u::Units{(Unit{:MinuteAstro, 𝐀}(0, 1//1),), 𝐀}) = false

@doc _unit_docstr("ˢ", "second", "1ʰ/3600", "ʰ")
@unit ˢᵃ "ˢ" SecondAstro ʰᵃ//3600 false
Unitful.has_unit_spacing(u::Units{(Unit{:SecondAstro, 𝐀}(0, 1//1),), 𝐀}) = false

# display other unit formats
"""
    show_hms(x::Angle)

Print an angle in hours (h), minutes (m), and seconds (s) as hʰmᵐsˢ.
"""
function show_hms(x::Angle)
    h = trunc(Int, ustrip(x |> ʰᵃ))ʰᵃ
    m = trunc(Int, ustrip((x-h) |> ᵐᵃ))ᵐᵃ
    s = (x-h-m) |> ˢᵃ
    print("$(h.val)ʰ $(m.val)ᵐ $(s.val)ˢ")
end

"""
    show_dms(x::Angle)

Print an angle in degrees (d), minutes of a degree (m), and seconds of a degree (s) as
d°m′s″.
"""
function show_dms(x::Angle)
    d = trunc(Int, ustrip(x |> °ᵃ))°ᵃ
    m = trunc(Int, ustrip((x-d) |> arcminuteᵃ))arcminuteᵃ
    s = (x-d-m) |> arcsecondᵃ
    print("$(d.val)° $(m.val)′ $(s.val)″")
end
