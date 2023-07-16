[![Project Status: Active – The project has reached a stable, usable state and is being actively developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)
[![CI](https://github.com/cmichelenstrofer/DimensionfulAngles.jl/actions/workflows/CI.yml/badge.svg)](https://github.com/cmichelenstrofer/DimensionfulAngles.jl/actions/workflows/CI.yml)
[![codecov](https://codecov.io/gh/cmichelenstrofer/DimensionfulAngles.jl/branch/main/graph/badge.svg?token=QI8L8PQ71T)](https://codecov.io/gh/cmichelenstrofer/DimensionfulAngles.jl)
[![deps](https://juliahub.com/docs/DimensionfulAngles/deps.svg)](https://juliahub.com/ui/Packages/DimensionfulAngles/Km6m8?page=2)
[![dependencies](https://img.shields.io/badge/dependencies-2-blue)](https://juliahub.com/ui/Packages/DimensionfulAngles/Km6m8?page=1)

# DimensionfulAngles.jl
Extends [Unitful.jl](https://painterqubits.github.io/Unitful.jl/) to include *angle* as a dimension and allow [dispatching](https://docs.julialang.org/en/v1/manual/methods/) on *angles*.

<details><summary><h3>Installation ⚙</h3></summary>
<p>
Install DimensionfulAngles.jl the usual way Julia packages are installed, i.e., using Julia package manager:

```julia
using Pkg
Pkg.add("DimensionfulAngles")
```

or in the Pkg REPL (enter from the Julia REPL with `]`):

```julia
pkg> add DimensionfulAngles
```
</p>
</details>

<details><summary><h3>Documentation 📜</h3></summary>
<a href="https://cmichelenstrofer.github.io/DimensionfulAngles.jl/stable"><img src="https://img.shields.io/badge/docs-stable-blue.svg" alt="Documentation of latest stable release."/></a>
<a href="https://cmichelenstrofer.github.io/DimensionfulAngles.jl/dev"><img src="https://img.shields.io/badge/docs-dev-blue.svg" alt="Documentation for the current code status in the <em>main</em> branch."/></a>
<p>
The full documentation can be found at https://cmichelenstrofer.github.io/DimensionfulAngles.jl.
</p>
</details>

<details><summary><h3>Citing 📝</h3></summary>
<a href="https://zenodo.org/badge/latestdoi/488031226"><img src="https://zenodo.org/badge/488031226.svg" alt="DOI of latest version"/></a>

<p>
If you use this code for your research please consider citing:
</p>

<blockquote>
Michelén Ströfer, C. A. (2022). DimensionfulAngles.jl (Version 0.1.0) [Computer software]. https://github.com/cmichelenstrofer/DimensionfulAngles.jl
</blockquote>

<p>BibTeX:
<pre class="line-numbers">
<code class="language-latex">
@software{Michelen_Strofer_DimensionfulAngles_jl_2022,
  author = {Michelén Ströfer, Carlos Alejandro},
  doi = {10.5281/zenodo.7500588},
  month = {12},
  title = {{DimensionfulAngles.jl}},
  url = {https://github.com/cmichelenstrofer/DimensionfulAngles.jl},
  version = {0.1.0},
  year = {2022}
}
</code>
</pre>
</details>

## Basic Usage

Use *DimensionfulAngles.jl* for units containing angles and *Unitful.jl* for all other units.
The units in *DimensionfulAngles.jl* are differentiated from their dimensionless counterparts with a superscript `ᵃ`.
Simply add this superscript to any angle units to make it dimensionful. 
In Julia environments this can be typed as `\^a<tab>`.

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

When defining quantities with units from *DimensionfulAngles.jl* you can use the `ua` string instead and omit the superscript `ᵃ`.
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

julia> angular_velocity = 1.2rad / s
1.2 rad s⁻¹
```

### Default Symbols
Another way of doing this is to  import all default units, which includes SI base and derived units from `Unitful.jl` with angle units from `DimensionfulAngles.jl`.
This is done as

```julia
julia> using DimensionfulAngles.DefaultSymbols

julia> angular_velocity = 1.2rad / s
```

## Contributing
<!-- 
[![Contributor Covenant](https://img.shields.io/badge/Contributor%20Covenant-2.1-4baaaa.svg)](code_of_conduct.md)
[![ColPrac: Contributor's Guide on Collaborative Practices for Community Packages](https://img.shields.io/badge/ColPrac-Contributor's%20Guide-blueviolet)](https://github.com/SciML/ColPrac)
[![SciML Code Style](https://img.shields.io/static/v1?label=code%20style&message=SciML&color=9558b2&labelColor=389826)](https://github.com/SciML/SciMLStyle)
[![Conventional Commits](https://img.shields.io/badge/Conventional%20Commits-1.0.0-%23FE5196?logo=conventionalcommits&logoColor=white)](https://conventionalcommits.org)
-->
<!-- ALL-CONTRIBUTORS-BADGE:START - Do not remove or modify this section -->
[![All Contributors](https://img.shields.io/badge/all_contributors-6-orange.svg?style=flat-square)](#contributors-)
<!-- ALL-CONTRIBUTORS-BADGE:END -->

Contributions are welcome! 🎊 Please see the [contribution guidelines](https://github.com/cmichelenstrofer/.github/blob/main/CONTRIBUTING.md) for ways to contribute to the project.

### Contributors ✨

Thanks goes to these wonderful people ([emoji key](https://allcontributors.org/docs/en/emoji-key)):

<!-- ALL-CONTRIBUTORS-LIST:START - Do not remove or modify this section -->
<!-- prettier-ignore-start -->
<!-- markdownlint-disable -->
<table>
  <tbody>
    <tr>
      <td align="center" valign="top" width="14.28%"><a href="https://michelenstrofer.net"><img src="https://avatars.githubusercontent.com/u/25060182?v=4?s=100" width="100px;" alt="Carlos A. Michelén Ströfer"/><br /><sub><b>Carlos A. Michelén Ströfer</b></sub></a><br /><a href="https://github.com/cmichelenstrofer/DimensionfulAngles.jl/commits?author=cmichelenstrofer" title="Code">💻</a> <a href="https://github.com/cmichelenstrofer/DimensionfulAngles.jl/commits?author=cmichelenstrofer" title="Documentation">📖</a> <a href="https://github.com/cmichelenstrofer/DimensionfulAngles.jl/commits?author=cmichelenstrofer" title="Tests">⚠️</a> <a href="#ideas-cmichelenstrofer" title="Ideas, Planning, & Feedback">🤔</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/sostock"><img src="https://avatars.githubusercontent.com/u/42280794?v=4?s=100" width="100px;" alt="Sebastian Stock"/><br /><sub><b>Sebastian Stock</b></sub></a><br /><a href="#ideas-sostock" title="Ideas, Planning, & Feedback">🤔</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://kristofferc.github.io/"><img src="https://avatars.githubusercontent.com/u/1282691?v=4?s=100" width="100px;" alt="Kristoffer Carlsson"/><br /><sub><b>Kristoffer Carlsson</b></sub></a><br /><a href="https://github.com/cmichelenstrofer/DimensionfulAngles.jl/commits?author=KristofferC" title="Maintenance">🚧</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/DanDeepPhase"><img src="https://avatars.githubusercontent.com/u/13246120?v=4?s=100" width="100px;" alt="Daniel Boland"/><br /><sub><b>Daniel Boland</b></sub></a><br /><a href="#ideas-DanDeepPhase" title="Ideas, Planning, & Feedback">🤔</a> <a href="https://github.com/cmichelenstrofer/DimensionfulAngles.jl/issues?q=author%3ADanDeepPhase" title="Bug reports">🐛</a> <a href="https://github.com/cmichelenstrofer/DimensionfulAngles.jl/commits?author=DanDeepPhase" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/devel-chm"><img src="https://avatars.githubusercontent.com/u/789881?v=4?s=100" width="100px;" alt="devel-chm"/><br /><sub><b>devel-chm</b></sub></a><br /><a href="https://github.com/cmichelenstrofer/DimensionfulAngles.jl/commits?author=devel-chm" title="Documentation">📖</a></td>
      <td align="center" valign="top" width="14.28%"><a href="http://benconrad.net"><img src="https://avatars.githubusercontent.com/u/3711930?v=4?s=100" width="100px;" alt="Ben Conrad"/><br /><sub><b>Ben Conrad</b></sub></a><br /><a href="https://github.com/cmichelenstrofer/DimensionfulAngles.jl/commits?author=bc0n" title="Maintenance">🚧</a></td>
    </tr>
  </tbody>
</table>

<!-- markdownlint-restore -->
<!-- prettier-ignore-end -->

<!-- ALL-CONTRIBUTORS-LIST:END -->

## Acknowledgments

Some portions of this software are adapted from:

  - [UnitfulAngles.jl](https://github.com/yakir12/UnitfulAngles.jl/blob/master/LICENSE.md): Copyright (c) 2017: Yakir Luc Gagnon.
  - [UnitfulUS.jl](https://github.com/PainterQubits/UnitfulUS.jl/blob/master/LICENSE.md): Copyright (c) 2017, California Institute of Technology. All rights reserved.
