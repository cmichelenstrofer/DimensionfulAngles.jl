# String macro for creating units with angle dimension.
#
# Adapted from UnitfulUS.jl/src/usmacro.jl
# Copyright (c) 2017, California Institute of Technology. All rights reserved.

"""
    macro ua_str(unit)

String macro to easily recall units with angular dimension located in the
`DimensionfulAngles` package. Although all unit symbols in that package are suffixed
with `ᵃ`, the suffix should not be used when using this macro.

Note that what goes inside must be parsable as a valid Julia expression.

# Examples

```jldoctest; filter = r"(d*).(d{10})d+" => s"\1.\2"
julia> using DimensionfulAngles

julia> 1.0ua"turn"
1.0 τ

julia> 1.0ua"rad" - 1.0ua"°"
0.9825467074800567 rad
```
"""
macro ua_str(unit)
    ex = Meta.parse(unit)
    return esc(__replace_value(ex))
end

function __replace_value(ex::Expr)
    ex.head in [:call, :tuple] || error("Expr head $(ex.head) must equal :call or :tuple")
    if ex.head == :call
        allowed_funcs = [:*, :/, :^, :sqrt, :√, :+, :-, ://]
        if !(ex.args[1] in allowed_funcs)
            error("$(ex.args[1]) is not a valid function call when parsing a unit." *
                  "Only the following functions are allowed: $allowed_funcs.")
        end

        for i in 2:length(ex.args)
            if typeof(ex.args[i]) == Symbol || typeof(ex.args[i]) == Expr
                ex.args[i] = __replace_value(ex.args[i])
            end
        end
    elseif ex.head == :tuple
        for i in 1:length(ex.args)
            typeof(ex.args[i]) == Symbol || error("only use symbols inside the tuple.")
            ex.args[i] = __replace_value(ex.args[i])
        end
    end

    return Core.eval(@__MODULE__, ex)
end

function __replace_value(sym::Symbol)
    s = Symbol(sym, :ᵃ)
    ustrcheck = __ustrcheck_bool(getfield(DimensionfulAngles, s))
    if !(ustrcheck && isdefined(DimensionfulAngles, s))
        error("Symbol $s could not be found in DimensionfulAngles.")
    end

    return getfield(DimensionfulAngles, s)
end

__replace_value(literal::Number) = literal

__ustrcheck_bool(x) = false
__ustrcheck_bool(x::Number) = true
__ustrcheck_bool(x::Unitlike) = true
__ustrcheck_bool(x::Quantity) = true
__ustrcheck_bool(x::MixedUnits) = true
