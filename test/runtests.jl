using Base.Test
using toJuMP
using JuMP
using Ipopt


testdir = Pkg.dir("toJuMP")

include("$(testdir)/test/gms.jl")
include("$(testdir)/test/mod.jl")
