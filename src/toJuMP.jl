module toJuMP

using JSON, JuMP

include("const.jl")
include("types.jl")

include("minlplib2.jl")
include("utility.jl")
include("gms2jump.jl")

!isdir("$(Pkg.dir())/toJuMP/.jls") && mkdir("$(Pkg.dir())/toJuMP/.jls")
!isdir("$(Pkg.dir())/toJuMP/.prob") && mkdir("$(Pkg.dir())/toJuMP/.prob")

m_tester = Model()

export gms2jump

end # module
