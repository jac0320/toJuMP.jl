function write_julia_script(juliaName::AbstractString, p::oneProblem, mode="index";
                            ending="m=m",
                            quadNL=false,
                            outdir="",
                            loopifpossible=true,
                            kwargs...)

    if mode == "index"
        parse_varname(p)
        replace_vars(p)
    end

    options = Dict(kwargs)
    clear_m_tester()

    println(" --------- Start writing Julia script ---------")
    isempty(outdir) ? filedir = joinpath(Pkg.dir("toJuMP"),".jls") : filedir = outdir
	f = open("$(filedir)/$(juliaName).jl", "w")

    println("Writing headers...")
    write(f, "using JuMP\n\n")
    write(f, "m = Model()\n")

    write(f, "\n# ----- Variables ----- #\n")
    println("Writing variables...")
    if mode == "raw"
        for var in p.cols
            if haskey(p.colsType, var)
                if p.colsType[var] == "Positive"
                    write(f, "@variable(m, $(var)>=0)\n")
                elseif p.colsType[var] == "Negative"
                    write(f, "@variable(m, $(var)<=0)\n")
                elseif p.colsType[var] == "Binary"
                    write(f, "@variable(m, $(var), Bin)\n")
                elseif p.colsType[var] == "Integer"
                    write(f, "@variable(m, $(var), Int)\n")
                else
                    error("ERROR|gms2jump.jl|write_julia_script()|Unsupported variable type.")
                end
            else
                write(f, "\t@variable(m, $(var))\n")
            end
        end
    elseif mode == "index"
        for var in keys(p.vars)
            if p.vars[var] != 0
                write(f, "$(var)_Idx = $(p.vars[var])\n")
                write(f, "@variable(m, $(var)[$(var)_Idx])\n")
                vs = "@variable(m_tester, $(var)[$(p.vars[var])])"
                eval(parse(vs))
            else
                write(f, "@variable(m, $(var))\n")
                vs = "@variable(m_tester, $(var))"
                eval(parse(vs))
            end
        end
        if loopifpossible
            write_varattr(f, p.colsType, p, "Binary", ":Bin", "setcategory")
            write_varattr(f, p.colsType, p, "Integer", ":Int", "setcategory")
            write_varattr(f, p.colsType, p, "Positive", "0.0", "setlowerbound")
            write_varattr(f, p.colsType, p, "Negative", "0.0", "setupperbound")
        else
            for col in keys(p.colsType)
                if p.colsType[col] == "Binary"
                    write(f, "setcategory($(p.cols2vars[col]), :Bin)\n")
                elseif p.colsType[col] == "Integer"
                    write(f, "setcategory($(p.cols2vars[col]), :Int)\n")
                elseif p.colsType[col] == "Positive"
                    write(f, "setlowerbound($(p.cols2vars[col]), 0.0)\n")
                elseif p.colsType[col] == "Negative"
                    write(f, "setupperbound($(p.cols2vars[col]), 0.0)\n")
                else
                    error("ERROR|gms2jump.jl|write_julia_script()|Unsupported variable type.")
                end
            end
        end
    end

    println("Writing variables attributes...")
    if loopifpossible && mode == "index"
        write_varattr(f, p.lb, p, "setlowerbound")
        write_varattr(f, p.ub, p, "setupperbound")
        write_varattr(f, p.fx, p, ["setlowerbound", "setupperbound"])
        write_varattr(f, p.l, p, "setvalue")
    else
        write_enumerate_varattr(f, p, mode)
    end

    println("Writing Constraints...")
    write(f, string("\n\n# ----- Constraints ----- #\n"))
    for row in p.rows
        if p.rowsSense[row] == "E"
            p.rowsLHS[row] = replace_oprs(p.rowsLHS[row])
            if try_iflinear("@constraint(m_tester, $(p.rowsLHS[row]) == $(p.rowsRHS[row]))\n", quadNL)
                write(f, "@constraint(m, $(row), $(p.rowsLHS[row]) == $(p.rowsRHS[row]))\n")
            else
                write(f, "@NLconstraint(m, $(row), $(p.rowsLHS[row]) == $(p.rowsRHS[row]))\n")
            end
        elseif p.rowsSense[row] == "L"
            p.rowsLHS[row] = replace_oprs(p.rowsLHS[row])
            if try_iflinear("@constraint(m_tester, $(p.rowsLHS[row]) <= $(p.rowsRHS[row]))\n", quadNL)
                write(f, "@constraint(m, $(row), $(p.rowsLHS[row]) <= $(p.rowsRHS[row]))\n")
            else
                write(f, "@NLconstraint(m, $(row), $(p.rowsLHS[row]) <= $(p.rowsRHS[row]))\n")
            end
        elseif p.rowsSense[row] == "G"
            p.rowsLHS[row] = replace_oprs(p.rowsLHS[row])
            if try_iflinear("@constraint(m_tester, $(p.rowsLHS[row]) >= $(p.rowsRHS[row]))\n", quadNL)
                write(f, "@constraint(m, $(row), $(p.rowsLHS[row]) >= $(p.rowsRHS[row]))\n")
            else
                write(f, "@NLconstraint(m, $(row), $(p.rowsLHS[row]) >= $(p.rowsRHS[row]))\n")
            end
		elseif p.rowsSense[row] == "N"
            p.rowsLHS[row] = replace_oprs(p.rowsLHS[row])
            write(f, "#@constraint(m, $(row), $(p.rowsLHS[row]) =N= $(p.rowsRHS[row]))\n")
        else
            error("ERROR|gms2jump.jl|write_julia_script()|Unkown sense type. (Unlikely)")
        end
    end

    write(f, string("\n\n# ----- Objective ----- #\n"))
    if mode == "raw"
        println("Writing objective section...")
        addNL = try_iflinear("@objective(m_tester, Max, $(p.objective))\n")
        if p.objSense == "maximizing"
            addNL ? write(f, "@NLobjective(m, Max, $(p.objective))\n\n") : write(f, "@objective(m, Max, $(p.objective))\n\n")
        elseif p.objSense == "minimizing"
            addNL ? write(f, "@NLobjective(m, Min, $(p.objective))\n\n") : write(f, "@objective(m, Min, $(p.objective))\n\n")
        else
            error("ERROR|gms2jump.jl|write_julia_script()|Unkown objective sense.")
        end
    else mode == "index"
        if haskey(p.cols2vars, p.objective)
            println("Writing objective section...")
            addNL = try_iflinear("@objective(m_tester, Max, $(p.cols2vars[p.objective]))\n")
            if p.objSense == "maximizing"
                addNL ? write(f, "@objective(m, Max, $(p.cols2vars[p.objective]))\n\n") : write(f, "@NLobjective(m, Max, $(p.cols2vars[p.objective]))\n\n")
            elseif p.objSense == "minimizing"
                addNL ? write(f, "@objective(m, Min, $(p.cols2vars[p.objective]))\n\n") : write(f, "@NLobjective(m, Min, $(p.cols2vars[p.objective]))\n\n")
            else
                error("ERROR|gms2jump.jl|write_julia_script()|Unkown objective sense.")
            end
        else
            println("Writing objective section...")
            p.objective = replace_oprs(p.objective)
            addNL = try_iflinear("@objective(m_tester, Max, $(p.objective))\n")
            if p.objSense == "maximizing"
                addNL ? write(f, "@objective(m, Max, $(p.objective))\n\n") : write(f, "@NLobjective(m, Max, $(p.objective))\n\n")
            elseif p.objSense == "minimizing"
                addNL ? write(f, "@objective(m, Min, $(p.objective))\n\n") : write(f, "@NLobjective(m, Min, $(p.objective))\n\n")
            else
                error("ERROR|gms2jump.jl|write_julia_script()|Unkown objective sense.")
            end
        end
    end

    write(f, "# == Ending section == #\n")
    write(f, "$(ending) \n")
    println(" --------- Finish writing Julia script ---------")
    close(f)

    return 0
end
