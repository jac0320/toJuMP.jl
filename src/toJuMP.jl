module toJuMP

using JuMP
using JSON

include("const.jl")
include("types.jl")
include("writer.jl")
include("utility.jl")

include("gms2jump.jl")
include("mod2jump.jl")

!isdir("$(Pkg.dir())/toJuMP/.jls") && mkdir("$(Pkg.dir())/toJuMP/.jls")

m_tester = Model()

export gms2jump, mod2jump

end # module
