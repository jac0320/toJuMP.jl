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
            slt = split(sl, r" |,")
            slt = [slt[i] for i in 1:length(slt) if length(slt[i]) > 0]
            if lp_is_block_head(slt[1])
                nextblock = slt[1]
                while lp_is_end(nextblock)
                    # Read Objective Function
                    if lp_is_obj_block(nextblock)
                        lp_detect_sense(nextblock)
                        nextblock = lp_read_objective(f, lp)
                    end

                    # Read Constraints
                    if lp_is_cons_block(nextblock)
                        nextblock = lp_read_cons(f, lp)
                    end

                    # Read Bounds
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

    nextblock = ""

    return nextblock
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
            if contains(i.pattern, "MIN")
                m.objSense = "minimizing"
            else
                m.objSense = "maximizing"
            end
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

    nextblock = ""

    return nextblock
end

function lp_is_block(str::AbstractString)

    for i in CPLEX_BLOCK_HEAD
        if ismatch(i, str)
            return true
        end
    end

    return false
end

function lp_is_end(str::AbstractString)

    for i in CPLEX_END
        if ismatch(i, str)
            return true
        end
    end

    return false
end
