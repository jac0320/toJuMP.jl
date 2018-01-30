function read_mod_file(filepath::AbstractString)

    println("Reading $(filepath) ...")

    if isfile(filepath)
        f = open(filepath, "r")
    else
        error("No .mod file detected.")
    end

    skip = 0
    comment = 0
    parsed = 0
    consregion = false

    mod = oneProblem()

    for l in eachline(f)
        sl = lstrip(l, ' ')
        if isempty(sl) || length(sl) == 1  # Skip empty line
            skip += 1
        elseif l[1] == '#'
            comment += 1
        else
            slt = split(sl, r" |,")
            slt = [slt[i] for i in 1:length(slt) if length(slt[i]) > 0]
            if slt[1] == "var"
                @assert !consregion
                mod_read_var(f, mod, l)
            elseif slt[1] in ["minimize", "maximize"]
                @assert !consregion
                mod_read_objective(f, mod, l, string(slt[1]))
            elseif ismatch(r"e\d+:", slt[1])
                @assert consregion
                mod_read_equation(f, mod, l)
            elseif slt[1] == "subject"
                consregion = true
            end
            parsed += 1
        end
    end
    close(f)

    println("Finish reading mod file PARSED $(parsed) || COMMENT $(comment) || EMPTY $(skip)")

    return mod
end

function mod_read_var(file::IOStream, mod::oneProblem, lInit::AbstractString)

    one_l = get_one_line(file, one_line=lInit)
    one_l = replace(one_l, ",", " ")
    one_l = replace(one_l, ";", "")

    sl = split(one_l, " ")
    var = ""
    i = 1
    while i < length(sl)
        if sl[i] == "var"
            i += 1
            var = string(sl[i])
            push!(mod.cols, var)
        elseif sl[i] == "integer"
            @assert !isempty(var)
            mod.colsType[var] = "Integer"
        elseif sl[i] == "binary"
            @assert !isempty(var)
            mod.colsType[var] = "Binary"
        elseif sl[i] == ":="
            @assert !isempty(var)
            i += 1
            mod.l[var] = parse(sl[i])
        elseif sl[i] == ">="
            @assert !isempty(var)
            i += 1
            mod.lb[var] = parse(sl[i])
        elseif sl[i] == "<="
            @assert !isempty(var)
            i += 1
            mod.ub[var] = parse(sl[i])
        elseif isempty(sl[i])
            non = 0
        else
            error("Detected exception in variable line. $(i) - $(sl)")
        end
        i += 1
    end

    return
end

function mod_read_equation(file::IOStream, mod::oneProblem, lInit::AbstractString)

    #=
        Example Equation
        #Single Line
        e1:    objvar - x145 - x146 - x147 - x148 - x149 - x150 = 3271.22725820856;
        # Multi Line
        e38:    109.0495*x1 + 100.462*x2 + 115.2937*x3 + 2.860271*x4 + 15.1404*x5
               + x44 - x556 >= 101.1304;
    =#

	eN = string(strip(split(lInit, r" |,")[1], [':', '.', '\r', '\n']))
    eS = split(eN, '.')

    push!(mod.rows, "$(eN)")

    one_l = get_one_line(file, one_line=lInit)
    one_l = replace(one_l, "$(eN):", "")

    if contains(one_l, "<=")
        mod.rowsSense[eN] = "L"
    elseif contains(one_l, ">=")
        mod.rowsSense[eN] = "G"
    elseif contains(one_l, "=")
        mod.rowsSense[eN] = "E"
    else
        error("NO sense detected in equation $(eN). $(one_l)")
    end

    symbolexchange = Dict("E"=>"=", "L"=>"<=", "G"=>">=")
    sl = split(one_l, "$(symbolexchange[mod.rowsSense[eN]])", keep=false)
    mod.rowsLHS[eN] = replace(sl[1], " ", "")
    mod.rowsRHS[eN] = Float64(parse(sl[2]))

    return
end

function mod_read_objective(file::IOStream, mod::oneProblem, lInit::AbstractString, sense::AbstractString)

    sense == "maximize" ? mod.objSense = "maximizing" :  mod.objSense = "minimizing"

    one_l = get_one_line(file, one_line=lInit)
    one_l = replace(one_l, "minimize", "")
    one_l = replace(one_l, "obj", "")
    one_l = replace(one_l, ":", "")
    one_l = replace(one_l, " ", "")

    mod.objective = one_l

    return
end

function mod2jump(modPath::AbstractString; mode::AbstractString="index", ending="m=m", quadNL::Bool=false, outdir::AbstractString="")

    probName = replace(splitdir(modPath)[end], ".mod", "")
    mod = read_mod_file(modPath)
    write_julia_script(probName, mod, mode, quadNL=quadNL, outdir=outdir)

    return
end
