function read_gms_file(filename::AbstractString)

    info("Reading .gms file ...")

    filepath = joinpath(Pkg.dir("MINLPLib_jump"),".gms","")
    filepath = string(filepath,filename,".gms")
    @show filepath
    if isfile(filepath)
        f = open(filepath, "r")
    else
        error("No gms file detected.")
    end

    #=
        ----------------------- Line Header Space ------------------
            Example :: 4stufen.gms
        Unkown ::
        $offlisting
        $if set nostart $goto modeldef
        $label modeldef
        $if not set MINLP $set MINLP MINLP  Model Type

        *                 -> comment
        Null              -> emptyline
        Variables         -> All Variable List, separated by ","
        Positive Variable -> Non-negative variables list, separated by "," (assert)
        Binary Variable   -> Binary variables list, separated by "," (assert)
        Equations         -> Equations symbols, separated by ","
        EquSymbols..      -> Equation content
        VarSymbols.lo     -> Lower Bound
        VarSymbols.l      -> Upper Bound ??
        Model m / all /   -> ??
        m.limrow=0
        m.
        ------------------------------------------------------------
    =#

    # Null Trackers
    skip = 0
    comment = 0

    # Main data structure initialization
    gms = oneProblem()

    # -------------------------- Start Reading -------------------------- #
    for l in eachline(f)

        sl = lstrip(l, ' ')
        if isempty(sl) || length(sl) == 1  # Skip empty line
            skip += 1
        elseif sl[1] == "*"
            comment += 1
        else
            slt = split(sl, r" |,|\.")
            slt = [slt[i] for i in 1:length(slt) if length(slt[i]) > 0]
            if slt[1] in BLOCK_HEADER
                read_block(f, gms, l)           # Reading a general block
            elseif slt[1] in gms.rows #ismatch(r"e\d", sl[1])
                read_equation(f, gms, l)        # Reading an equation block
            elseif slt[1] in gms.cols #ismatch(r"\w\.\w", sl[1])
                read_bounds(f, gms, l)          # Reading a bound block
            elseif slt[1] == "\$"
                read_command(f, gms, l)         # Reading a logical command line
            elseif slt[1] == "Model"
                read_model(f, gms, sl)           # Reading a model command
            elseif slt[1] == "Solve"
                read_solve(f, gms, sl)           # Reading a solve command line
            else
                # println("[Unkown]DUMPING >> ", l)
            end
        end

    end
    close(f)

    return gms
end

function read_block(file::IOStream, gms::oneProblem, lInit::AbstractString; kwargs...)

    sl = split(get_one_line(file, one_line=lInit), r" |,")
    sl = [sl[i] for i in 1:length(sl) if !isempty(sl[i])]  # Eliminate empty entries

    blockIdentifier = sl[1]  # This should always be true

    for i in 1:length(sl)
        if blockIdentifier == "Variables" && (i > 1)
            push!(gms.cols, sl[i])
        elseif blockIdentifier == "Positive" && (i > 2)
            gms.colsType[sl[i]] = "Positive"
        elseif blockIdentifier == "Binary" && (i > 2)
            gms.colsType[sl[i]] = "Binary"
        elseif blockIdentifier == "Integer" && (i > 2)
            gms.colsType[sl[i]] = "Integer"
        elseif blockIdentifier == "Equations" && (i > 1)
            push!(gms.rows, sl[i])
        end
    end

    return
end

function read_equation(file::IOStream, gms::oneProblem, lInit::AbstractString; kwargs...)

    #=
        Example Equation
        #Single Line
        e1..    objvar - x145 - x146 - x147 - x148 - x149 - x150 =E= 3271.22725820856;
        # Multi Line
        e38..    109.0495*x1 + 100.462*x2 + 115.2937*x3 + 2.860271*x4 + 15.1404*x5
               + x44 - x556 =E= 101.1304;
    =#

    lhs = ""
    rhs = ""
    sense = ""
    eName = string(strip(split(lInit, r" |,")[1], '.'))
    if eName in gms.rows   # TODO: This extra assertion can be elimated
        one_l = get_one_line(file, one_line=lInit)
        sl = split(one_l, r" |,|=", keep=false)
        sl = [sl[i] for i in 1:length(sl) if !isempty(sl[i])]  # Eliminate empty entries
        i = 2 # Default starting position for equations
        while true # Concatenate the parsed elements
            (i > length(sl)) && break # Multi-line expression
            if sl[i] in ["E", "L", "G"] && isempty(sense)
                sense = sl[i]
                gms.rowsSense[eName] = sense    # Storing raw sense character
                i = i + 1
            elseif sl[i] in ["E", "L", "G"] && !isempty(sense)
                error("Already detected sense for this equation")
                i = i + 1
            elseif !(sl[i] in ["E", "L", "G"]) && isempty(sense)
                lhs = string(lhs, sl[i])
                gms.rowsLHS[eName] = lhs
                i = i + 1
            else    # Implication
                rhs = Float64(parse(sl[i]))
                # A weak assertion :: eqach equation (stripped) ends with rhs
                @assert i == length(sl)
                gms.rowsRHS[eName] = rhs
                break
            end
        end
    else
        error("Non-indexed constraint detected.\n$(lInit)")
    end

    return
