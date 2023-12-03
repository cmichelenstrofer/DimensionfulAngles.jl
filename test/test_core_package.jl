using Test, DimensionfulAngles, Unitful, UnitfulAngles
using Unitful: 𝐓, 𝐋, ContextUnits, FixedUnits, FreeUnits, Units
using DimensionfulAngles: 𝐀

function test_uamacro(unit::Symbol)
    unitᵃ = Symbol("$unit" * "ᵃ")
    @eval case_ua = $(Meta.parse(""" ua"$unit" """))
    @eval case_direct = DimensionfulAngles.$unitᵃ
    @test case_ua === case_direct
    return nothing
end

function test_uamacro_prefix(unit::Symbol)
    prefixed_units = Symbol.([prefix * "$unit" for prefix in values(Unitful.prefixdict)])
    test_uamacro.(prefixed_units)
    return nothing
end

function test_prefixed_units(unit::Symbol)
    for (power, prefix) in Unitful.prefixdict
        unitᵃ = Symbol("$unit" * "ᵃ")
        prefixed_unitᵃ = Symbol(prefix * "$unitᵃ")
        @eval prefixed = 1.0 * DimensionfulAngles.$prefixed_unitᵃ
        @eval base_power = 10.0^$power * DimensionfulAngles.$unitᵃ
        @test prefixed ≈ base_power
    end
    return nothing
end

@testset "Core" begin
    # angle dimension
    @test typeof(𝐀) === Unitful.Dimensions{(Unitful.Dimension{:Angle}(1),)}
    @test typeof(DimensionfulAngles.Angle) === UnionAll
    @test DimensionfulAngles.AngleFreeUnits === FreeUnits{U, 𝐀} where {U}
    @test DimensionfulAngles.AngleUnits === Units{U, 𝐀} where {U}

    # rad
    @test isa(1ua"rad", DimensionfulAngles.Angle)
    test_uamacro_prefix(:rad)
    test_prefixed_units(:rad)

    # degree
    @test ua"°" === DimensionfulAngles.°ᵃ
    test_uamacro(:°)
    @test 180ua"°" ≈ π * ua"rad"

    # constant θ₀
    @test θ₀ ≈ 1ua"rad"
end

@testset "Units" begin
    for (unit, full_turn) in (:arcminuteᵃ => 360 * 60, :arcsecondᵃ => 360 * 3600,
                              :diameterPartᵃ => 2π * 60, :doubleTurnᵃ => 0.5, :turnᵃ => 1,
                              :halfTurnᵃ => 2, :quadrantᵃ => 4, :sextantᵃ => 6,
                              :octantᵃ => 8, :clockPositionᵃ => 12, :hourAngleᵃ => 24,
                              :compassPointᵃ => 32, :hexacontadeᵃ => 60, :bradᵃ => 256,
                              :gradᵃ => 400, :ʰᵃ => 24, :ᵐᵃ => 24 * 60, :ˢᵃ => 24 * 3600)
        @test @eval $full_turn * DimensionfulAngles.$unit ≈ 1ua"turn"
        test_uamacro(Symbol("$unit"[1:prevind("$unit", lastindex("$unit"))]))
    end

    # prefixed `as`
    @test isa(1ua"as", DimensionfulAngles.Angle)
    @test 1ua"as" == 1ua"arcsecond"
    test_uamacro_prefix(:as)
    test_prefixed_units(:as)

    # sexagesimal()
    base, minutes, seconds = sexagesimal(20.2ua"°")
    @test base == 20ua"°"
    @test minutes == 11ua"arcminute"
    @test seconds ≈ 60.0ua"arcsecond"

    base, minutes, seconds = sexagesimal(20.2ua"°"; base_unit = ua"ʰ")
    @test base == 1ua"ʰ"
    @test minutes == 20ua"ᵐ"
    @test seconds ≈ 48.0ua"ˢ"

    # show_sexagesimal
    angle = 1ua"rad"
    temp_file = tempname()
    open(temp_file, "w") do io
        redirect_stdout(io) do
            return show_sexagesimal(angle)
        end
    end
    s1, s2, s3 = sexagesimal(angle)
    @test read(temp_file, String) == "$s1 $s2 $s3"

    temp_file = tempname()
    open(temp_file, "w") do io
        redirect_stdout(io) do
            return show_sexagesimal(angle; base_unit = ua"ʰ")
        end
    end
    s1, s2, s3 = sexagesimal(angle; base_unit = ua"ʰ")
    @test read(temp_file, String) == "$s1 $s2 $s3"
