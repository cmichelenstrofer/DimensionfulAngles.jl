using Test, SafeTestsets, Documenter

@time @testset "DimensionfulAngles.jl" begin
    @time @safetestset "Test Core Package" begin include("test_core_package.jl") end
    @time @safetestset "Test Base Functions" begin include("test_base_functions.jl") end
    # TODO: documenter
end
