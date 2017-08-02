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
        for i in length(gms.cols):-1:1
            gms.rowsLHS[row] = replace(gms.rowsLHS[row], gms.cols[i], string(gms.cols2vars[gms.cols[i]]))
        end
    end
end

function replace_oprs(line::AbstractString; kwargs...)

    line = replace(line, "\n", "")
    line = replace(line, " ", "")
    line = _replace_sqr(line)
    line = replace(line, "**", "^")

    return line
end

function _replace_sqr(str::AbstractString)
    # @show "Begin ",str
    for i in 1:(length(str)-4)
        if str[i:(i+3)] == "sqr("
            # @show "Found sqr("
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
                    # @show "Before sending ", subStr
                    subStr = _replace_sqr(subStr)
                    # @show "Processed subStr = ", subStr
                    str = string(str[1:substart-3], subStr, str[subclose-1:end])
                    # @show "After recomposing", length(str)
                end
            end
        end
    end
    # @show "exiting this level with ", str
    return str
end

function read_command(file::IOStream, gms::oneProblem, lInit::AbstractString; kwargs...)
    warn("I am not that smart to parse command in gms files, YET")
    return 0
end
