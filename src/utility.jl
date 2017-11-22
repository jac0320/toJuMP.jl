function load_prob(probname::AbstractString)
    include("$(Pkg.dir())/toJuMP/instances/$(probname).jl")
end

load_prob(probname::Vector{AbstractString}) = for i in probname load_prob(i) end

function try_iflinear(c::AbstractString, quadNL::Bool=false)
	contains(c, "sqrt") && return false
	contains(c, "^") && return false
	contains(c, "abs") && return false
    linear = true
    try
        con = eval(parse(c))
        if quadNL && isa(con, JuMP.ConstraintRef{JuMP.Model,JuMP.GenericQuadConstraint{JuMP.GenericQuadExpr{Float64,JuMP.Variable}}})
            linear = false
        end
    catch e
        linear = false
    end
    return linear
end

function try_addvar(m_t, var::AbstractString, var_idx::AbstractString)
    vs = "@variable(m_t, $(var)[$(var_idx)])"
    @eval $(parse(vs))
    return m
end

function try_addvar(m_t, var::AbstractString)
    vs = "@variable(m_t, $(var))"
    @eval $(parse(vs))
    return m
end


function get_one_line(file::IOStream; one_line=" ")
    while one_line[end] != ';'
        one_line = string(one_line, lstrip(readline(file),' '))
    end
    one_line = split(one_line, ';', keep=false)
    @assert length(one_line) == 1
    return one_line[1]
end

"""
    Reform the constraint expression using variables with indices
"""
function replace_vars(gms::oneProblem)
    for row in gms.rows
		gms.rowsLHS[row] = replace(gms.rowsLHS[row], r"x(\d+)", s"x[\1]")
		gms.rowsLHS[row] = replace(gms.rowsLHS[row], r"i(\d+)", s"i[\1]")
		gms.rowsLHS[row] = replace(gms.rowsLHS[row], r"b(\d+)", s"b[\1]")
    end
end

function replace_oprs(line::AbstractString; kwargs...)

    line = replace(line, "\n", "")
    line = replace(line, " ", "")
    contains(line, "sqr") && (line = _replace_sqr(line))
    contains(line, "POWER") && (line = _replace_POWER(line))
	contains(line, "power") && (line = _replace_POWER(line,powerstring="power("))
    line = replace(line, "**", "^")

	unsupported_opr = ["arctan", "ARCTAN", 
					   "ceil", "CEIL",
					   "errorof", "ERROROF",
					   "floor", "FLOOR",
					   "mapVal", "MAPVAL",
					   "max", "MAX",
					   "min", "MIN",
					   "mod", "MOD",
					   "normal", "NORMAL",
					   "round", "ROUND",
					   "sign", "SIGN",
					   "trunc", "TRUNC",
					   "uniform", "UNIFORM"]
	for o in unsupported_opr
		contains(line, o) && error("Unsupported operator $(o) detected")
	end

    return line
end

function _replace_sqr(str::AbstractString)
    # @show "Begin ",str
    for i in 1:(length(str)-4)
        if str[i:(i+3)] == "sqr("
            warp = 0
            for j in (i+4):length(str)
                if str[j] == '('
                    warp += 1
                elseif str[j] == ')'
                    warp -= 1
                end
                if warp == -1
                    substart = i+4
                    subclose = j-1
                    subStr = str[substart:subclose]
                    # @show "Before replace ", subStr
                    str = replace(str, "sqr($subStr)"," ($subStr)^2")
                    # @show "After replace ", str
                    subStr = str[substart-2:subclose-2]
                    subStr = _replace_sqr(subStr)
                    # @show "Processed subStr = ", subStr
                    str = string(str[1:substart-3], subStr, str[subclose-1:end])
                    # @show "After recomposing", length(str)
                    break
                end
            end
        end
    end
    # @show "exiting this level with ", str
    return str
end

function _replace_POWER(str::AbstractString; powerstring="POWER(")
    pVal = 0.0
    for i in 1:length(str)-6
        if str[i:(i+5)] == powerstring
            warp = 1
            pValStart = 0
            for j in (i+6):length(str)
                if str[j] == '('
                    warp += 1
                elseif str[j] == ')'
                    warp -= 1
                elseif str[j] == ','
                    pValStart = j
                end
                if warp == 0
                    @assert pValStart > 0   # By the time a function is closed, pVal segment must be detected
                    substart = i+6
                    subclose = j-1
                    subStr = str[substart:subclose]
                    argStr = str[substart:(pValStart-1)]
                    pVal = parse(str[pValStart+1:subclose])   # Don't allow complicated expression here
					str = replace(str, "$(powerstring)$(subStr))"," ($argStr)^$(pVal)")
                    subStr = str[substart-5:subclose-5]
                    subStr = _replace_POWER(subStr)
                    str = string(str[1:substart-6], subStr, str[subclose-4:end])
                    i = substart + 1 # Dail back the looper due to the reduced length of string
                    break
                end
            end
        end
        i > length(str)-6 && break
    end

    return str
end

function read_command(file::IOStream, gms::oneProblem, lInit::AbstractString; kwargs...)
    warn("I am not that smart to parse command in gms files, YET")
    return 0
end

function convert_equality(probname="")

    info("This function handles problem with too many equality constraints.", prefix="POD Experiment: ")
    if !isfile("$(Pkg.dir())/toJuMP/instances/$(probname).jl")
        info("NO problem file detected in $(Pkg.dir())/toJuMP/instances/$(probname).jl", prefix="POD Experiment: ")
        return
    end

    f = open("$(Pkg.dir())/toJuMP/instances/$(probname).jl", "r")
    outf = open("$(Pkg.dir())/toJuMP/instances/$(probname)_gl.jl", "w")

    for l in readlines(f)
        if ismatch(r"==", l)
            geq = replace(l, "==", ">=")
            leq = replace(l, "==", "<=")
            write(outf, geq)
            write(outf, "\n")
            write(outf, leq)
            write(outf, "\n")
        elseif ismatch(Regex(probname), l)
            write(outf, "function $(probname)_gl(;options=Dict())\n")
        else
            write(outf, l)
            write(outf, "\n")
        end
    end

    close(f)
    close(outf)

    return
end
