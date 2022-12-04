# String macro for creating units with angle dimension.
#
# Adapted from UnitfulUS.jl/src/usmacro.jl
# Copyright (c) 2017, California Institute of Technology. All rights reserved.

const allowed_funcs = [:*, :/, :^, :sqrt, :√, :+, :-, ://]

"""
    macro ua_str(unit)

String macro to easily recall units with angular dimension located in the
`UnitfulAngleDimension` package. Although all unit symbols in that package are suffixed
with `ᵃ`, the suffix should not be used when using this macro.

Note that what goes inside must be parsable as a valid Julia expression.

# Examples

```jldoctest
julia> 1.0ua"turn"
1.0 τ

julia> 1.0ua"rad" - 1.0ua"°"
0.9825467074800567 rad
```
"""
macro ua_str(unit)
    ex = Meta.parse(unit)
    return esc(_replace_value(ex))
end

function _replace_value(ex::Expr)
    if ex.head == :call
        ex.args[1] in allowed_funcs ||
            error("""$(ex.args[1]) is not a valid function call when parsing a unit.
             Only the following functions are allowed: $allowed_funcs""")
        for i in 2:length(ex.args)
            if typeof(ex.args[i]) == Symbol || typeof(ex.args[i]) == Expr
                ex.args[i] = _replace_value(ex.args[i])
            end
        end
        return Core.eval(@__MODULE__, ex)
    elseif ex.head == :tuple
        for i in 1:length(ex.args)
            if typeof(ex.args[i]) == Symbol
                ex.args[i] = _replace_value(ex.args[i])
            else
                error("only use symbols inside the tuple.")
            end
        end
        return Core.eval(@__MODULE__, ex)
    else
        error("Expr head $(ex.head) must equal :call or :tuple")
    end
end

function _replace_value(sym::Symbol)
    s = Symbol(sym, :ᵃ)
    ustrcheck = _ustrcheck_bool(getfield(UnitfulAngleDimension, s))
    if !(ustrcheck && isdefined(UnitfulAngleDimension, s))
        error("Symbol $s could not be found in UnitfulAngleDimension.")
    end
    return getfield(UnitfulAngleDimension, s)
end

_replace_value(literal::Number) = literal

_ustrcheck_bool(x) = false
_ustrcheck_bool(x::Number) = true
_ustrcheck_bool(x::Unitlike) = true
_ustrcheck_bool(x::Quantity) = true
_ustrcheck_bool(x::MixedUnits) = true
