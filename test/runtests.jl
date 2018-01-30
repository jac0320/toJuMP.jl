using Base.Test
using toJuMP
using JuMP


testdir = Pkg.dir("toJuMP")

include("$(testdir)/test/gms.jl")
include("$(testdir)/test/mod.jl")
