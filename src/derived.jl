# Derived units and dimensions of Angle.

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

# Luminous flux and illuminance
@derived_dimension LuminousFlux (𝐉*𝐀^2) true
@derived_dimension Illuminance (𝐉*𝐀^2*𝐋^-2) true

"""
    lmᵃ

The lumen, an SI unit of luminous flux.

Defined as 1 cd × sr. Accepts SI prefixes.

Dimension: `𝐉𝐀²`."
"""
@unit lmᵃ "lm" Lumenᵃ 1cdᵤ*srᵃ true true

"""
    lxᵃ

The lux, an SI unit of illuminance.

Defined as 1 lm / m^2. Accepts SI prefixes.

Dimension: `𝐉𝐀²𝐋⁻²`."
"""
@unit lxᵃ "lx" Luxᵃ 1lmᵃ/m^2 true true

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