end

@testset "Derived" begin
    # solid angle
    @test typeof(DimensionfulAngles.SolidAngle) === UnionAll
    @test DimensionfulAngles.SolidAngleFreeUnits === Unitful.FreeUnits{U, 𝐀^2} where {U}
    @test DimensionfulAngles.SolidAngleUnits === Unitful.Units{U, 𝐀^2} where {U}

    @test 1ua"sr" == 1ua"rad*rad"
    test_uamacro_prefix(:sr)
    @test isa(1ua"sr", DimensionfulAngles.SolidAngle)
    test_prefixed_units(:sr)

    # angular velocity & acceleration
    @test typeof(DimensionfulAngles.AngularVelocity) === UnionAll
    @test DimensionfulAngles.AngularVelocityFreeUnits === FreeUnits{U, 𝐀 * 𝐓^-1} where {U}
    @test DimensionfulAngles.AngularVelocityUnits === Units{U, 𝐀 * 𝐓^-1} where {U}

    @test typeof(DimensionfulAngles.AngularAcceleration) === UnionAll
    @test DimensionfulAngles.AngularAccelerationFreeUnits ===
          FreeUnits{U, 𝐀 * 𝐓^-2} where {U}
    @test DimensionfulAngles.AngularAccelerationUnits === Units{U, 𝐀 * 𝐓^-2} where {U}

    @test isa(1ua"rps", DimensionfulAngles.AngularVelocity)
    @test 1ua"rps" == 1u"turnᵃ / s"
    test_uamacro(:rps)
    @test isa(1ua"rpm", DimensionfulAngles.AngularVelocity)
    @test 1ua"rpm" == 1u"turnᵃ / minute"
    test_uamacro(:rpm)
    @test isa(1u"radᵃ/s^2", DimensionfulAngles.AngularAcceleration)

    # angular wavenumber, angular wavelength, angular period
    @test typeof(DimensionfulAngles.AngularWavenumber) === UnionAll
    @test DimensionfulAngles.AngularWavenumberFreeUnits === FreeUnits{U, 𝐀 * 𝐋^-1} where {U}
    @test DimensionfulAngles.AngularWavenumberUnits === Units{U, 𝐀 * 𝐋^-1} where {U}

    @test typeof(DimensionfulAngles.AngularWavelength) === UnionAll
    @test DimensionfulAngles.AngularWavelengthFreeUnits === FreeUnits{U, 𝐀^-1 * 𝐋} where {U}
    @test DimensionfulAngles.AngularWavelengthUnits === Units{U, 𝐀^-1 * 𝐋} where {U}

    @test typeof(DimensionfulAngles.AngularPeriod) === UnionAll
    @test DimensionfulAngles.AngularPeriodFreeUnits === FreeUnits{U, 𝐀^-1 * 𝐓} where {U}
    @test DimensionfulAngles.AngularPeriodUnits === Units{U, 𝐀^-1 * 𝐓} where {U}

    # periodic: temporal
    @test uconvert(u"radᵃ/s", 1u"Hz", Periodic()) ≈ (2π)u"radᵃ/s"
    @test uconvert(u"Hz", 1u"radᵃ/s", Periodic()) ≈ (1 / 2π)u"Hz"
    @test uconvert(u"Hz", 10u"s", Periodic()) ≈ 0.1u"Hz"
    @test uconvert(u"s", 10u"Hz", Periodic()) ≈ 0.1u"s"
    @test uconvert(u"s", 2u"radᵃ/s", Periodic()) ≈ (π)u"s"
    @test uconvert(u"radᵃ/s", (π)u"s", Periodic()) ≈ 2u"radᵃ/s"
    @test uconvert(u"s/radᵃ", 10u"radᵃ/s", Periodic()) ≈ 0.1u"s/radᵃ"
    @test uconvert(u"radᵃ/s", 10u"s/radᵃ", Periodic()) ≈ 0.1u"radᵃ/s"
    @test uconvert(u"s/radᵃ", 1u"s", Periodic()) ≈ (1 / 2π)u"s/radᵃ"
    @test uconvert(u"s", 1u"s/radᵃ", Periodic()) ≈ (2π)u"s"
    @test uconvert(u"s/radᵃ", 1u"Hz", Periodic()) ≈ (1 / 2π)u"s/radᵃ"
    @test uconvert(u"Hz", 1u"s/radᵃ", Periodic()) ≈ (1 / 2π)u"Hz"
    @test uconvert(u"Hz", 10u"Hz", Periodic()) ≈ 10u"1/s"
    @test uconvert(u"s", 10u"s", Periodic()) ≈ 10u"s"
    @test uconvert(u"radᵃ/s", 10u"radᵃ/s", Periodic()) ≈ 10u"radᵃ/s"
    @test uconvert(u"s/radᵃ", 10u"s/radᵃ", Periodic()) ≈ 10u"s/radᵃ"

    # periodic: spatial
    @test uconvert(u"radᵃ/m", 1u"1/m", Periodic()) ≈ (2π)u"radᵃ/m"
    @test uconvert(u"m^-1", 1u"radᵃ/m", Periodic()) ≈ (1 / 2π)u"1/m"
    @test uconvert(u"m^-1", 10u"m", Periodic()) ≈ 0.1u"1/m"
    @test uconvert(u"m", 10u"m^-1", Periodic()) ≈ 0.1u"m"
    @test uconvert(u"m", 2u"radᵃ/m", Periodic()) ≈ (π)u"m"
    @test uconvert(u"radᵃ/m", (π)u"m", Periodic()) ≈ 2u"radᵃ/m"
    @test uconvert(u"m/radᵃ", 10u"radᵃ/m", Periodic()) ≈ 0.1u"m/radᵃ"
    @test uconvert(u"radᵃ/m", 10u"m/radᵃ", Periodic()) ≈ 0.1u"radᵃ/m"
    @test uconvert(u"m/radᵃ", 1u"m", Periodic()) ≈ (1 / 2π)u"m/radᵃ"
    @test uconvert(u"m", 1u"m/radᵃ", Periodic()) ≈ (2π)u"m"
    @test uconvert(u"m/radᵃ", 1u"m^-1", Periodic()) ≈ (1 / 2π)u"m/radᵃ"
    @test uconvert(u"m^-1", 1u"m/radᵃ", Periodic()) ≈ (1 / 2π)u"1/m"
    @test uconvert(u"m^-1", 10u"m^-1", Periodic()) ≈ 10u"1/m"
    @test uconvert(u"m", 10u"m", Periodic()) ≈ 10u"m"
    @test uconvert(u"radᵃ/m", 10u"radᵃ/m", Periodic()) ≈ 10u"radᵃ/m"
    @test uconvert(u"m/radᵃ", 10u"m/radᵃ", Periodic()) ≈ 10u"m/radᵃ"
