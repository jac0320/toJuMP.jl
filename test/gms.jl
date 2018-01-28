pkgdir = "$(Pkg.dir("toJuMP"))"

@testset "global/abel.gms" begin
    gmspath = joinpath(pkgdir, "test", "examples", "global", "abel.gms")
    jlpath = joinpath(pkgdir, ".jls", "abel.jl")

    gms2jump(gmspath)
    m = include(jlpath)
    @test isa(m, JuMP.Model)
    @test m.objSense == :Min
    @test length(m.colVal) == 31
    @test length([i for i in m.colCat if i == :Cont]) == 31
end
