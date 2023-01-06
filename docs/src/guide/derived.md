# Derived dimensions

*DimensionfulAngles.jl* also defines derived dimensions that include angle.
These are:

  - [`DimensionfulAngles.SolidAngle`](@ref)
  - [`DimensionfulAngles.AngularVelocity`](@ref)
  - [`DimensionfulAngles.AngularAcceleration`](@ref).

This allows, among other things, dispatching on these derived dimensions.

Several units are defined for these derived dimensions, including the steradian for solid angle and RPM for angular velocity.

*DimensionfulAngles.jl* also provides [`Periodic`](@ref) a [UnitfulEquivalences.jl](https://sostock.github.io/UnitfulEquivalences.jl/stable/) `Equivalence` to convert between period, frequency, and angular frequency of a periodic response.

## Solid Angle

[Solid angle](https://en.wikipedia.org/wiki/Solid_angle) is a two-dimensional angle subtended at a point.
In the SI system it has units of ``m²/m²=1`` and is non-dimensional.
Here, following several proposed systems, it has dimensions of angle squared, `𝐀²`.
See [Relation to proposed SI extensions](@ref).
The SI unit of solid angle is the steradian, which here is defined as ``sr=rad²``.
The steradian takes SI prefixes and therefore defines many other units (e.g., the millisteradian `DimensionfulAngles.msrᵃ`).
These are documented in [Prefixed units](@ref derived_prefixed).

```@docs
DimensionfulAngles.SolidAngle
DimensionfulAngles.srᵃ
```

## Angular velocity and acceleration

Content:

  - [Angular velocity and acceleration](@ref)
    
      + [Periodic equivalence](@ref)

[Angular velocity](https://en.wikipedia.org/wiki/Angular_frequency) has dimensions of angle over time `𝐀/𝐓` and can be used to measure different quantities such as rotational velocity, rotational speed, and angular frequency of a phase angle.
Two units of angular velocity are defined: the revolutions per second (RPS) and the revolutions per minute (RPM), provided as [`DimensionfulAngles.rpsᵃ`](@ref) and [`DimensionfulAngles.rpmᵃ`](@ref) respectively.

[Angular acceleration](https://en.wikipedia.org/wiki/Angular_acceleration) is the time rate of change of angular velocity and has dimensions of angle over time squared `𝐀/𝐓²`.
No units are defined specifically for this derived dimension.

```@docs
DimensionfulAngles.AngularVelocity
DimensionfulAngles.AngularAcceleration
DimensionfulAngles.rpsᵃ
DimensionfulAngles.rpmᵃ
```

### Periodic equivalence

For periodic responses there are several analogous ways to measure the repeat period: period `T` (`𝐓`, `s`), frequency `f` (`1/𝐓`, `Hz=1/s`), or angular frequency `ω` (`𝐀/𝐓`, `rad/s`).
These are [related by](https://en.wikipedia.org/wiki/Angular_frequency)

``f = 1/T = ω/2π``.

*DimensionfulAngles.jl* provides [`Periodic`](@ref) a [UnitfulEquivalences.jl](https://sostock.github.io/UnitfulEquivalences.jl/stable/) `Equivalence` to convert between period, frequency, and angular frequency of a periodic response.

```@docs
DimensionfulAngles.Periodic
```

## [Syntax](@id derived_syntax)

Contents:

  - [Syntax](@ref derived_syntax)
    
      + [Syntax provided by *Unitful.jl*](@ref derived_unitful)
      + [Prefixed Units](@ref derived_prefixed)

### [Syntax provided by *Unitful.jl*](@id derived_unitful)

```@docs
DimensionfulAngles.AngularVelocityUnits
DimensionfulAngles.AngularVelocityFreeUnits
DimensionfulAngles.AngularAccelerationUnits
DimensionfulAngles.AngularAccelerationFreeUnits
DimensionfulAngles.SolidAngleUnits
DimensionfulAngles.SolidAngleFreeUnits
```

### [Prefixed Units](@id derived_prefixed)

```@autodocs
Modules = [DimensionfulAngles]
Filter = x->_filter_prefixed("sr", x)
```
