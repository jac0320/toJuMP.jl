using JSON

f = open("minlplib2_meta.json", "w")
nf = open("minlplib2.names", "r")
meta = Dict()

miss_cnt = 0
for i in readlines(nf)
    meta[parse(i)] = Dict(:NINTVARS=>"",:MINJACCOEFVAR=>"",:NLAGHESSIANDIAGNZ=>"",:NLAGHESSIANBLOCKS=>"",:CONSCURVATURE=>"",:OBJTYPE=>"",:MINSCALEVAR=>"",:OBJSENSE=>"",:LAGHESSIANMAXBLOCKSIZE=>"",:MINSCALEEQU=>"",:OBJCURVATURE=>"",:NGENNLCONS=>"",:REMOVEREASON=>"",:NSOS2=>"",:LAGHESSIANAVGBLOCKSIZE=>"",:NSOS1=>"",:NNLBINVARS=>"",:ADDDATE=>"",:NSIGNOMCONS=>"",:MAXJACCOEF=>"",:NNLINTVARS=>"",:NCONS=>"",:MAXOBJCOEFVAR=>"",:REFERENCES=>"",:NOBJNLNZ=>"",:MINJACCOEF=>"",:MAXSCALEEQU=>"",:NSEMI=>"",:MAXSCALE=>"",:NJACOBIANNZ=>"",:MAXJACCOEFEQU=>"",:NLINCONS=>"",:DESCR=>"",:MAXSCALEVAR=>"",:NNLSEMI=>"",:MINOBJCOEFVAR=>"",:NJACOBIANNLNZ=>"",:MINOBJCOEF=>"",:MAXJACCOEFVAR=>"",:NVARS=>"",:LAGHESSIANMINBLOCKSIZE=>"",:MINJACCOEFEQU=>"",:NLOPERANDS=>"",:SOURCE=>"",:NOBJNZ=>"",:NLAGHESSIANNZ=>"",:NNLVARS=>"",:REMOVEDATE=>"",:NPOLYNOMCONS=>"",:MAXOBJCOEF=>"",:APPLICATION=>"",:NBINVARS=>"",:NQUADCONS=>"",:MINSCALE=>"")

    info_f_path = "$(homedir())/meta/$(i).info"
    prop_f_path = "$(homedir())/meta/$(i).prop"
    !isfile(info_f_path) && println("missing $i info")
    !isfile(prop_f_path) && println("missing $i prop")
    (!isfile(info_f_path) || !isfile(prop_f_path)) && (miss_cnt += 1)
    # Read the .info file
    if isfile(info_f_path)
        info_f = open(info_f_path, "r")
        for j in readlines(info_f)
            sj = split(j)
            if (length(sj) > 2) && (sj[2] == "=")
                if length(sj) > 3
                    meta[parse(i)][parse(sj[1])] = string(split(j, "=")[2])
                else
                    meta[parse(i)][parse(sj[1])] = string(sj[3])
                end
            end
        end
        close(info_f)
    end
    # Read the .prop file
    if isfile(prop_f_path)
        prop_f = open(prop_f_path, "r")
        for j in readlines(prop_f)
            sj = split(j)
            if (length(sj) > 2) && (sj[2] == "=")
                if length(sj) > 3
                    meta[parse(i)][parse(sj[1])] = string(split(j, "=")[2])
                else
                    meta[parse(i)][parse(sj[1])] = string(sj[3])
                end
            end
        end
        close(prop_f)
    end
end

println("Total problems that lacks some info = $(miss_cnt)")

close(nf)
JSON.print(f, meta)
close(f)
