# Units and functionalities for derived dimensions of Angle

# solid angle
@derived_dimension SolidAngle (𝐀 * 𝐀) true

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
@unit srᵃ "sr" Steradianᵃ (1radᵃ * radᵃ) true true

# angular velocity & acceleration, and relation to angular frequency
@derived_dimension AngularVelocity (𝐀 * 𝐓^-1) true
@derived_dimension AngularAcceleration (𝐀 * 𝐓^-2) true

"""
    rpsᵃ

Revolutions per second, a unit of angular velocity defined as 2π rad / s.

This differs from `Unitful.rps` in that it contains units of angle.
Does not accepts SI prefixes.

Dimension: 𝐀 𝐓⁻¹.

See also [`DimensionfulAngles.radᵃ`](@ref).
"""
@unit rpsᵃ "rps" RevolutionsPerSecondᵃ (1turnᵃ / s) false

"""
    rpmᵃ

Revolutions per minute, a unit of angular velocity defined as 2π rad / minute.

This differs from `Unitful.rpm` in that it contains units of angle.
Does not accepts SI prefixes.

Dimension: 𝐀 𝐓⁻¹.

See also [`DimensionfulAngles.radᵃ`](@ref).
"""
@unit rpmᵃ "rps" RevolutionsPerMinuteᵃ (1turnᵃ / minute) false

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

julia> using Unitful: s, Hz

julia> using DimensionfulAngles: radᵃ as rad, Periodic

julia> uconvert(s, 10Hz, Periodic())
0.1 s

julia> uconvert(rad/s, 1Hz, Periodic())
6.283185307179586 rad s⁻¹
```
"""
struct Periodic <: Equivalence end
@eqrelation Periodic (AngularVelocity / Frequency = 2π * radᵃ)
@eqrelation Periodic (Frequency * Time = 1)
@eqrelation Periodic (AngularVelocity * Time = 2π * radᵃ)