end

function read_bounds(file::IOStream, gms::oneProblem, lInit::AbstractString; kwargs...)

    #=
        .lo lower bound
        .l level or primal value
        .up upper bound
        .m marginal or dual value
    =#
    @assert rstrip(strip(lInit, '\n'), ' ')[end] == ';' # Assumption :: alwasy one line
    all_segs = split(lInit, ';', keep=false)
    all_segs = [i for i in all_segs if !isempty(strip(i,' '))]
    for lseg in all_segs
        lseg = strip(lseg, [';', '\n', ' '])
        sl = split(lseg, " ")
        sl = [sl[i] for i in 1:length(sl) if !isempty(sl[i])]
        # There shouldn't be any space to begin with
        @assert ismatch(r"\w.\w", sl[1])
        boundVal = Float64(parse(sl[end]))
        var = split(sl[1],".")[1]
        attr = split(sl[1],".")[2]

        if attr == "lo"
            gms.lb[var] = boundVal
        elseif attr == "l"
            gms.l[var] = boundVal
        elseif attr == "fx"
            gms.fx[var] = boundVal
        elseif attr == "up"
            gms.ub[var] = boundVal
        elseif attr == "m"
            gms.m[var] = boundVal
        end
    end

    return
end

function read_model(file::IOStream, gms::oneProblem, lInit::AbstractString; kwargs...)

    # Assume this will always be one line
    @assert strip(lInit, '\n')[end] == ';'
    sl = split(strip(lInit,[';','\n']), r" |,")
    @assert sl[1] == "Model"  # Already did outside
    # Not sure if the information stored here is useful or not.
    for i in 1:length(sl)
        if sl[i] == "Model"
            gms.modelSymbol = sl[i+1]
        end
    end

    return
end

function read_solve(file::IOStream, gms::oneProblem, lInit::AbstractString; kwargs...)

    @assert strip(lInit, '\n')[end] == ';'

    sl = split(strip(lInit, [';','\n']), r" |,")
    @assert sl[1] == "Solve"

    for i in 1:length(sl)
        if sl[i] in PROBTYPE
            gms.modelType = sl[i]
        elseif sl[i] == "maximizing"
            gms.objSense = sl[i]
        elseif sl[i] == "minimizing"
            gms.objSense = sl[i]
        elseif sl[i] in gms.cols
            gms.objVar = sl[i]
        end
    end
end

