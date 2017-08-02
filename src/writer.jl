
function write_julia_script(juliaName::AbstractString, gms::oneProblem, mode="raw"; kwargs...)

    if mode == "index"
        parse_varname(gms)
        replace_vars(gms)
    end

    options = Dict(kwargs)

    if haskey(options, :stopat)
        stopat = options[:stopat]
    else
        stopat = "nostop"
    end

    info(" --------- Start writing Julia script ---------")
    filename = string(juliaName, ".jl")
    # if isfile(filename)
    #     info("This file exists. For safety reason, terminating now. Choose a different file name.")
    # else
        f = open(filename, "w")
    # end

    info("Writing headers...")
    write(f, string("using JuMP\n"))
    write(f, string("m = Model()\n"))

    write(f, string("\n\n# ----- Variables ----- #\n"))
    info("Writing variables...")
    if mode == "raw"
        for var in gms.cols
            if haskey(gms.colsType, var)
                if gms.colsType[var] == "Positive"
                    write(f, string("@variable(m, ",var ,">=0)\n"))
                elseif gms.colsType[var] == "Binary"
                    write(f, string("@variable(m, ",var ,", Bin)\n"))
                else
                    error("ERROR|gms2julia.jl|write_julia_script()|Unsupported variable type.")
                end
            else
                write(f, string("@variable(m, ",var ,")\n"))
            end
        end

    elseif mode == "index"
        for var in keys(gms.vars)
            if gms.vars[var] != 0
                write(f, string(var, "Idx = ", gms.vars[var], "\n"))
                write(f, string("@variable(m, ", var, "[",var ,"Idx]" ,")\n"))
            else
                write(f, string("@variable(m, ", var, ")\n"))
            end
        end

        for col in keys(gms.colsType)
            if gms.colsType[col] == "Binary"
                write(f, string("setCategory(", gms.cols2vars[col], ", :Bin)\n"))
            elseif gms.colsType[col] == "Positive"
                write(f, string("setlowerbound(", gms.cols2vars[col],", 0.0)\n"))
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
            write(f, string("setlowerbound(",colName ,"," , gms.lb[col],")\n"))
        end
        if haskey(gms.ub, col)
            write(f, string("setupperbound(",colName ,",", gms.ub[col],")\n"))
        end
    end

    if stopat == "variables"
        write(f, string("\n\n# ----- END ----- #"))
        info(" --------- Finish writing Julia script ---------")
        close(f)
        return 0
    end

    write(f, string("\n\n# ----- Constraints ----- #\n"))

    info("Writing Constraints...")
    for row in gms.rows
        if gms.rowsSense[row] == "E"
            gms.rowsLHS[row] = replace_oprs(gms.rowsLHS[row])
            write(f, string("@constraint(m, ",row, "," , gms.rowsLHS[row] ,"==",gms.rowsRHS[row] ,")\n"))
        elseif gms.rowsSense[row] == "L"
            gms.rowsLHS[row] = replace_oprs(gms.rowsLHS[row])
            write(f, string("@constraint(m, ",row, "," , gms.rowsLHS[row] ,"<=",gms.rowsRHS[row] ,")\n"))
        elseif gms.rowsSense[row] == "G"
            gms.rowsLHS[row] = replace_oprs(gms.rowsLHS[row])
            write(f, string("@constraint(m, ",row, "," , gms.rowsLHS[row] ,">=",gms.rowsRHS[row] ,")\n"))
        else
            error("ERROR|gms2julia.jl|write_julia_script()|Unkown sense type. (Unlikely)")
        end
    end

    write(f, string("\n\n# ----- Objective ----- #\n"))
    if mode == "raw"
        info("Writing objective section...")
        if gms.objSense == "maximizing"
            write(f, string("@objective(m, Max, ", gms.objVar,")\n"))
        elseif gms.objSense == "minimizing"
            write(f, string("@objective(m, Min, ", gms.objVar, ")\n"))
        else
            error("ERROR|gms2julia.jl|write_julia_script()|Unkown objective sense.")
        end
    else mode == "index"
        info("Writing objective section...")
        if gms.objSense == "maximizing"
            write(f, string("@objective(m, Max, ", gms.cols2vars[gms.objVar],")\n"))
        elseif gms.objSense == "minimizing"
            write(f, string("@objective(m, Min, ", gms.cols2vars[gms.objVar], ")\n"))
        else
            error("ERROR|gms2julia.jl|write_julia_script()|Unkown objective sense.")
        end
    end

    write(f, string("\n\n# ----- END ----- #"))
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
