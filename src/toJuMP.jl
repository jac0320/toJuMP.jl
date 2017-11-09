module toJuMP

using JSON

include("const.jl")
include("types.jl")

include("minlplib2.jl")
include("utility.jl")
include("gms2julia.jl")

!isdir("$(Pkg.dir())/toJuMP/.jls") && mkdir("$(Pkg.dir())/toJuMP/.jls")
!isdir("$(Pkg.dir())/toJuMP/.prob") && mkdir("$(Pkg.dir())/toJuMP/.prob")

end # module
