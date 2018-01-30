pkgdir = "$(Pkg.dir("toJuMP"))"

@testset "mod/4stufen.mod" begin
    name = "4stufen"

    modpath = joinpath(pkgdir, "test", "examples", "mod", "$(name).mod")
    jlpath = joinpath(pkgdir, ".jls", "$(name).jl")

    mod2jump(modpath)
    m = include(jlpath)
    @test isa(m, JuMP.Model)
    @test m.objSense == :Min
end

@testset "mod/abel.mod" begin
    name = "abel"

    modpath = joinpath(pkgdir, "test", "examples", "mod", "$(name).mod")
    jlpath = joinpath(pkgdir, ".jls", "$(name).jl")

    mod2jump(modpath)
    m = include(jlpath)
    @test isa(m, JuMP.Model)
    @test m.objSense == :Min
    @test length(m.colVal) == 30
    @test length([i for i in m.colCat if i == :Cont]) == 30
end

@testset "mod/alkyl.mod" begin
    name = "alkyl"
    modpath = joinpath(pkgdir, "test", "examples", "mod", "$(name).mod")
    jlpath = joinpath(pkgdir, ".jls", "$(name).jl")

    mod2jump(modpath)
    m = include(jlpath)
    @test isa(m, JuMP.Model)
    @test m.objSense == :Min
    @test length(m.colVal) == 14
    @test length([i for i in m.colCat if i == :Cont]) == 14
end

@testset "mod/autocorr_bern20-03.mod" begin
    name = "autocorr_bern20-03"

    modpath = joinpath(pkgdir, "test", "examples", "mod", "$(name).mod")
    jlpath = joinpath(pkgdir, ".jls", "$(name).jl")

    mod2jump(modpath)
    m = include(jlpath)
    @test isa(m, JuMP.Model)
end

@testset "mod/bearing.mod" begin
    name = "bearing"
    modpath = joinpath(pkgdir, "test", "examples", "mod", "$(name).mod")
    jlpath = joinpath(pkgdir, ".jls", "$(name).jl")

    mod2jump(modpath)
    m = include(jlpath)
    @test isa(m, JuMP.Model)
    @test m.objSense == :Min
    @test length(m. colVal) == 13
    @test length([i for i in m.colCat if i == :Cont]) == 13
end

@testset "mod/ex4_1_3.mod" begin
    name = "ex4_1_3"

    modpath = joinpath(pkgdir, "test", "examples", "mod", "$(name).mod")
    jlpath = joinpath(pkgdir, ".jls", "$(name).jl")

    mod2jump(modpath)
    m = include(jlpath)
    @test isa(m, JuMP.Model)
end

@testset "mod/ex7_3_5.mod" begin
    name = "ex7_3_5"

    modpath = joinpath(pkgdir, "test", "examples", "mod", "$(name).mod")
    jlpath = joinpath(pkgdir, ".jls", "$(name).jl")

    mod2jump(modpath)
    m = include(jlpath)
    @test isa(m, JuMP.Model)
end

@testset "mod/ex14_2_4.mod" begin
    name = "ex14_2_4"

    modpath = joinpath(pkgdir, "test", "examples", "mod", "$(name).mod")
    jlpath = joinpath(pkgdir, ".jls", "$(name).jl")

    mod2jump(modpath)
    m = include(jlpath)
    @test isa(m, JuMP.Model)
end

@testset "mod/ex14_2_8.mod" begin
    name = "ex14_2_8"

    modpath = joinpath(pkgdir, "test", "examples", "mod", "$(name).mod")
    jlpath = joinpath(pkgdir, ".jls", "$(name).jl")

    mod2jump(modpath)
    m = include(jlpath)
    @test isa(m, JuMP.Model)
end

@testset "mod/st_rv1.mod" begin
    name = "st_rv1"

    modpath = joinpath(pkgdir, "test", "examples", "mod", "$(name).mod")
    jlpath = joinpath(pkgdir, ".jls", "$(name).jl")

    mod2jump(modpath)
    m = include(jlpath)
    @test isa(m, JuMP.Model)
end

@testset "mod/water.mod" begin
    name = "water"

    modpath = joinpath(pkgdir, "test", "examples", "mod", "$(name).mod")
    jlpath = joinpath(pkgdir, ".jls", "$(name).jl")

    mod2jump(modpath)
    m = include(jlpath)
    @test isa(m, JuMP.Model)
end
