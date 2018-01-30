using Compat

type moddata
    objsense::Symbol
    objective::AbstractString
    constraints::Vector{Any}
    constrlabel::Vector{Any}
    variables::Vector{Any}
    l::Vector{Float64}
    u::Vector{Float64}
    s::Vector{Float64}
    vartype::Vector{Symbol}
end

function indexOf(string1, string2)
    for i = 1:length(string1)-length(string2)+1
        if string1[i:i+length(string2)-1] == string2
            return i
        end
    end
    return 0
end

function read_mod_file(filename::AbstractString)

    info("Reading $(filename) ...")

    filepath = joinpath(Pkg.dir("toJuMP"),".mod","")
    filepath = string(filepath,filename,".mod")

    if isfile(filepath)
        f = open(filepath, "r")
    elseif isfile(filename)
        f = open(filename, "r")
    else
        error("No gms file detected.")
    end

    file = open(filename, "r")

    mod = oneProblem

    linestart = Any[]
    lines = readlines(file)
    newlines = Any[]
    for line in lines
        if length(line) > 1
            if line[1] == ' '
                push!(linestart, false)
            else
                push!(linestart, true)
            end
            push!(newlines, line)
        end
    end
    lines = newlines
    filecontent = Any[]
    k = 0
    while k+1 <= length(lines)
        k += 1
        currline = lines[k]
        while k+1 <= length(lines) && !linestart[k+1]
            currline = string(currline[1:end-1], lines[k+1])
            k += 1
        end
        push!(filecontent, currline[1:end-1])
    end
    close(file)

    modcontents = moddata(:Min, "", [], [], [], [], [], [], [])
    for line in filecontent
        if line[1] != '#'
            if line[1:3] == "var"
                elements = split(line)
                label = elements[2]
                s = 0.0
                l = -Inf
                u = Inf
                vartype = :Cont
                for (k, element) in enumerate(elements)
                    if element == "binary"
                        vartype = :Bin
                    end
                    if element == "integer"
                        vartype = :Int
                    end
                    if element == ":="
                        s = elements[k+1][1:end-1]
                    end
                    if element == ">="
                        l = elements[k+1][1:end-1]
                    end
                    if element == "<="
                        u = elements[k+1][1:end-1]
                    end
                end
                label = replace(label, ";", "")
                push!(modcontents.variables, label)
                push!(modcontents.s, float(s))
                push!(modcontents.l, float(l))
                push!(modcontents.u, float(u))
                push!(modcontents.vartype, vartype)
                #println("var $label, $s, $l, $u")
            end
            if line[1:3] == "min"
                modcontents.objective = line[15:end-1]
            elseif line[1:3] == "max"
                modcontents.objsense = :Max
                modcontents.objective = line[15:end-1]
            end
            if line[1] == 'e' || line[1] == 'l' || line[1] == 'g'
                elements = split(line)
                constraint = line[length(elements[1])+1:end-1]
                @show constraint
                push!(modcontents.constraints, constraint)
                push!(modcontents.constrlabel, elements[1])
            end
        end
    end
    for j in 1:length(modcontents.constraints)
            modcontents.constraints[j] = replace(
                modcontents.constraints[j],
                " ", "")
    end
    for j in 1:length(modcontents.constraints)
    modcontents.constraints[j] = replace(
                modcontents.constraints[j],
                "**", "^")
        ind1 = indexOf(modcontents.constraints[j],"<=")
        ind2 = indexOf(modcontents.constraints[j],">=")
        if ind1 == 0 && ind2 == 0
            modcontents.constraints[j] = replace(
                modcontents.constraints[j],
                "=", " ==")
        end
    end
    modcontents.objective = replace(
                modcontents.objective,
                "**", "^")

    numVar = length(modcontents.variables)
    numConstr = length(modcontents.constraints)

    vardict = Dict{String,Int}()
    for i = 1:numVar
        vardict[modcontents.variables[i]] = i
    end

    for i = numVar:-1:1
        modcontents.objective = replace(
            modcontents.objective,
            modcontents.variables[i], "x[$(vardict[modcontents.variables[i]])]")
        for j = 1:numConstr
            @show modcontents.variables[i]
            modcontents.constraints[j] = replace(
                modcontents.constraints[j],
                modcontents.variables[i], "x[$(vardict[modcontents.variables[i]])]")
        end
    end

    problem_call = open("jump_mod_file.jl","w")
    write(problem_call, "using JuMP\n")
    write(problem_call, "m = Model()\n")
    write(problem_call, "@defVar(m, x[1:$numVar])\n")
    for i in 1:numVar
        if modcontents.vartype[i] == :Bin ||
           modcontents.vartype[i] == :Int
            write(problem_call, "setCategory(x[$i], $(modcontents.vartype[i]))\n")
        end
    end

    write(problem_call, "@setObjective(m,")
    if (modcontents.objsense == :Min)
        write(problem_call, "Min,")
    else
        write(problem_call, "Max,")
    end
    write(problem_call, "$(modcontents.objective))\n")
    for i in 1:numConstr
        write(problem_call, "@addConstraint(m, $(modcontents.constraints[i]))  #= $(modcontents.constrlabel[i]) =#\n")  #
    end
    for i in 1:numVar
        if modcontents.l[i] > -Inf
            write(problem_call, "@addConstraint(m, x[$(vardict[modcontents.variables[i]])] >= $(modcontents.l[i]))\n")
        end
        if modcontents.u[i] < Inf
            write(problem_call, "@addConstraint(m, x[$(vardict[modcontents.variables[i]])] <= $(modcontents.u[i]))\n")
        end
    end
    close(problem_call)
end
#
# if length(ARGS) != 1
#     error("Usage: julia read_mod.jl filename")
# end
#
# file_name = String(ARGS[1])
#
# read_mod_file(file_name)
