function load_prob(probname::AbstractString)
    include("$(Pkg.dir())/toJuMP/instances/$(probname).jl")
end

load_prob(probname::Vector{AbstractString}) = for i in probname load_prob(i) end

function write_varattr(io, attr::Dict, gms::oneProblem, funcstrs::Any)

    vals = [i[2] for i in attr]
    freqtable = Dict(v => [] for v in unique(vals))
    isa(funcstrs, Vector) ? funcstrs = funcstrs : funcstrs = [funcstrs]

    for i in attr
        push!(freqtable[i[2]], i[1])
    end

    for val in keys(freqtable)
        idxseq, nameseq = separate_varseq(freqtable[val])
        for i in nameseq
            write(io, "$(funcstr)($(i), $(val))\n")
        end
        for i in idxseq
            if length(i) > 3
                write(io, "for i in $(i[1][1]):$(i[end][1])\n")
                for fs in funcstrs
                    write(io, "\t$(fs)($(i[1][2])[i], $(val))\n")
                end
                write(io, "end\n")
            else
                for j in i
                    for fs in funcstrs
                        write(io, "$(fs)($(j[2])[$(j[1])], $(val))\n")
                    end
                end
            end
        end
    end

    return
end

function write_varattr(io, gms::oneProblem, mode::AbstractString)

    for col in gms.cols

        if mode == "raw"
            colName = col
        elseif mode == "index"
            colName = gms.cols2vars[col]
        end

        if haskey(gms.lb, col)
            write(f, "setlowerbound($(colName), $(gms.lb[col]))\n")
        end
        if haskey(gms.ub, col)
            write(f, "setupperbound($(colName), $(gms.ub[col]))\n")
        end
        if haskey(gms.fx, col)
            write(f, "setlowerbound($(colName), $(gms.fx[col]))\n")
            write(f, "setupperbound($(colName), $(gms.fx[col]))\n")
        end
        if haskey(gms.l, col)
            write(f, "setvalue($(colName), $(gms.l[col]))\n")
        end
        if haskey(gms.prior, col)
            warning("Branching priority indicated in gms file. This behavior is solver dependent in JuMP. Consider implement them for exact gms instruction.")
        end
        if haskey(gms.scale, col)
            error("variable scaling applied in gms file. Don't know how to handle this one.")
        end
        if haskey(gms.stage, col)
            warning("Stage variable attribute indicated in gms file. Generic JuMP doesn't support his. Consider StructJuMP.jl for this implementation.")
        end
    end

    return
end

function separate_varseq(varseq::Vector)

    nameseq = []
    idxseq = []
    for i in varseq
        if match(r"\d+", i) == nothing
            push!(nameseq, i)
        else
            idx = convert(Int, parse(match(r"\d+", i).match))
            vname = match(r"[a-zA-Z]+", i).match
            push!(idxseq, (idx, vname))
        end
    end

    return chop_idx_seq(sort(idxseq)), nameseq
end

function chop_idx_seq(xidxs::Vector)

    if length(xidxs) == 1
        return [xidxs]
    end

    chop = []

    N = length(xidxs)
    num = 1
    cnt = 0
    for i in 2:N
        # Sequence break or variable name can cause a partition
        if xidxs[i][1] - xidxs[i-1][1] > 1 || xidxs[i][2] != xidxs[i-1][2]
            subseq = [xidxs[num:(i-1)];]
            push!(chop, subseq)
            num = i
        end
    end

    push!(chop, [xidxs[num:N];])

    return chop
end

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

function parse_varname(gms::oneProblem)

    if isempty(gms.vars)

        for varString in gms.cols
            varName = split(varString, r"\d+")[1]
            if varName != varString
                varSplit = split(varString, varName)
                varIndex = parse(varSplit[2])
                @assert isa(varIndex, Int)
                if !haskey(gms.vars, varName)
                    gms.vars[varName] = []
                end
                if varIndex in gms.vars[varName]
                    error("ERROR|gms2jump.jl|parse_varname()|Conflicting indice variable names")
                end
                push!(gms.vars[varName], varIndex)
                gms.cols2vars[varString] = parse(string(varName, "[",varIndex,"]"))
                gms.vars2cols[parse(string(varName,"[",varIndex,"]"))] = varString
            else
                if !haskey(gms.vars, varName)
                    gms.vars[varName] = 0
                else
                    error("ERROR|gms2jump.jl|parse_varname()|Conflicting symbolic variable names.")
                end
                gms.cols2vars[varString] = parse(varName)
                gms.vars2cols[parse(varName)] = varString
            end

        end
    else
        return 0
    end

    return
end

function clear_m_tester()
    cleanstring = "m_tester = Model()"
    eval(parse(cleanstring))
    return
end
