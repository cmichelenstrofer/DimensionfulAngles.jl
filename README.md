# DimensionfulAngles.jl
[![Code Style: Blue](https://img.shields.io/badge/code%20style-blue-4495d1.svg)](https://github.com/invenia/BlueStyle)
[![](https://img.shields.io/badge/docs-stable-blue.svg)](https://cmichelenstrofer.github.io/DimensionfulAngles.jl/stable)
[![](https://img.shields.io/badge/docs-dev-blue.svg)](https://cmichelenstrofer.github.io/DimensionfulAngles.jl/dev)

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

A third alternative is to directly import only the units you will be using and renaming those from *DimensionfulAngles.jl* to remove the superscript `ᵃ`.

```julia
julia> using Unitful

julia> using Unitful: m, s, kg

julia> using DimensionfulAngles: radᵃ as rad, °ᵃ as °

julia> angular_velocity = 1.2rad/s
1.2 rad s⁻¹
```

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