end

@testset "Convert" begin
        # uconvert :Unitful <=> :DimensionfulAngles
        for (x_u, x_ua) ∈ zip((1u"rad", 1u"°"), (1u"radᵃ", 1u"°ᵃ"))
            @test uconvert(:DimensionfulAngles, x_u) === x_ua
            @test dimension(uconvert(:DimensionfulAngles, x_u)) === 𝐀
            @test uconvert(:Unitful, x_u) === x_u
            @test dimension(uconvert(:Unitful, x_u)) === NoDims
            @test uconvert(:Unitful, x_ua) === x_u
            @test dimension(uconvert(:Unitful, x_ua)) === NoDims
            @test uconvert(:DimensionfulAngles, x_ua) === x_ua
            @test dimension(uconvert(:DimensionfulAngles, x_ua)) === 𝐀
        end
        for (mm, UnitType) ∈ zip(
                [u"mm", ContextUnits(u"mm", u"mm"), FixedUnits(u"mm")],
                [FreeUnits, ContextUnits, FixedUnits]
            )
            x_u = 1.24*mm*u"°^3/m*s^2"
            x_ua = uconvert(:DimensionfulAngles, x_u)
            @test x_ua ≈ 1.24*(π/180)^3*u"mm*radᵃ^3*s^2*m^-1"
            @test dimension(x_ua) == 𝐀^3*𝐓^2
            @test typeof(unit(x_u)) <: UnitType
            @test typeof(unit(x_ua)) <: UnitType
        end
        for (rad, UnitType) ∈ zip(
                [u"rad", ContextUnits(u"rad", u"rad"), FixedUnits(u"rad")],
                [FreeUnits, ContextUnits, FixedUnits]
            )
            x_u = 1.24*rad*u"°^3/m*s^2"
            x_ua = uconvert(:DimensionfulAngles, x_u)
            @test x_ua ≈ 1.24*(π/180)^3*u"radᵃ^4*s^2*m^-1"
            @test dimension(x_ua) == 𝐀^4*𝐓^2*𝐋^-1
            @test typeof(unit(x_u)) <: UnitType
            @test typeof(unit(x_ua)) <: UnitType
        end
        let x = 2.35u"turn^2*rad^-1*°^4"*u"mm^7"
            @test unit(uconvert(:DimensionfulAngles, x)) == ua"turn^2*rad^-1*°^4"*u"mm^7"
            @test uconvert(:DimensionfulAngles, x).val ≈ 2.35
        end
        let x = 2.35ua"turn^2*rad^-1*°^4"*u"mm^7"
            @test unit(uconvert(:DimensionfulAngles, x)) == ua"turn^2*rad^-1*°^4"*u"mm^7"
            @test uconvert(:DimensionfulAngles, x).val ≈ 2.35
        end
        let x = 2.35u"turn^2*rad^-1*°^4"*u"mm^7"
            @test unit(uconvert(:Unitful, x)) == u"turn^2*rad^-1*°^4"*u"mm^7"
            @test uconvert(:Unitful, x).val ≈ 2.35
        end
        let x = 2.35ua"turn^2*rad^-1*°^4"*u"mm^7"
            @test unit(uconvert(:Unitful, x)) == u"turn^2*rad^-1*°^4"*u"mm^7"
            @test uconvert(:Unitful, x).val ≈ 2.35
        end
        # astronomical units; not equivalent
        let x = 2.35u"turn^2*rad^-1*μas^-2*mas^-2*pas"*u"mm^7"
            @test (
                unit(uconvert(:DimensionfulAngles, x)) == ua"turn^2*rad^-1*arcsecond^-3"*u"mm^7"
            )
            @test uconvert(:DimensionfulAngles, x).val ≈ (
                2.35 * (1//1_000_000)^-2 * (1//1_000)^-2 * (1//1_000_000_000_000)
            )
        end
        let x = 2.35ua"turn^2*rad^-1*μas^-2*mas^-2*pas* ʰ* ᵐ^2* ˢ^-1"*u"mm^7"
            @test (
                unit(uconvert(:Unitful, x)) == u"turn^2*rad^-1*arcsecond^-3*hourAngle^2"*u"mm^7"
            )
            @test uconvert(:Unitful, x).val ≈ (
                2.35 *
                (1//1_000_000)^-2 * (1//1_000)^-2 * (1//1_000_000_000_000) *
                (1//60)^2 * (1//3600)^-1
            )
        end
end

@testset "DefaultSymbols" begin
    @test typeof(DimensionfulAngles.DefaultSymbols) == Module
    @test dimension(DimensionfulAngles.DefaultSymbols.rad) == DimensionfulAngles.𝐀
    @test dimension(DimensionfulAngles.DefaultSymbols.°) == DimensionfulAngles.𝐀
end
