pkgdir = "$(Pkg.dir("toJuMP"))"

@testset "global/abel.gms" begin
    name = "abel"

    gmspath = joinpath(pkgdir, "test", "examples", "global", "$(name).gms")
    jlpath = joinpath(pkgdir, ".jls", "$(name).jl")

    gms2jump(gmspath)
    m = include(jlpath)
    @test isa(m, JuMP.Model)
    @test m.objSense == :Min
    @test length(m.colVal) == 31
    @test length([i for i in m.colCat if i == :Cont]) == 31

    @test getlowerbound(Variable(m, 2)) == 387.9
    @test getupperbound(Variable(m, 2)) == 387.9
    @test getlowerbound(Variable(m, 10)) == 85.3
    @test getupperbound(Variable(m, 10)) == 85.3
    @test getvalue(Variable(m, 3)) == 387.9
end

@testset "global/alkyl.gms" begin
    name = "alkyl"
    gmspath = joinpath(pkgdir, "test", "examples", "global", "$(name).gms")
    jlpath = joinpath(pkgdir, ".jls", "$(name).jl")

    gms2jump(gmspath)
    m = include(jlpath)
    @test isa(m, JuMP.Model)
    @test m.objSense == :Min
    @test length(m.colVal) == 15
    @test length([i for i in m.colCat if i == :Cont]) == 15
    @test getvalue(Variable(m,1)) == -0.9
    @test getvalue(Variable(m,15)) == 1
    @test getlowerbound(Variable(m, 2)) == 0.0
    @test getupperbound(Variable(m, 2)) == 2
    @test getlowerbound(Variable(m, 3)) == 0.0
    @test getupperbound(Variable(m, 3)) == 1.6
    @test getlowerbound(Variable(m, 4)) == 0.0
    @test getupperbound(Variable(m, 4)) == 1.2
    @test getlowerbound(Variable(m, 7)) == 0.85
    @test getupperbound(Variable(m, 9)) == 12
    @test getlowerbound(Variable(m, 14)) == 0.9
    @test getupperbound(Variable(m, 15)) == 1.01010101010101
end


@testset "global/bearing.gms" begin
    name = "bearing"
    gmspath = joinpath(pkgdir, "test", "examples", "global", "$(name).gms")
    jlpath = joinpath(pkgdir, ".jls", "$(name).jl")

    gms2jump(gmspath)
    m = include(jlpath)
    @test isa(m, JuMP.Model)
    @test m.objSense == :Min
    @test length(m. colVal) == 14
    @test length([i for i in m.colCat if i == :Cont]) == 14
    @test getvalue(Variable(m, 2)) == 6
    @test getvalue(Variable(m, 3)) == 5
    @test getvalue(Variable(m, 10)) == 50
    @test getlowerbound(Variable(m, 2)) == 1
    @test getupperbound(Variable(m, 2)) == 16
    @test getlowerbound(Variable(m, 6)) == 1
    @test getupperbound(Variable(m, 6)) == 1000
    
    @test getupperbound(Variable(m, 2)) == 16
end

@testset "global/camcge.gms" begin
    name = "camcge"
    gmspath = joinpath(pkgdir, "test", "examples", "global", "$(name).gms")
    jlpath = joinpath(pkgdir, ".jls", "$(name).jl")

    gms2jump(gmspath)
    m = include(jlpath)
    @test isa(m, JuMP.Model)
end
