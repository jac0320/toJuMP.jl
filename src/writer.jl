function write_julia_script(juliaName::AbstractString, gms::oneProblem, mode="index";
                            ending="m=m",
                            quadNL=false,
                            outdir="",
                            loopifpossible=true,
                            kwargs...)

    if mode == "index"
        parse_varname(gms)
        replace_vars(gms)
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
        for var in gms.cols
            if haskey(gms.colsType, var)
                if gms.colsType[var] == "Positive"
                    write(f, "@variable(m, $(var)>=0)\n")
                elseif gms.colsType[var] == "Negative"
                    write(f, "@variable(m, $(var)<=0)\n")
                elseif gms.colsType[var] == "Binary"
                    write(f, "@variable(m, $(var), Bin)\n")
                elseif gms.colsType[var] == "Integer"
                    write(f, "@variable(m, $(var), Int)\n")
                else
                    error("ERROR|gms2jump.jl|write_julia_script()|Unsupported variable type.")
                end
            else
                write(f, "\t@variable(m, $(var))\n")
            end
        end
    elseif mode == "index"
        for var in keys(gms.vars)
            if gms.vars[var] != 0
                write(f, "$(var)_Idx = $(gms.vars[var])\n")
                write(f, "@variable(m, $(var)[$(var)_Idx])\n")
                vs = "@variable(m_tester, $(var)[$(gms.vars[var])])"
                eval(parse(vs))
            else
                write(f, "@variable(m, $(var))\n")
                vs = "@variable(m_tester, $(var))"
                eval(parse(vs))
            end
        end
        if loopifpossible
            write_varattr(f, gms.colsType, gms, "Binary", ":Bin", "setcategory")
            write_varattr(f, gms.colsType, gms, "Integer", ":Int", "setcategory")
            write_varattr(f, gms.colsType, gms, "Positive", "0.0", "setlowerbound")
            write_varattr(f, gms.colsType, gms, "Negative", "0.0", "setupperbound")
        else
            for col in keys(gms.colsType)
                if gms.colsType[col] == "Binary"
                    write(f, "setcategory($(gms.cols2vars[col]), :Bin)\n")
                elseif gms.colsType[col] == "Integer"
                    write(f, "setcategory($(gms.cols2vars[col]), :Int)\n")
                elseif gms.colsType[col] == "Positive"
                    write(f, "setlowerbound($(gms.cols2vars[col]), 0.0)\n")
                elseif gms.colsType[col] == "Negative"
                    write(f, "setupperbound($(gms.cols2vars[col]), 0.0)\n")
                else
                    error("ERROR|gms2jump.jl|write_julia_script()|Unsupported variable type.")
                end
            end
        end
    end

    println("Writing variables attributes...")
    if loopifpossible && mode == "index"
        write_varattr(f, gms.lb, gms, "setlowerbound")
        write_varattr(f, gms.ub, gms, "setupperbound")
        write_varattr(f, gms.fx, gms, ["setlowerbound", "setupperbound"])
        write_varattr(f, gms.l, gms, "setvalue")
    else
        write_enumerate_varattr(f, gms, mode)
    end

    println("Writing Constraints...")
    write(f, string("\n\n# ----- Constraints ----- #\n"))
    for row in gms.rows
        if gms.rowsSense[row] == "E"
            gms.rowsLHS[row] = replace_oprs(gms.rowsLHS[row])
            if try_iflinear("@constraint(m_tester, $(gms.rowsLHS[row]) == $(gms.rowsRHS[row]))\n", quadNL)
                write(f, "@constraint(m, $(row), $(gms.rowsLHS[row]) == $(gms.rowsRHS[row]))\n")
            else
                write(f, "@NLconstraint(m, $(row), $(gms.rowsLHS[row]) == $(gms.rowsRHS[row]))\n")
            end
        elseif gms.rowsSense[row] == "L"
            gms.rowsLHS[row] = replace_oprs(gms.rowsLHS[row])
            if try_iflinear("@constraint(m_tester, $(gms.rowsLHS[row]) <= $(gms.rowsRHS[row]))\n", quadNL)
                write(f, "@constraint(m, $(row), $(gms.rowsLHS[row]) <= $(gms.rowsRHS[row]))\n")
            else
                write(f, "@NLconstraint(m, $(row), $(gms.rowsLHS[row]) <= $(gms.rowsRHS[row]))\n")
            end
        elseif gms.rowsSense[row] == "G"
            gms.rowsLHS[row] = replace_oprs(gms.rowsLHS[row])
            if try_iflinear("@constraint(m_tester, $(gms.rowsLHS[row]) >= $(gms.rowsRHS[row]))\n", quadNL)
                write(f, "@constraint(m, $(row), $(gms.rowsLHS[row]) >= $(gms.rowsRHS[row]))\n")
            else
                write(f, "@NLconstraint(m, $(row), $(gms.rowsLHS[row]) >= $(gms.rowsRHS[row]))\n")
            end
		elseif gms.rowsSense[row] == "N"
            gms.rowsLHS[row] = replace_oprs(gms.rowsLHS[row])
            write(f, "#@constraint(m, $(row), $(gms.rowsLHS[row]) =N= $(gms.rowsRHS[row]))\n")
        else
            error("ERROR|gms2jump.jl|write_julia_script()|Unkown sense type. (Unlikely)")
        end
    end

    write(f, string("\n\n# ----- Objective ----- #\n"))
    if mode == "raw"
        println("Writing objective section...")
        addNL = try_iflinear("@objective(m_tester, Max, $(gms.objective))\n")
        if gms.objSense == "maximizing"
            addNL ? write(f, "@NLobjective(m, Max, $(gms.objective))\n\n") : write(f, "@objective(m, Max, $(gms.objective))\n\n")
        elseif gms.objSense == "minimizing"
            addNL ? write(f, "@NLobjective(m, Min, $(gms.objective))\n\n") : write(f, "@objective(m, Min, $(gms.objective))\n\n")
        else
            error("ERROR|gms2jump.jl|write_julia_script()|Unkown objective sense.")
        end
    else mode == "index"
        if haskey(gms.cols2vars, gms.objective)
            println("Writing objective section...")
            addNL = try_iflinear("@objective(m_tester, Max, $(gms.cols2vars[gms.objective]))\n")
            if gms.objSense == "maximizing"
                addNL ? write(f, "@objective(m, Max, $(gms.cols2vars[gms.objective]))\n\n") : write(f, "@NLobjective(m, Max, $(gms.cols2vars[gms.objective]))\n\n")
            elseif gms.objSense == "minimizing"
                addNL ? write(f, "@objective(m, Min, $(gms.cols2vars[gms.objective]))\n\n") : write(f, "@NLobjective(m, Min, $(gms.cols2vars[gms.objective]))\n\n")
            else
                error("ERROR|gms2jump.jl|write_julia_script()|Unkown objective sense.")
            end
        else
            println("Writing objective section...")
            gms.objective = replace_oprs(gms.objective)
            addNL = try_iflinear("@objective(m_tester, Max, $(gms.objective))\n")
            if gms.objSense == "maximizing"
                addNL ? write(f, "@objective(m, Max, $(gms.objective))\n\n") : write(f, "@NLobjective(m, Max, $(gms.objective))\n\n")
            elseif gms.objSense == "minimizing"
                addNL ? write(f, "@objective(m, Min, $(gms.objective))\n\n") : write(f, "@NLobjective(m, Min, $(gms.objective))\n\n")
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
