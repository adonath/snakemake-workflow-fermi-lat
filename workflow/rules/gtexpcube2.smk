rule gtexpcube2:
    input:
        "path/to/inputfile"
    output:
        "path/to/outputfile"
    log: "logs/gtbin.log"
    run:
        args = gtexpcube2.to_cmd_args()
        shell("gtexpcube2 infile=$LIVETIME outfile=$EXPOSURE " + args)
