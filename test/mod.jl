pkgdir = "$(Pkg.dir("toJuMP"))"

@testset "mod/4stufen.mod" begin
    name = "4stufen"

    modpath = joinpath(pkgdir, "test", "examples", "mod", "$(name).mod")
    jlpath = joinpath(pkgdir, ".jls", "$(name).jl")

    mod2jump(modpath)
    m = include(jlpath)
    @test isa(m, JuMP.Model)
    @test m.objSense == :Min

    @test length(m.colVal) == 149
    @test length([i for i in m.colCat if i == :Cont]) == 101
    @test length([i for i in m.colCat if i == :Bin]) == 48
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

    setsolver(m, IpoptSolver(print_level=0))
    solve(m)
    @test isapprox(m.objVal, 225.1945831861349;atol=1e-4)
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

    setsolver(m, IpoptSolver(print_level=0))
    solve(m)
    @test isapprox(m.objVal, -1.7650001749159285;atol=1e-4)
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

    setsolver(m, IpoptSolver(print_level=0))
    solve(m)
    @test isapprox(m.objVal, 1.9517331852884277;atol=1e-4)
end

@testset "mod/ex4_1_3.mod" begin
    name = "ex4_1_3"

    modpath = joinpath(pkgdir, "test", "examples", "mod", "$(name).mod")
    jlpath = joinpath(pkgdir, ".jls", "$(name).jl")

    mod2jump(modpath)
    m = include(jlpath)
    @test isa(m, JuMP.Model)
    @test length(m.colVal) == 1
    @test length([i for i in m.colCat if i == :Cont]) == 1
    @test length([i for i in m.colCat if i == :Bin]) == 0

    setsolver(m, IpoptSolver(print_level=0))
    solve(m)
    @test isapprox(m.objVal, -443.67170474112413;atol=1e-4)
end

@testset "mod/ex7_3_5.mod" begin
    name = "ex7_3_5"

    modpath = joinpath(pkgdir, "test", "examples", "mod", "$(name).mod")
    jlpath = joinpath(pkgdir, ".jls", "$(name).jl")

    mod2jump(modpath)
    m = include(jlpath)
    @test isa(m, JuMP.Model)

    @test length(m.colVal) == 13
    @test length([i for i in m.colCat if i == :Cont]) == 13
    @test length([i for i in m.colCat if i == :Bin]) == 0

    setsolver(m, IpoptSolver(print_level=0))
    status = solve(m)
    @test status == :Error
end

@testset "mod/ex14_2_4.mod" begin
    name = "ex14_2_4"

    modpath = joinpath(pkgdir, "test", "examples", "mod", "$(name).mod")
    jlpath = joinpath(pkgdir, ".jls", "$(name).jl")

    mod2jump(modpath)
    m = include(jlpath)
    @test isa(m, JuMP.Model)

    @test length(m.colVal) == 5
    @test length([i for i in m.colCat if i == :Cont]) == 5
    @test length([i for i in m.colCat if i == :Bin]) == 0

    setsolver(m, IpoptSolver(print_level=0))
    solve(m)
    @test isapprox(m.objVal, 7.562126836459202e-9;atol=1e-4)
end

@testset "mod/ex14_2_8.mod" begin
    name = "ex14_2_8"

    modpath = joinpath(pkgdir, "test", "examples", "mod", "$(name).mod")
    jlpath = joinpath(pkgdir, ".jls", "$(name).jl")

    mod2jump(modpath)
    m = include(jlpath)
    @test isa(m, JuMP.Model)

    @test length(m.colVal) == 4
    @test length([i for i in m.colCat if i == :Cont]) == 4
    @test length([i for i in m.colCat if i == :Bin]) == 0

    setsolver(m, IpoptSolver(print_level=0))
    solve(m)
    @test isapprox(m.objVal, 2.624689270273677e-9;atol=1e-4)
end

@testset "mod/st_rv1.mod" begin
    name = "st_rv1"

    modpath = joinpath(pkgdir, "test", "examples", "mod", "$(name).mod")
    jlpath = joinpath(pkgdir, ".jls", "$(name).jl")

    mod2jump(modpath)
    m = include(jlpath)
    @test isa(m, JuMP.Model)

    @test length(m.colVal) == 10
    @test length([i for i in m.colCat if i == :Cont]) == 10
    @test length([i for i in m.colCat if i == :Bin]) == 0

    setsolver(m, IpoptSolver(print_level=0))
    solve(m)
    @test isapprox(m.objVal, -59.904345906908;atol=1e-4)
end

@testset "mod/water.mod" begin
    name = "water"

    modpath = joinpath(pkgdir, "test", "examples", "mod", "$(name).mod")
    jlpath = joinpath(pkgdir, ".jls", "$(name).jl")

    mod2jump(modpath)
    m = include(jlpath)
    @test isa(m, JuMP.Model)

    @test length(m.colVal) == 41
    @test length([i for i in m.colCat if i == :Cont]) == 41
    @test length([i for i in m.colCat if i == :Bin]) == 0

    setsolver(m, IpoptSolver(print_level=0))
    status = solve(m)
    @test status == :Error
end
