# Extend functions in Base to accept Angles.

# Functions of (dimensionless) angle in Base.
const __FUNCTIONS = (
    # Trigonometric
    :sin,
    :cos,
    :tan,
    :cot,
    :sec,
    :csc,
    :sincos,
    # Hyperbolic
    :sinh,
    :cosh,
    :tanh,
    :coth,
    :sech,
    :csch,
    # Exponential
    :exp,
    :expm1,
    :cis,
    # Sinc
    :sinc,
    :cosc,
)

# Functions returning (dimensionless) angle in Base.
const __INVERSES = (
    # Trigonometric
    :asin,
    :acos,
    :atan,
    :acot,
    :asec,
    :acsc,
    # Hyperbolic
    :asinh,
    :acosh,
    :atanh,
    :acoth,
    :asech,
    :acsch,
    # Logarithmic
    :log,
    :log1p,
    # Phase angle of complex number.
    :angle,
)

# Functions with a *pi version.
const __PI_VER = (:sin, :cos, :sincos, :cis)

# Functions with a *d version.
const __DEG_VER = (:sin, :cos, :tan, :cot, :sec, :csc, :sincos)
const __DEG_VER_INV = (:asin, :acos, :atan, :acot, :asec, :acsc)

# Angle units with exact conversions to π rad (halfTurn).
const __UNITS_PI = (
    doubleTurnᵃ,
    turnᵃ,
    halfTurnᵃ,
    quadrantᵃ,
    sextantᵃ,
    octantᵃ,
    clockPositionᵃ,
    hourAngleᵃ,
    compassPointᵃ,
    hexacontadeᵃ,
    bradᵃ,
    gradᵃ,
    ʰᵃ,
    ᵐᵃ,
    ˢᵃ,
)

# Angle units with exact conversions to degrees ° but not to π rad.
const __UNITS_DEG = (°ᵃ, arcminuteᵃ, arcsecondᵃ, asᵃ)

# Remove units.
__normalize(x::Angle) = (float(x) / θ₀) |> NoUnits
__normalize_deg(x::Angle) = ustrip(float(x) |> °ᵃ)
__normalize_pi(x::Angle) = ustrip(float(x) |> halfTurnᵃ)

# Extend functions of angles in Base.
for __f in __FUNCTIONS
    @eval Base.$__f(x::Angle) = $__f(__normalize(x))
    @eval Base.$__f(x::AbstractMatrix{Angle}) = $__f(__normalize.(x))
end

# Better implementation when using degrees, using the *d version of functions.
for __f in __DEG_VER, __u in __UNITS_DEG
    __fd = Symbol("$(__f)d")
    __Q = @eval Quantity{T, 𝐀, typeof($__u)} where {T}
    @eval global Base.$__f(x::$__Q) = $__fd(__normalize_deg(x))
    @eval global Base.$__fd(x::$__Q) = $__fd(__normalize_deg(x))
    @eval global Base.$__f(x::AbstractMatrix{$__Q}) = $__fd(__normalize_deg.(x))
    @eval global Base.$__fd(x::AbstractMatrix{$__Q}) = $__fd(__normalize_deg.(x))
end

# Better implementation when using π, using the *pi version of functions.
for __f in __PI_VER, __u in __UNITS_PI
    __fp = Symbol("$(__f)pi")
    __Q = @eval Quantity{T, 𝐀, typeof($__u)} where {T}
    @eval global Base.$__f(x::$__Q) = $__fp(__normalize_pi(x))
    @eval global Base.$__fp(x::$__Q) = $__fp(__normalize_pi(x))
    @eval global Base.$__f(x::AbstractMatrix{$__Q}) = $__fp(__normalize_pi.(x))
    @eval global Base.$__fp(x::AbstractMatrix{$__Q}) = $__fp(__normalize_pi.(x))
end

# Functions with units of angle in output (inverse functions).
for __f in __INVERSES
    @eval Base.$__f(u::AngleUnits, x::Number) = uconvert(u, $__f(x) * radᵃ)
    @eval Base.$__f(u::AngleUnits, x::AbstractMatrix) = uconvert.(u, $__f(x) * radᵃ)
end

for __f in __DEG_VER_INV
    __fd = Symbol("$(__f)d")
    @eval Base.$__fd(u::AngleUnits, x::Number) = uconvert(u, $__fd(x) * °ᵃ)
    @eval Base.$__fd(u::AngleUnits, x::AbstractMatrix) = uconvert.(u, $__fd(x) * °ᵃ)
end

Base.atan(u::AngleUnits, y::Number, x::Number) = uconvert(u, atan(y, x) * radᵃ)
Base.atand(u::AngleUnits, y::Number, x::Number) = uconvert(u, atand(y, x) * °ᵃ)

# Conversions
Base.deg2rad(x::Quantity{T, 𝐀, typeof(°ᵃ)}) where {T} = deg2rad(ustrip(°ᵃ, x))radᵃ
Base.rad2deg(x::Quantity{T, 𝐀, typeof(radᵃ)}) where {T} = rad2deg(ustrip(radᵃ, x))°ᵃ

# Division/remainder
Base.mod2pi(x::Angle) = mod2pi(__normalize(x)) * radᵃ |> unit(x)
Base.rem2pi(x::Angle, r) = rem2pi(__normalize(x), r) * radᵃ |> unit(x)
