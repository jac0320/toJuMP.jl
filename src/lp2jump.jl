function read_lp_file(filepath::AbstractString)

    error("Method not fully implemented.")

    println("Reading $(filepath) ...")

    if isfile(filepath)
        f = open(filepath, "r")
    else
        error("No .lp file detected.")
    end

    skip = 0
    comment = 0
    consregion = false
    foundsense = false

    lp = oneProblem()

    for l in eachline(f)
        sl = lstrip(l, ' ')
        if isempty(sl) || length(sl) == 1  # Skip empty line
            skip += 1
        elseif l[1] == '\\'
            comment += 1
        else
            # Main parsing procedure
            slt = split(sl, r" |,")
            slt = [slt[i] for i in 1:length(slt) if length(slt[i]) > 0]
            if lp_is_block_head(slt[1])
                nextblock = slt[1]
                while lp_is_end(nextblock) # Each file must ends with a END
                    # Read Objective Block
                    if lp_is_obj_block(nextblock)
                        lp_detect_sense(nextblock)
                        nextblock = lp_read_objective(f, lp)
                    end

                    # Read Constraints Block
                    if lp_is_cons_block(nextblock)
                        nextblock = lp_read_cons(f, lp)
                    end

                    # Read Bounds Block
                    if lp_is_bound_block(nextblock)
                        nextblock = lp_read_bound(f, lp)
                    end
                end
            end
        end
    end

    close(f)

    println("Finish reading mod file PARSED $(parsed) || COMMENT $(comment) || EMPTY $(skip)")

    return mod
end

function lp_is_cons_block(str::AbstractString)

    for i in CPLEX_CONS_CAP
        if ismatch(i, str)
            return true
        end
    end

    return false
end

function lp_read_cons(file::IOStream, lp::oneProblem)

    nx = ""

    # Parse the initial line
    l = readline(file)
    sl = lstrip(l, [' ', '\n'])
    slt = [i for i in split(sl, r" |,") if !isempty(i)]

    nx = slt[1]

    while !lp_is_block(nx)
        onecon = sl
        l = readline(file)
        if contains(l, ":")
            @assert contains(onecon, ":")
            oc_split = [i for i in split(onecon, r":|=|>=|<=") if !isempty(i)]  # r_name: lhs sense rhs
            @assert length(oc_split) = 3
            oc_name, oc_lhs, oc_rhs = onecon
            push!(m.rows, oc_name)
            m.rowsLHS[oc_name] = oc_lhs
            m.rowsRHS[oc_name] = oc_rhs
            if contains(onecon, "=")
                m.rowsSense = "E"
            elseif contains(onecon, ">=")
                m.rowsSense = "G"
            elseif contains(onecon, "<=")
                m.rowsSense = "L"
            end
            # TODO detect vars here for oc_lhs, oc_rhs
        else
            onecon = string(onecon, sl)
        end
        sl = lstrip(l, [' ', '\n'])
        slt = [i for i in split(sl, r" |,") if !isempty(i)] # Used to check block head
        isempty(slt) ? nx="" : nx=slt[1]
    end

    return nx
end

function lp_is_obj_block(str::AbstractString)

    for i in CPLEX_OBJ_HEAD
        if ismatch(i, str)
            return true
        end
    end

    return false
end

function lp_detect_sense(str::AbstractString, lp::oneProblem)

    for i in CPLEX_OBJ_HEAD
        if ismatch(i, str)
            contains(i.pattern, "MIN") ? m.objSense = "minimizing" : m.objSense = "maximizing"
        end
    end

    return
end

function lp_read_objective(file::IOStream, lp::oneProblem)

    obj = ""

    # Parse the initial line
    l = readline(file)
    sl = lstrip(l, [' ', '\n'])
    slt = [i for i in split(sl, r" |,") if !isempty(i)]

    nx = slt[1]

    while !lp_is_block(nx)
        obj = string(obj, sl)
        l = readline(file)
        sl = lstrip(l, [' ', '\n'])
        slt = [i for i in split(sl, r" |,") if !isempty(i)]
        isempty(slt) ? nx="" : nx=slt[1]
    end

    # sense has already been detected

    # string post-processing
    # NOTE: not preparing for super long floating number (length > 255)
    obj = replace(obj, "\n", " ")
    objsplit = split(obj, ':')
    @assert length(objsplit) == 2
    mod.objname = objsplit[1]
    mod.objective = objsplit[2]

    # TODO : search for variables

    return nx
