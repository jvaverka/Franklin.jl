const LITERATE_FENCER        = "julialit"
const LITERATE_JULIA_FENCE   = "```$LITERATE_FENCER"
const LITERATE_JULIA_FENCE_L = length(LITERATE_JULIA_FENCE)
const LITERATE_JULIA_FENCE_R = Regex(LITERATE_JULIA_FENCE)


"""
$SIGNATURES

Take a Literate.jl script and transform it into a Franklin-Markdown file.
"""
function literate_to_franklin(rpath::AS)::Tuple{String,Bool}
    rpath *= ifelse(endswith(rpath, ".jl"), "", ".jl")
    if !startswith(rpath, '/')
        # try looking into the `_literate` folder
        fpath = joinpath(path(:literate), rpath)
        srpath = split(fpath)[1:end-1] # ignore the file name
    else
        # rpath is of the form "/scripts/[path/]tutorial[.jl]"
        # split it so that when recombining it will lead to valid path inc windows
        srpath = split(rpath, '/')[2:end] # discard empty [1] since starts with "/"
        fpath  = joinpath(PATHS[:folder], srpath...)
    end
    if !isfile(fpath)
        print_warning("""
            File not found when trying to  convert a literate file at '$fpath'.
            """)
        return "", true
    end
    outpath = joinpath(PATHS[:site], "assets", "literate",
                       srpath[2:end-1]...)
    isdir(outpath) || mkpath(outpath)
    # retrieve the file name
    fname = splitext(splitdir(fpath)[2])[1]
    spath = joinpath(outpath, fname * "_script.jl")
    prev  = ""
    if isfile(spath)
        prev = read(spath, String)
    end
    # don't show Literate's infos
    Logging.disable_logging(Logging.LogLevel(Logging.Info))
    # >> output the markdown
    Literate.markdown(
        fpath, outpath;
        flavor=Literate.CommonMarkFlavor(),
        mdstrings=locvar(:literate_mds)::Bool,
        config=Dict("codefence" => (LITERATE_JULIA_FENCE => "```")),
        preprocess=s->replace(s, r"#hide\s*?\n" => "# hide\n"),
        postprocess=literate_post_process,
        credit=false
    )
    # >> output the script
    Literate.script(
        fpath, outpath;
        flavor=Literate.CommonMarkFlavor(),
        mdstrings=locvar(:literate_mds)::Bool,
        postprocess=s->(MESSAGE_FILE_GEN_LIT * s),
        name=fname * "_script",
        credit=false
    )
    # bring back logging
    Logging.disable_logging(Logging.LogLevel(Logging.Debug))
    # see if things have changed
    haschanged = (read(spath, String) != prev)
    # return path to md file
    return joinpath(outpath, fname * ".md"), haschanged
end


"""
$SIGNATURES

Take a markdown string generated by literate and post-process it to number each
code block and mark them as eval-ed ones.
"""
function literate_post_process(s::String)::String
    isempty(s) && return s
    em   = eachmatch(LITERATE_JULIA_FENCE_R, s)
    buf  = IOBuffer()
    write(buf, "<!--$MESSAGE_FILE_GEN-->\n")
    head = 1
    c    = 1
    for m in em
        write(buf, SubString(s, head, prevind(s, m.offset)))
        write(buf, "```julia:ex$c\n")
        head = nextind(s, m.offset + LITERATE_JULIA_FENCE_L)
        c   += 1
    end
    lis = lastindex(s)
    head < lis && write(buf, SubString(s, head, lis))
    return String(take!(buf))
end
