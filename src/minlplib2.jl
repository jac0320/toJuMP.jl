function minlplib2_download(pname::AbstractString; ptype="gms")

    url = "http://www.gamsworld.org/minlp/minlplib2/data/$(ptype)/$(pname).$(ptype)"

    download_fail = false
    try
        download(url, ".probdata/$(i).gms")
    catch e
        download_fail = true
    end

    if download_fail
        info("FAILED downloading $(pname).$(ptype)")
    else
        info("SUCCESSFULLY downloaded $(pname).$(ptype)")
    end

    return
end

function minlplib2_fetchmeta(pname::AbstractString)

    meta = JSON.parsefile("index/minlplib2_meta.json")
    for i in keys(meta[pname])
        println(i, " => ", meta[pname][i])
    end
    info("Returned meta dictionary...")

    return meta[pname]
end
