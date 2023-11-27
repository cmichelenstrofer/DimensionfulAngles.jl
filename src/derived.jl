# Units and functionalities for derived dimensions of Angle.

# Solid angle
@derived_dimension SolidAngle (𝐀*𝐀) true

"""
    srᵃ

The steradian, a unit of spherical angle.

There are 4π sr in a sphere.
The steradian is the SI unit of solid angle.
Unlike `Unitful.sr`, which follows SI and is therefor dimensionless,
`srᵃ` has dimensions of Angle squared.
Accepts SI prefixes.

Dimension: `𝐀²`."
"""
@unit srᵃ "sr" Steradianᵃ (1radᵃ*radᵃ) true true

# Angular velocity, angular acceleration, and angular frequency.
@derived_dimension AngularVelocity (𝐀*𝐓^-1) true
@derived_dimension AngularAcceleration (𝐀*𝐓^-2) true

"""
    rpsᵃ

Revolutions per second, a unit of angular velocity defined as 2π rad / s.

This differs from `Unitful.rps` in that it contains units of angle.
Does not accepts SI prefixes.

Dimension: 𝐀 𝐓⁻¹.

See also [`DimensionfulAngles.radᵃ`](@ref).
"""
@unit rpsᵃ "rps" RevolutionsPerSecondᵃ (1turnᵃ/s) false

"""
    rpmᵃ

Revolutions per minute, a unit of angular velocity defined as 2π rad / minute.

This differs from `Unitful.rpm` in that it contains units of angle.
Does not accepts SI prefixes.

Dimension: 𝐀 𝐓⁻¹.

See also [`DimensionfulAngles.radᵃ`](@ref).
"""
@unit rpmᵃ "rpm" RevolutionsPerMinuteᵃ (1turnᵃ/minute) false

# Angular wavenumber, angular wavelength, angular period
@derived_dimension AngularWavenumber (𝐀*𝐋^-1) true
@derived_dimension AngularWavelength (𝐋*𝐀^-1) true
@derived_dimension AngularPeriod (𝐓*𝐀^-1) true

# periodic equivalence for both temporal and spatial frequency
"""
    Periodic()

Equivalence to convert between period, frequency, and
[angular frequency](https://en.wikipedia.org/wiki/Angular_frequency)
according to the relation ``f = ω/2π = 1/T``, where

  - ``f`` is the frequency,
  - ``ω`` is the angular speed and
  - ``T`` is the period.

# Example

```jldoctest
julia> using Unitful

julia> using DimensionfulAngles

julia> uconvert(u"s", 10u"Hz", Periodic())
0.1 s

julia> uconvert(u"radᵃ/s", 1u"Hz", Periodic())
6.283185307179586 rad s⁻¹
```
"""
struct Periodic <: Equivalence end
# temporal
@eqrelation Periodic (AngularVelocity / Frequency = 2π * radᵃ)
@eqrelation Periodic (Frequency * Time = 1)
@eqrelation Periodic (AngularVelocity * Time = 2π * radᵃ)
@eqrelation Periodic (AngularVelocity * AngularPeriod = 1)
@eqrelation Periodic (Time / AngularPeriod = 2π * radᵃ)
@eqrelation Periodic (AngularPeriod * Frequency = 1/(2π * radᵃ))
# spatial
@eqrelation Periodic (AngularWavenumber / Wavenumber = 2π * radᵃ)
@eqrelation Periodic (Wavenumber * Length = 1)
@eqrelation Periodic (AngularWavenumber * Length = 2π * radᵃ)
@eqrelation Periodic (AngularWavenumber * AngularWavelength = 1)
@eqrelation Periodic (Length / AngularWavelength = 2π * radᵃ)
@eqrelation Periodic (AngularWavelength * Wavenumber = 1/(2π * radᵃ))
# default to `uconvert` behavior, temporal
@eqrelation Periodic (Frequency / Frequency = 1)
@eqrelation Periodic (Time / Time = 1)
@eqrelation Periodic (AngularVelocity / AngularVelocity = 1)
@eqrelation Periodic (AngularPeriod / AngularPeriod = 1)
# default to `uconvert` behavior, spatial
@eqrelation Periodic (Wavenumber / Wavenumber = 1)
@eqrelation Periodic (Length / Length = 1)
@eqrelation Periodic (AngularWavenumber / AngularWavenumber = 1)
@eqrelation Periodic (AngularWavelength / AngularWavelength = 1)
