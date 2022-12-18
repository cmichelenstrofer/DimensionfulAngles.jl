# Extend functions in Base to accept Angles.

# Functions of (dimensionless) angle in Base.
const _FUNCTIONS = (
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
const _INVERSES = (
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
const _PI_VER = (:sin, :cos, :sincos, :cis)

# Functions with a *d version.
const _DEG_VER = (:sin, :cos, :tan, :cot, :sec, :csc, :sincos)
const _DEG_VER_INV = (:asin, :acos, :atan, :acot, :asec, :acsc)

# Angle units with exact conversions to π rad (halfTurn).
const _UNITS_PI = (
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
const _UNITS_DEG = (°ᵃ, arcminuteᵃ, arcsecondᵃ, asᵃ)

# Remove units.
_normalize(x::Angle) = (float(x) / θ₀) |> NoUnits
_normalize_deg(x::Angle) = ustrip(float(x) |> °ᵃ)
_normalize_pi(x::Angle) = ustrip(float(x) |> halfTurnᵃ)

# Extend functions of angles in Base.
for _f in _FUNCTIONS
    @eval Base.$_f(x::Angle) = $_f(_normalize(x))
    @eval Base.$_f(x::AbstractMatrix{Angle}) = $_f(_normalize.(x))
end

# Better implementation when using degrees, using the *d version of functions.
for _f in _DEG_VER, _u in _UNITS_DEG
    _fd = Symbol("$(_f)d")
    _Q = @eval Quantity{T, 𝐀, typeof($_u)} where {T}
    @eval global Base.$_f(x::$_Q) = $_fd(_normalize_deg(x))
    @eval global Base.$_fd(x::$_Q) = $_fd(_normalize_deg(x))
    @eval global Base.$_f(x::AbstractMatrix{$_Q}) = $_fd(_normalize_deg.(x))
    @eval global Base.$_fd(x::AbstractMatrix{$_Q}) = $_fd(_normalize_deg.(x))
end

# Better implementation when using π, using the *pi version of functions.
for _f in _PI_VER, _u in _UNITS_PI
    _fp = Symbol("$(_f)pi")
    _Q = @eval Quantity{T, 𝐀, typeof($_u)} where {T}
    @eval global Base.$_f(x::$_Q) = $_fp(_normalize_pi(x))
    @eval global Base.$_fp(x::$_Q) = $_fp(_normalize_pi(x))
    @eval global Base.$_f(x::AbstractMatrix{$_Q}) = $_fp(_normalize_pi.(x))
    @eval global Base.$_fp(x::AbstractMatrix{$_Q}) = $_fp(_normalize_pi.(x))
end

# Functions with units of angle in output (inverse functions).
for _f in _INVERSES
    @eval Base.$_f(u::AngleUnits, x::Number) = uconvert(u, $_f(x) * radᵃ)
    @eval Base.$_f(u::AngleUnits, x::AbstractMatrix) = uconvert.(u, $_f(x) * radᵃ)
end

for _f in _DEG_VER_INV
    _fd = Symbol("$(_f)d")
    @eval Base.$_fd(u::AngleUnits, x::Number) = uconvert(u, $_fd(x) * °ᵃ)
    @eval Base.$_fd(u::AngleUnits, x::AbstractMatrix) = uconvert.(u, $_fd(x) * °ᵃ)
end

Base.atan(u::AngleUnits, y::Number, x::Number) = uconvert(u, atan(y, x) * radᵃ)
Base.atand(u::AngleUnits, y::Number, x::Number) = uconvert(u, atand(y, x) * °ᵃ)

# Conversions
Base.deg2rad(x::Quantity{T, 𝐀, typeof(°ᵃ)}) where {T} = deg2rad(ustrip(°ᵃ, x))radᵃ
Base.rad2deg(x::Quantity{T, 𝐀, typeof(radᵃ)}) where {T} = rad2deg(ustrip(radᵃ, x))°ᵃ

# Division/remainder
Base.mod2pi(x::Angle) = mod2pi(_normalize(x))*radᵃ |> unit(x)
Base.rem2pi(x::Angle, r) = rem2pi(_normalize(x), r)*radᵃ |> unit(x)