end

function lp_is_bound_block(str::AbstractString)

    for i in CPLEX_BOUND_HEAD
        if ismatch(i, str)
            return true
        end
    end

    return false
end

function lp_read_bound(file::IOStream, lp::oneProblem)

    # each bound is a new line
    # default lower bound of 0 (zero) and the default upper bound of +∞ remaining in effect until the bound is explicitly changed.

    nx = ""

    # Parse the initial line
    l = readline(file)
    sl = lstrip(l, [' ', '\n'])
    slt = [i for i in split(sl, r" |,") if !isempty(i)]

    nx = slt[1]

    while !lp_is_block(nx)
        bound = sl # each line should contain a bound information

        if ismatch(r"\w+\s*free"i, bound) # parse bound through matching patterns
            varname, freestr = [i for i in split(bound, ' ') if !isempty(i)]
            @assert haskey(m.cols, varname)
            lp.lb[varname] = -Inf
            lp.ub[varname] = Inf
        elseif ismatch(r"\w+\s*=\s*\d+[.]?\d+", bound)  # x = bound
            varname, varfx = [i for i in split(bound, '=') if !isempty(i)]
            @assert haskey(m.cols, varname)
            lp.lb[varname] = parse(varfx)
            lp.ub[varname] = parse(varfx)
        elseif ismatch(r"\d+[.]?\d+\s*<=\s*\w+\s*<=\s*\d+[.]?\d+", bound)  # lb <= x <= ub
            varlb, varname, varub = [i for i in split(bound, "<=") if !isempty(i)]
            @assert haskey(m.cols, varname)
            lp.lb[varname] = parse(varlb)
            lp.ub[varname] = parse(varub)
        elseif ismatch(r"\w+\s*<=\s*\d+[.]?\d+", bound) # x <= ub
            varname, varub = [i for i in split(bound, "<=") if !isempty(i)]
            @assert haskey(m.cols, varname)
            lp.ub[varname] = parse(varub)
        elseif ismatch(r"\d+[.]?\d+\s*<=\s*\w+\s*", bound) # lb <= x
            varlb, varname = [i for i in split(bound, "<=") if !isempty(i)]
            @assert haskey(m.cols, varname)
            lp.lb[varname] = parse(varlb)
        elseif ismatch(r"\w+\s*<=\s*[+]?\s*(infinity|inf)"i, bound) # x <= + ∞
            varname, varinf = [i for i in split(bound, "<=") if !isempty(i)]
            @assert haskey(m.cols, varname)
            lp.ub[varname] = Inf
        elseif ismatch(r"[-]?\s*(infinity|inf)\s*<=\s*\w+\s*"i, bound)  # - ∞ <= x
            varinf, varname = [i for i in split(bound, "<=") if !isempty(i)]
            @assert haskey(m.cols, varname)
            lp.lb[varname] = -Inf
        elseif ismatch(r"[-]\s*(infinity|inf)\s*<=\s*\w+\s*<=\s*[+]\s*(infinity|inf)"i, bound) # - ∞ <= x <= + ∞
            varinf, varname, varinf = [i for i in split(bound, "<=") if !isempty(i)]
            @assert haskey(m.cols, varname)
            lp.lb[varname] = -Inf
            lp.ub[varname] = Inf
        else
            error("Unexpected pattern $(bound)")
        end

        l = readline(file)
        sl = lstrip(l, [' ', '\n'])
        slt = [i for i in split(sl, r" |,") if !isempty(i)] # Used to check block head
        isempty(slt) ? nx="" : nx=slt[1]
    end

    return nx
end

function lp_parse_variable(l::AbstractString, lp::oneProblem)

    # Linear search to detect variables
    ls = lstrip(l, [' ', '\n'])
    slt = [i for i in split(sl, " ") if isempty(i)]
    for i in slt
        if ismatch(r"[a-zA-Z!\"#$%&(),.;?@_‘’{}~][a-zA-Z0-9!\"#$%&(),.;?@_‘’{}~]+", i)

        end
    end

    return
end

function lp_is_block(str::AbstractString)

    for i in CPLEX_BLOCK_HEAD
        ismatch(i, str) && return true
    end

    return false
end

function lp_is_end(str::AbstractString)

    for i in CPLEX_END
        ismatch(i, str) & return true
    end

    return false
end
