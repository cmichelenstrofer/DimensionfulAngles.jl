# Extend functions in Base to accept Angles.

# functions of (dimensionless) angle in Base
const functions = (
    :sin, :cos, :tan, :cot, :sec, :csc, :sincos, # trigonometric
    :sinh, :cosh, :tanh, :coth, :sech, :csch,    # hyperbolic
    :exp, :expm1, :cis,                          # exponential
    :sinc, :cosc                                 # sinc
)

# functions returning (dimensionless) angle in Base
const inverses = (
    :asin, :acos, :atan, :acot, :asec, :acsc,       # trigonometric
    :asinh, :acosh, :atanh, :acoth, :asech, :acsch, # hyperbolic
    :log, :log1p,                                   # exponential
    :angle,                                         # phase angle of complex number
)

# functions with a *pi version
const pi_ver = (:sin, :cos, :sincos, :cis)

# functions with a *d version
const deg_ver = (:sin, :cos, :tan, :cot, :sec, :csc, :sincos)
const deg_ver_inv = (:asin, :acos, :atan, :acot, :asec, :acsc)

# angle units with exact conversions to π rad (halfTurn)
const units_pi = (
    doubleTurnᵃ, turnᵃ, halfTurnᵃ, quadrantᵃ, sextantᵃ, octantᵃ, clockPositionᵃ, hourAngleᵃ,
    compassPointᵃ, hexacontadeᵃ, bradᵃ, gradᵃ, ʰᵃ, ᵐᵃ, ˢᵃ,
)

# angle units with exact conversions to degrees °
const units_deg = (°ᵃ, arcminuteᵃ, arcsecondᵃ, asᵃ)

# remove units
_normalize(x::Angle) = (float(x) / θ₀) |> NoUnits
_normalize_deg(x::Angle) = ustrip(float(x) |> °ᵃ)
_normalize_pi(x::Angle) = ustrip(float(x) |> halfTurnᵃ)

# extend functions of angles in Base
for _f in functions
    @eval Base.$_f(x::Angle) = $_f(_normalize(x))
    @eval Base.$_f(x::Matrix{T}) where {T <: Angle} = $_f(_normalize.(x))
end

# better implementation when using degrees, using the *d version of functions
for _f in deg_ver, _u in units_deg
    _fd = Symbol("$(_f)d")
    _Q = @eval Quantity{T, 𝐀, typeof($_u)} where {T}
    @eval Base.$_f(x::$_Q) = $_fd(_normalize_deg(x))
    @eval Base.$_fd(x::$_Q) = $_fd(_normalize_deg(x))
    @eval Base.$_f(x::Matrix{$_Q}) = $_fd(_normalize_deg.(x))
    @eval Base.$_fd(x::Matrix{$_Q}) = $_fd(_normalize_deg.(x))
end

# better implementation when using π, using the *pi version of functions
for _f in pi_ver, _u in units_pi
    _fp = Symbol("$(_f)pi")
    _Q = @eval Quantity{T, 𝐀, typeof($_u)} where {T}
    @eval Base.$_f(x::$_Q) = $_fp(_normalize_pi(x))
    @eval Base.$_fp(x::$_Q) = $_fp(_normalize_pi(x))
    @eval Base.$_f(x::Matrix{$_Q}) = $_fp(_normalize_pi.(x))
    @eval Base.$_fp(x::Matrix{$_Q}) = $_fp(_normalize_pi.(x))
end

# functions with units of angle in output
const _U = Units{T, 𝐀} where {T}
const _M = AbstractMatrix{N} where {N <: Number}
for _f in inverses
    @eval Base.$_f(u::_U, x::Number) = uconvert(u, $_f(x) * radᵃ)
    @eval Base.$_f(u::_U, x::_M) = uconvert.(u, $_f(x) * radᵃ)
end
Base.atan(u::_U, y::Number, x::Number) = uconvert(u, atan(y, x) * radᵃ)

# utilities
Base.deg2rad(d::Quantity{T, 𝐀, typeof(°ᵃ)}) where {T} = deg2rad(ustrip(°ᵃ, d))radᵃ
Base.rad2deg(r::Quantity{T, 𝐀, typeof(radᵃ)}) where {T} = rad2deg(ustrip(radᵃ, r))°ᵃ
Base.mod2pi(x::Angle) = mod2pi(_normalize(x))*radᵃ |> unit(x)
Base.rem2pi(x::Angle, r) = rem2pi(_normalize(x), r)*radᵃ |> unit(x)
