module toJuMP

using JuMP
using JSON

include("const.jl")
include("types.jl")
include("writer.jl")
include("utility.jl")

include("minlplib2.jl")
include("gms2jump.jl")
# include("mod2jump.jl")

!isdir("$(Pkg.dir())/toJuMP/.jls") && mkdir("$(Pkg.dir())/toJuMP/.jls")
!isdir("$(Pkg.dir())/toJuMP/.prob") && mkdir("$(Pkg.dir())/toJuMP/.prob")

m_tester = Model()

export gms2jump

end # module
