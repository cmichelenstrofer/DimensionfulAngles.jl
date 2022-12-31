# Other units of angle

While the radian ([`DimensionfulAngles.radᵃ`](@ref)) and the degree ([`DimensionfulAngles.°ᵃ`](@ref)) should cover must use cases, there are many other units of angle.
Based on [this table](https://en.wikipedia.org/wiki/Angle#Units) and [UnitfulAngles.jl](https://github.com/yakir12/UnitfulAngles.jl), the following units are also provided:

  - [`DimensionfulAngles.arcminuteᵃ`](@ref)
  - [`DimensionfulAngles.arcsecondᵃ`](@ref)
  - [`DimensionfulAngles.diameterPartᵃ`](@ref)
  - [`DimensionfulAngles.turnᵃ`](@ref)
  - [`DimensionfulAngles.doubleTurnᵃ`](@ref)
  - [`DimensionfulAngles.halfTurnᵃ`](@ref)
  - [`DimensionfulAngles.quadrantᵃ`](@ref)
  - [`DimensionfulAngles.sextantᵃ`](@ref)
  - [`DimensionfulAngles.octantᵃ`](@ref)
  - [`DimensionfulAngles.clockPositionᵃ`](@ref)
  - [`DimensionfulAngles.hourAngleᵃ`](@ref)
  - [`DimensionfulAngles.compassPointᵃ`](@ref)
  - [`DimensionfulAngles.hexacontadeᵃ`](@ref)
  - [`DimensionfulAngles.bradᵃ`](@ref)
  - [`DimensionfulAngles.gradᵃ`](@ref)

The documentation for these are found in [Syntax](@ref units_syntax).

## Astronomical units

In astronomy it is common to measure angles in prefixed arcseconds with the symbol for arcsecond `as`, i.e., milliarcsecond is `mas`.
*DimensionfulAngles.jl* provides this alternate, *prefixable*, version of the arcsecond.

```@docs
DimensionfulAngles.asᵃ
```

The prefixed units are documented in [Prefixed units](@ref units_prefixed).

Another set of units of angle used in astronomy is the hour, minutes, and seconds.
Note that these are minutes and seconds of hour, not degree (e.g., like the arcsecond).
The hour is defined as ``1/24`` of a full revolution.
These are usually displayed as, e.g. `10ʰ 5ᵐ 13.2ˢ` (see [Display](@ref)).

!!! note
    
    minutes/seconds of a degree are distinct from minutes/seconds of an hour.

```@docs
DimensionfulAngles.ʰᵃ
DimensionfulAngles.ᵐᵃ
DimensionfulAngles.ˢᵃ
```

## Display

Most of the time we want to express an angle in a single unit.
However, in some fields it is common to express them in a
[sexagesimal](https://en.wikipedia.org/wiki/Sexagesimal) system.
*Dimensionful.jl* provides the function [`show_sexagesimal`](@ref) to
display an angle in two different sexagesimal systems.
The function [`sexagesimal`](@ref) returns these values rather than displaying them.

```@docs
DimensionfulAngles.sexagesimal
DimensionfulAngles.show_sexagesimal
```

For most units, a space is inserted between the value and the unit, which is the default behavior from *Unitful.jl*.
For the following units, this space is removed (e.g., `10°` not `10 °`):

  - `°`
  - `′`
  - `″`
  - `ʰ`
  - `ᵐ`
  - `ˢ`

## [Syntax](@id units_syntax)

Contents:

  - [Syntax](@ref units_syntax)
    
      + [Prefixed Units](@ref units_prefixed)

```@docs
DimensionfulAngles.arcminuteᵃ
DimensionfulAngles.arcsecondᵃ
DimensionfulAngles.diameterPartᵃ
DimensionfulAngles.turnᵃ
DimensionfulAngles.doubleTurnᵃ
DimensionfulAngles.halfTurnᵃ
DimensionfulAngles.quadrantᵃ
DimensionfulAngles.sextantᵃ
DimensionfulAngles.octantᵃ
DimensionfulAngles.clockPositionᵃ
DimensionfulAngles.hourAngleᵃ
DimensionfulAngles.compassPointᵃ
DimensionfulAngles.hexacontadeᵃ
DimensionfulAngles.bradᵃ
DimensionfulAngles.gradᵃ
```

### [Prefixed units](@id units_prefixed)

```@autodocs
Modules = [DimensionfulAngles]
Filter = x->_filter_prefixed("as", x)
```
