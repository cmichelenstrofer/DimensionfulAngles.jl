# DimensionfulAngles.jl
[![Code Style: Blue](https://img.shields.io/badge/code%20style-blue-4495d1.svg)](https://github.com/invenia/BlueStyle)

Extends [Unitful.jl](https://painterqubits.github.io/Unitful.jl/) to include *angle* as a dimension and allow [dispatching](https://docs.julialang.org/en/v1/manual/methods/) on *angles*.


> **Warning**
> This package is under development and not ready for use. When ready, it will be registered in the [General Registry](https://github.com/JuliaRegistries/General) as `v0.1.0`.

<details><summary><h3>Installation ⚙</h3></summary>
<p>

Install DimensionfulAngles.jl the usual way Julia packages are installed, i.e., using Julia package manager:

```julia
    using Pkg
    Pkg.add("DimensionfulAngles")
```

or in the Pkg REPL (enter from the Julia REPL with `]`):
```julia
    pkg> add("DimensionfulAngles")
```

</p>
</details>

<details><summary><h3>Documentation 📜</h3></summary>
<p>

The full documentation can be found at https://cmichelenstrofer.github.io/DimensionfulAngles/.

</p>
</details>


## Angle as a Dimension?
While *angle* is not an SI base dimension, it can be convenient to treat it as dimension in computer systems.
A few points about base dimensions:

1. The choice of base dimensions a largely a matter of choice.
1. Dimensionless quantities cannot be used in dimensional analysis, such as checking the dimensional consistency of equations.

Point 1 above means it is not "wrong" to use a system with 8 base dimensions with angle as one of them, while point 2 hints at why this might be useful.
In particular point 2 means that we cannot (easily) differentiate between different dimensionless quantities.
In practice this means we have to be very careful when dealing with dimensionless quantities.
Here are some motivating examples using [Unitful.jl](https://painterqubits.github.io/Unitful.jl/)

### Example 1
Trying to add *quantities* with different dimensions results in an error.

```julia
julia> using Unitful

julia> number_of_cats = 5
5

julia> length = 2u"m"
2 m

julia> length + number_of_cats
ERROR: DimensionError: 2 m and 5 are not dimensionally compatible.
[...]
```

However this does not work with dimensionless quantities such as angles.
```julia
julia> angle = 10u"°"
10°

julia> angle + number_of_cats
5.174532925199433
```

What happened here?
First it was recognized that both quantities have the same dimensions (no dimensions in this case) and therefore can be added.
Since the units are different (degrees and no units) they both need to be converted to the base unit (`1`), which in the case of the angle means converting it to radians.
Finally they can be added.

Since angle is not a dimension we cannot differentiate between dimensionless of units of angle and other dimensionless units, which lead to problems like this:

```julia
julia> 1u"°" + 1u"rad"
1.0174532925199433
```
where the results has no units (converted to units of `1`).

### Example 2
[Angular frequency](https://en.wikipedia.org/wiki/Angular_frequency) is a common way to describe the frequency of a periodic response.
It is a measure of rotational rate (i.e. of the phase angle of the periodic waveform) and has units of angle over units of time (e.g. $rad/s = 1/s$).
The frequency on the other hand is defined as one over the period and units of 1 over time (e.g. $Hz = 1/s$).
These are essentially the same units for two physically different quantities.
And although they are physically different quantities they are used in practice to describe the same thing: how fast is the response repeating (which can also be described with yet a third physically distinct quantity: the period in units of time).
The fact that frequency and angular frequency have the same units and are used to describe the same thing is often the source of many embarrassing mistakes.

We might naively try to convert between these as though it were merely a unit-conversion:

```julia
julia> using Unitful

julia> uconvert(u"rad/s", 1u"Hz")
1 rad s⁻¹
```

which results in the wrong answer (the equivalent angular frequency is $2π~rad$) and no error message.

### Example 3
One of the main features of Julia is multiple dispatch.
*Unitful.jl* allows you to dispatch on dimensions, defining functions that can take quantities with any units of the dispatched dimension.
This ability can be used for angular dimensions, and we have to either dispatch on *no dimension* or dispatch on an union of all angle units.
The former would work for all dimensionless quantities not just angles, and the latter can become cumbersome with a large number of units when considering prefixes and additional units in [UnitfulAngles.jl](https://github.com/yakir12/UnitfulAngles.jl).

```julia
julia> using Unitful

julia> what_am_i(::Unitful.Length) = "I am a length."
what_am_i (generic function with 1 method)

julia> what_am_i(::Unitful.Time) = "I am a time."
what_am_i (generic function with 2 methods)

what_am_i(::DimensionlessQuantity) = "I am an angle?"
what_am_i (generic function with 3 methods)

julia> my_height = 6u"ft" + 1.0u"inch"
1.8542 m

julia> angle = 1.2u"rad"
1.2 rad

julia> percent = 12u"percent"
12 %

julia> what_am_i(my_height)
"I am a length."

julia> what_am_i(angle)
"I am an angle?"

julia> what_am_i(percent)
"I am an angle?"
```

### Takeaways

While the choice to use the SI dimensions in Unitful is the right one, for use cases that deal extensively with a dimensionless quantity, it can be extremely useful to extend the base dimensions to include that quantity.
This package extends it to use *angles* as a dimension.


## Basic Usage
Use *DimensionfulAngles.jl* for units containing angles and *Unitful.jl* for all other units.
The units in *DimensionfulAngles.jl* are differentiated from their dimensionless counterparts with a subscript `ᵃ`.
Simply add this subscript to any angle units to make it dimensionful.

```julia
julia> using Unitful

julia> using DimensionfulAngles

julia> dimensionless_angle = 1u"rad"

1 rad

julia> dimensionful_angle = 1u"radᵃ"
1 rad

julia> typeof(dimensionless_angle)
Quantity{Int64, NoDims, Unitful.FreeUnits{(rad,), NoDims, nothing}}

julia> typeof(dimensionful_angle)
Quantity{Int64, 𝐀, Unitful.FreeUnits{(rad,), 𝐀, nothing}}
```

When defining quantities with units from *DimensionfulAngles.jl* you can use the `ua` string instead and omit the subscript `ᵃ`.
But when defining quantities with units from both it is more convenient to use the `u` string.

```julia
julia> dimensionful_angle = 1ua"rad"
1 rad

julia> typeof(dimensionful_angle)
Quantity{Int64, 𝐀, Unitful.FreeUnits{(rad,), 𝐀, nothing}}

julia> angular_velocity = 1.2u"radᵃ/s"
1.2 rad s⁻¹

julia> typeof(angular_velocity)
Quantity{Float64, 𝐀 𝐓⁻¹, Unitful.FreeUnits{(rad, s⁻¹), 𝐀 𝐓⁻¹, nothing}}
```

#### Other Examples
(same as bove but with DimensionfulAngles)

## Contributing
Contributions are welcome! 🎊 Please see the [contribution guidelines](https://github.com/cmichelenstrofer/.github/blob/cf2b03ed168df77a60c596d2d1a98192dded00fb/CONTRIBUTING.md) for ways to contribute to the project.

## Acknowledgments
- Some portions of this software are adapted from:
  - [UnitfulAngles.jl](https://github.com/yakir12/UnitfulAngles.jl/blob/master/LICENSE.md): Copyright (c) 2017: Yakir Luc Gagnon.
  - [UnitfulUS.jl](https://github.com/PainterQubits/UnitfulUS.jl/blob/master/LICENSE.md): Copyright (c) 2017, California Institute of Technology. All rights reserved.
- The name *DimensionfulAngles* was suggested by [@sostock](https://github.com/sostock).
- This is an open source project. Thanks to [all who have contributed](https://github.com/cmichelenstrofer/DimensionfulAngles.jl/contributors)! 🎊🎊🎊

<a href="https://github.com/cmichelenstrofer/DimensionfulAngles.jl/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=cmichelenstrofer/DimensionfulAngles.jl" />
</a>

<sub>*Made with [contrib.rocks](https://contrib.rocks).*</sub>
