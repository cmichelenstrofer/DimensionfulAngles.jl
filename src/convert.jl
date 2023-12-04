# Convert to/from Unitful
# this is tedious precisely because Unitful cannot dispatch on angles

"""
    uconvert(s::Symbol, x::Quantity)

Convert between DimensionfulAngles and Unitful angles (non-dimensional, SI).
The Symbol `s` is either `:Unitful`, to convert to Unitful angles, or `DimensionfulAngles`
to convert to DimensionfulAngles angles.
It converts angle units and the following derived units: `sr`, `rpm`, `rps`).

!!! note "Astronomical units are not equivalent between these two packages"
    Astronomical units in `DimensionfulAngles` and `UnitfulAngles` are not equivalent,
    and are converted to compatible units first. See documentation for more information.

# Example

```jldoctest; filter = r"(\\d*).(\\d{1,10})\\d+" => s"\\1.\\2"
julia> using Unitful, DimensionfulAngles

julia> ω = 3.2u"radᵃ/s"
3.2 rad s⁻¹

julia> ω̄ = uconvert(:Unitful, ω)
3.2 rad s⁻¹

julia> dimension(ω)
𝐀 𝐓⁻¹

julia> dimension(ω̄)
𝐓⁻¹

julia> dimension(uconvert(:DimensionfulAngles, ω̄))
𝐀 𝐓⁻¹
```
"""
Unitful.uconvert(s::Symbol, x::Quantity) = Unitful.uconvert(Val{s}(), x)

function Unitful.uconvert(s::Val{:Unitful}, x::Quantity)
    # unequivalent units
    x = _convert_unequivalent_dimensionfulangles(x)
    # angle units
    for (ua, u) in _angle_unit_pairs()[2]
        x = _convert_units(x, ua, 𝐀, u, NoDims)
    end
    # derived units that contain angles
    x = _convert_units(x, srᵃ, 𝐀^2, sr, NoDims)
    x = _convert_units(x, rpsᵃ, 𝐀*𝐓^-1, rps, 𝐓^-1)
    x = _convert_units(x, rpmᵃ, 𝐀*𝐓^-1, rpm, 𝐓^-1)
    x = _convert_units(x, lmᵃ, 𝐀^2*𝐉, lm, 𝐉)
    x = _convert_units(x, lxᵃ, 𝐀^2*𝐉*𝐋^-2, lx, 𝐉*𝐋^-2)
    return x
end

function Unitful.uconvert(s::Val{:DimensionfulAngles}, x::Quantity)
    # unequivalent units
    x = _convert_unequivalent_unitful(x)
    # angle units
    for (u, ua) in _angle_unit_pairs()[1]
        x = _convert_units(x, u, NoDims, ua, 𝐀)
    end
    # derived units that contain angles
    x = _convert_units(x, sr, NoDims, srᵃ, 𝐀^2)
    x = _convert_units(x, rps, 𝐓^-1, rpsᵃ, 𝐀*𝐓^-1)
    x = _convert_units(x, rpm, 𝐓^-1, rpmᵃ, 𝐀*𝐓^-1)
    x = _convert_units(x, lm, 𝐉, lmᵃ, 𝐀^2*𝐉)
    x = _convert_units(x, lx, 𝐉*𝐋^-2, lxᵃ, 𝐀^2*𝐉*𝐋^-2)
    return x
end

function _unittype(x, unit, dim, dim_power)
    free = FreeUnits{(unit,), dim^dim_power, nothing}
    T = typeof(x).parameters[3]
    S = (
        (T <: FreeUnits) ? free :
        (T <: FixedUnits) ? (S = FixedUnits{(unit,), dim^dim_power, nothing}) :
        (T <: ContextUnits) ? (S = ContextUnits{(unit,), dim^dim_power, free, nothing}) :
        nothing
    )
    return S
end

function _convert_unequivalent_unitful(x)
    unequivalent = [
        mas,
        μas,
        pas
    ]
    # determine output units
    unequivalent_units = [typeof(typeof(u).parameters[1][1]) for u in unequivalent]
    output_units = NoUnits
    for iunit in typeof(x).parameters[3].parameters[1]
        output_units *= (
            typeof(iunit)∈unequivalent_units ? arcsecond^iunit.power :
            _unittype(x, iunit, NoDims, 1)()
        )
    end
    # convert
    return uconvert(output_units, x)
end

function _convert_unequivalent_dimensionfulangles(x)
    unequivalent_arcsecond = [asᵃ]
    unequivalent_hourangle = [ʰᵃ, ᵐᵃ, ˢᵃ]
    # determine output units
    unequivalent_units_arcsecond = (
        [typeof(typeof(u).parameters[1][1]) for u in unequivalent_arcsecond]
    )
    unequivalent_units_hourangle = (
        [typeof(typeof(u).parameters[1][1]) for u in unequivalent_hourangle]
    )
    output_units = NoUnits
    for iunit in typeof(x).parameters[3].parameters[1]
        output_units *= (
            typeof(iunit)∈unequivalent_units_arcsecond ? arcsecondᵃ^iunit.power :
            typeof(iunit)∈unequivalent_units_hourangle ? hourAngleᵃ^iunit.power :
            _unittype(x, iunit, 𝐀, iunit.power)()
        )
    end
    # convert
    return uconvert(output_units, x)
end

function _angle_unit_pairs()
    unitful_dimensionful = [
        (rad, radᵃ), # prefixes
        (°, °ᵃ),
        (turn, turnᵃ),
        (doubleTurn, doubleTurnᵃ),
        (halfTurn, halfTurnᵃ),
        (quadrant, quadrantᵃ),
        (sextant, sextantᵃ),
        (octant, octantᵃ),
        (clockPosition, clockPositionᵃ),
        (hourAngle, hourAngleᵃ),
        (compassPoint, compassPointᵃ),
        (hexacontade, hexacontadeᵃ),
        (brad, bradᵃ),
        (diameterPart, diameterPartᵃ),
        (grad, gradᵃ),
        (arcminute, arcminuteᵃ),
        (arcsecond, arcsecondᵃ),
    ]
    dimensionful_unitful = [(y, x) for (x,y) in unitful_dimensionful]
    return unitful_dimensionful, dimensionful_unitful
end

function _convert_units(
        x::Quantity,
        input_unit::Units, input_dim::Dimensions,
        output_unit::Units, output_dim::Dimensions,
    )

    AngularUnit = typeof(typeof(input_unit).parameters[1][1])



    for iunit in typeof(x).parameters[3].parameters[1]
        (ipower, itens) = (iunit.power, iunit.tens)
        if typeof(iunit) == AngularUnit
            ounit = typeof(typeof(output_unit).parameters[1][1])(itens, ipower)
            x *= (
                _unittype(x, iunit, input_dim, ipower)()^-1 *
                _unittype(x, ounit, output_dim, ipower)()
            )
        end
    end
    return x
end