function write_julia_script(juliaName::AbstractString, gms::oneProblem, mode="index"; kwargs...)

    if mode == "index"
        parse_varname(gms)
        replace_vars(gms)
    end

    options = Dict(kwargs)

    info(" --------- Start writing Julia script ---------")
    !isdir("$(Pkg.dir())/MINLPLib_jump/.jls/fgms") && mkdir("$(Pkg.dir())/MINLPLib_jump/.jls/fgms")
    filepath = joinpath(Pkg.dir("MINLPLib_jump"),".jls/fgms","")
    filepath = string(filepath, juliaName,".jl")
    f = open(filepath, "w")

    info("Writing headers...")
    write(f, "using JuMP\n\n")
    write(f, "\tm = Model()\n")

    write(f, "\n\t# ----- Variables ----- #\n")
    info("Writing variables...")
    if mode == "raw"
        for var in gms.cols
            if haskey(gms.colsType, var)
                if gms.colsType[var] == "Positive"
                    write(f, "\t@variable(m, $(var)>=0)\n")
                elseif gms.colsType[var] == "Binary"
                    write(f, "\t@variable(m, $(var), Bin)\n")
                elseif gms.colsType[var] == "Integer"
                    write(f, "\t@variable(m, $(var), Int)\n")
                else
                    error("ERROR|gms2julia.jl|write_julia_script()|Unsupported variable type.")
                end
            else
                write(f, "\t@variable(m, $(var))\n")
            end
        end
    elseif mode == "index"
        for var in keys(gms.vars)
            if gms.vars[var] != 0
                write(f, "\t$(var)_Idx = $(gms.vars[var])\n")
                write(f, "\t@variable(m, $(var)[$(var)_Idx])\n")
                vs = "@variable(m_tester, $(var)[$(gms.vars[var])])"
                eval(parse(vs))
            else
                write(f, "\t@variable(m, $(var))\n")
                vs = "@variable(m_tester, $(var))"
                eval(parse(vs))
            end
        end
        for col in keys(gms.colsType)
            if gms.colsType[col] == "Binary"
                write(f, "\tsetcategory($(gms.cols2vars[col]), :Bin)\n")
            elseif gms.colsType[col] == "Integer"
                write(f, "\tsetcategory($(gms.cols2vars[col]), :Int)\n")
            elseif gms.colsType[col] == "Positive"
                write(f, "\tsetlowerbound($(gms.cols2vars[col]), 0.0)\n")
            else
                error("ERROR|gms2julia.jl|write_julia_script()|Unsupported variable type.")
            end
        end
    end

    info("Writing variables' bounds...")
    for col in gms.cols
        if mode == "raw"
            colName = col
        elseif mode == "index"
            colName = gms.cols2vars[col]
        end
        if haskey(gms.lb, col)
            write(f, "\tsetlowerbound($(colName), $(gms.lb[col]))\n")
        end
        if haskey(gms.ub, col)
            write(f, "\tsetupperbound($(colName), $(gms.ub[col]))\n")
        end
        if haskey(gms.fx, col)
            write(f, "\tsetlowerbound($(colName), $(gms.fx[col]))\n")
            write(f, "\tsetupperbound($(colName), $(gms.fx[col]))\n")
        end
    end

    write(f, string("\n\n\t# ----- Constraints ----- #\n"))

    info("Writing Constraints...")
    for row in gms.rows
        if gms.rowsSense[row] == "E"
            gms.rowsLHS[row] = replace_oprs(gms.rowsLHS[row])
            if try_iflinear("\t@constraint(m_tester, $(row), $(gms.rowsLHS[row]) == $(gms.rowsRHS[row]))\n")
                write(f, "\t@constraint(m, $(row), $(gms.rowsLHS[row]) == $(gms.rowsRHS[row]))\n")
            else
                write(f, "\t@NLconstraint(m, $(row), $(gms.rowsLHS[row]) == $(gms.rowsRHS[row]))\n")
            end
        elseif gms.rowsSense[row] == "L"
            gms.rowsLHS[row] = replace_oprs(gms.rowsLHS[row])
            if try_iflinear("\t@constraint(m_tester, $(row), $(gms.rowsLHS[row]) <= $(gms.rowsRHS[row]))\n")
                write(f, "\t@constraint(m, $(row), $(gms.rowsLHS[row]) <= $(gms.rowsRHS[row]))\n")
            else
                write(f, "\t@NLconstraint(m, $(row), $(gms.rowsLHS[row]) <= $(gms.rowsRHS[row]))\n")
            end
        elseif gms.rowsSense[row] == "G"
            gms.rowsLHS[row] = replace_oprs(gms.rowsLHS[row])
            if try_iflinear("\t@constraint(m_tester, $(row), $(gms.rowsLHS[row]) >= $(gms.rowsRHS[row]))\n")
                write(f, "\t@constraint(m, $(row), $(gms.rowsLHS[row]) >= $(gms.rowsRHS[row]))\n")
            else
                write(f, "\t@NLconstraint(m, $(row), $(gms.rowsLHS[row]) >= $(gms.rowsRHS[row]))\n")
            end
        else
            error("ERROR|gms2julia.jl|write_julia_script()|Unkown sense type. (Unlikely)")
        end
    end

    write(f, string("\n\n\t# ----- Objective ----- #\n"))
    if mode == "raw"
        info("Writing objective section...")
        if gms.objSense == "maximizing"
            write(f, "\t@objective(m, Max, $(gms.objVar))\n")
        elseif gms.objSense == "minimizing"
            write(f, "\t@objective(m, Min, $(gms.objVar))\n")
        else
            error("ERROR|gms2julia.jl|write_julia_script()|Unkown objective sense.")
        end
    else mode == "index"
        info("Writing objective section...")
        if gms.objSense == "maximizing"
            write(f, "\t@objective(m, Max, $(gms.cols2vars[gms.objVar]))\n")
        elseif gms.objSense == "minimizing"
            write(f, "\t@objective(m, Min, $(gms.cols2vars[gms.objVar]))\n")
        else
            error("ERROR|gms2julia.jl|write_julia_script()|Unkown objective sense.")
        end
    end

    write(f, "m = m\n")
    info(" --------- Finish writing Julia script ---------")
    close(f)

    return 0
end

"""
    Takes .gms variable name like "\w+\d+" and get the both part
"""
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
                    error("ERROR|gms2julia.jl|parse_varname()|Conflicting indice variable names")
                end
                push!(gms.vars[varName], varIndex)
                gms.cols2vars[varString] = parse(string(varName, "[",varIndex,"]"))
                gms.vars2cols[parse(string(varName,"[",varIndex,"]"))] = varString
            else
                if !haskey(gms.vars, varName)
                    gms.vars[varName] = 0
                else
                    error("ERROR|gms2julia.jl|parse_varname()|Conflicting symbolic variable names.")
                end
                gms.cols2vars[varString] = parse(varName)
                gms.vars2cols[parse(varName)] = varString
            end

        end
    else
        return 0
    end
end

function gms2julia(gmsName::AbstractString, juliaName::AbstractString="", mode::AbstractString="index"; kwargs...)
    isempty(juliaName) && (juliaName = gmsName)
    gms = read_gms_file(gmsName)
    write_julia_script(juliaName, gms, mode)
end
