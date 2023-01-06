# Relation to proposed SI extensions

The concept of dimensions has some limitations (see [SI-Brochure_2019](@cite), [Nature_2017](@cite), and [Bramwell_2017](@cite), which have led to many proposed extensions to the SI system, including many proposals to include angles as a dimension.
Several such proposals include [Eder_1982](@cite), [Quincey_2021](@cite), [Leonard_2021](@cite), and references therein.

## Summary of proposals

The exact form of the proposals and their effects on the equations of physics are all different, but most (i) include angle as a base dimension, (ii) use a "fundamental" constant, typically equal to one radian, to modify the equations of physics, (iii) define solid angle as a derived dimension equal to angle squared, and (iv) take different approaches to which equations or quantity units to modify.

Some examples of how common equations would be modified in such systems, using ``θ₀=1rad``:

  - Trigonometric functions:
    
      + ``cos(θ) → cos(θ/θ₀)``
      + ``cos(ωt+φ) → cos([ωt+φ]/θ₀)``

  - Angular frequency and frequency:
    
      + ``ω=2πf → ω=2πfθ₀``
  - Arc length ``s`` and other kinematic equations:
    
      + ``s=rθ → s=rθ/θ₀``
  - For dynamic equations there's more variability between the different proposals.
    As an example, [Quincey_2021](@cite) would modify torque (and its unit) while leaving the units of work intact, as
    
      + ``T=(𝐫×𝐅) → T=(𝐫×𝐅)/θ₀``
      + ``W=Tθ``

## *DimensionfulAngles.jl*'s relation to these proposals

*DimensionfulAngles.jl* extends the number of base dimensions solely for convenience when working with unitful quantities on a computer.
It does not propose or promote any *official* extension of the SI system such as those summarized above.
However, there's a few things to point out:

**1. Defining constant**

The constant `θ₀=1rad` is provided as a hypothetical "defining unit" or "fundamental constant", mostly for analogy/consistency with the other base dimensions in the SI and *Unitful.jl*.

**2. Extension to `Base` and standard library functions**

Additionally, note that the extensions to functions in `Base` ensure that function calls like

```jldoctest; setup = :(using DimensionfulAngles)
julia> cos(45ua"°")
0.7071067811865476
```

work without having to use the constant `θ₀` to normalize the argument.
Please report any function in `Base` or in the *standard library* that should handle arguments of a dimension that includes angles but is not currently covered by this package.
The goal of this package is to cover all such functions as well as those whose output should be of dimensions that includes angles.

**3. Functions in other packages**

Functions in other packages for which it would make sense to provide arguments with dimensions including angles will not immediately work.
You will likely need to convert to radians and then strip the units before providing the quantity as an argument to that function.
This can be done in several ways, including through the use of the constant `θ₀` for normalization.
Alternatively, you can expand those functions to accept dimensionful angles by defining new methods.
If you believe such expansion should be included in *DimensionfulAngles.jl* (e.g. to cover a very popular package) please create an [issue](https://github.com/cmichelenstrofer/DimensionfulAngles.jl/issues) in the GitHub repository.

**4. Solid angles**

Solid angles are considered a derived dimension equal to angle squared (𝐀²).
This is in agreement with the proposals discussed above.

## References

```@bibliography
```
