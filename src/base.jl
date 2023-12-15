# Extend functions in Base to accept Angles.

# Remove units.
__normalize(x::Angle) = (float(x) / θ₀) |> NoUnits
__normalize_d(x::Angle) = ustrip(float(x) |> °ᵃ)
__normalize_pi(x::Angle) = ustrip(float(x) |> halfTurnᵃ)
# __normalize_2pi(x::Angle) = ustrip(float(x) |> turnᵃ)

# trigonometric
for __f in (:sin, :cos, :tan, :cot, :sec, :csc, :cis, :sincos)
    @eval Base.$__f(x::Angle) = $__f(__normalize(x))
    @eval Base.$__f(x::AbstractMatrix{<: Angle}) = $__f(__normalize.(x))
end

# Better implementation of some trig functions using *pi version.
# For units with exact conversion to π only.
for __u in (°ᵃ, arcminuteᵃ, arcsecondᵃ, asᵃ, doubleTurnᵃ, turnᵃ, halfTurnᵃ, quadrantᵃ,
            sextantᵃ, octantᵃ, clockPositionᵃ, hourAngleᵃ, compassPointᵃ, hexacontadeᵃ,
            bradᵃ, gradᵃ, ʰᵃ, ᵐᵃ, ˢᵃ)
    __A = Quantity{T, 𝐀, typeof(__u)} where {T}
    Base.sin(x::__A) = sinpi(__normalize_pi(x))
    Base.cos(x::__A) = cospi(__normalize_pi(x))
    Base.cis(x::__A) = cispi(__normalize_pi(x))
    Base.sincos(x::__A) = sincospi(__normalize_pi(x))
end

# define *pi functions for `HalfTurn`
for __f in (:sinpi, :cospi, :cispi, :sincospi)
    @eval function Base.$__f(::Angle)
        throw(ArgumentError("argument must be in units of half-turn (π)"))
    end
    __A = Quantity{T, 𝐀, typeof(halfTurnᵃ)} where {T}
    @eval Base.$__f(x::$__A) = $__f(__normalize_pi(x))
end

# define *d functions for `°`
for __f in (:sind, :cosd, :tand, :cotd, :secd, :cscd, :sincosd)
    @eval Base.$__f(::Angle) = throw(ArgumentError("argument must be in degrees"))
    @eval Base.$__f(x::Quantity{T, 𝐀, typeof(°ᵃ)} where {T}) = $__f(__normalize_d(x))
end
for __f in (:sind, :cosd, :tand)
    @eval function Base.$__f(::AbstractMatrix{Angle})
        throw(ArgumentError("argument must be in degrees"))
    end
    __M = AbstractMatrix{<:Quantity{T, 𝐀, typeof(°ᵃ)} where {T}}
    @eval Base.$__f(x::$__M) = $__f(__normalize_d.(x))
end

# hyperbolic
for __f in (:sinh, :cosh, :tanh, :coth, :sech, :csch)
    @eval Base.$__f(x::Angle) = $__f(__normalize(x))
    @eval Base.$__f(x::AbstractMatrix{<:Angle}) = $__f(__normalize.(x))
end

#
Base.sinc(x::Angle) = sinc(__normalize(x))
Base.cosc(x::Angle) = cosc(__normalize(x))

# exponential (imaginary argument)
function call_if_imag(f::Function, x::Angle)
    ustrip(real(x)) ≉ 0 && throw(DomainError(x, "argument must be imaginary"))
    return f(__normalize(x))
end
function call_if_imag(f::Function, x::AbstractMatrix{<:Angle})
    all(ustrip(real(x)) .≉ 0) && throw(DomainError(x, "argument must be imaginary"))
    return f(__normalize.(x))
end
Base.exp(::Angle) = throw(ArgumentError("argument must be complex"))
Base.exp(x::Angle{T, U} where {T <: Complex} where {U}) = call_if_imag(exp, x)
Base.exp(x::AbstractMatrix{<: Angle{T, U} where {T <: Complex} where U}) = call_if_imag(exp, x)
Base.expm1(::Angle) = throw(ArgumentError("argument must be complex"))
Base.expm1(x::Angle{T, U} where {T <: Complex} where {U}) = call_if_imag(expm1, x)

# inverse trigonometric
for __f in (:asin, :acos, :atan, :acot, :asec, :acsc)
    @eval Base.$__f(u::AngleUnits, x::Number) = uconvert(u, $__f(x) * radᵃ)
    @eval Base.$__f(u::AngleUnits, x::AbstractMatrix) = uconvert.(u, $__f(x) * radᵃ)
end
Base.atan(u::AngleUnits, y::Number, x::Number) = uconvert(u, atan(y, x) * radᵃ)

# inverse hyperbolic
for __f in (:asinh, :acosh, :atanh, :acoth, :asech, :acsch)
    @eval Base.$__f(u::AngleUnits, x::Number) = uconvert(u, $__f(x) * radᵃ)
    @eval Base.$__f(u::AngleUnits, x::AbstractMatrix) = uconvert.(u, $__f(x) * radᵃ)
end

# logarithmic
Base.log(u::AngleUnits, x::Number) = uconvert(u, log(x) * radᵃ)
Base.log(u::AngleUnits, x::AbstractMatrix) = uconvert.(u, log(x) * radᵃ)
Base.log1p(u::AngleUnits, x::Number) = uconvert(u, log1p(x) * radᵃ)

# Phase angle of complex number.
Base.angle(u::AngleUnits, x::Number) = uconvert(u, angle(x) * radᵃ)

# conversions
Base.deg2rad(::Angle) = throw(ArgumentError("argument must be in degrees"))
Base.deg2rad(x::Quantity{T, 𝐀, typeof(°ᵃ)}) where {T} = deg2rad(ustrip(°ᵃ, x))radᵃ
Base.rad2deg(::Angle) = throw(ArgumentError("argument must be in radians"))
Base.rad2deg(x::Quantity{T, 𝐀, typeof(radᵃ)}) where {T} = rad2deg(ustrip(radᵃ, x))°ᵃ

# divisions
Base.mod2pi(x::Angle) = mod2pi(__normalize(x)) * radᵃ |> unit(x)
Base.rem2pi(x::Angle, r) = rem2pi(__normalize(x), r) * radᵃ |> unit(x)
