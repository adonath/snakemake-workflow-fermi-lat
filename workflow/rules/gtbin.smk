rule gtbin:
    input:
        "results/{config_name}/{config_name}-events-selected-filtered.fits"
    output:
        "results/{config_name}/{config_name}-counts.fits"
    log: "logs/{config_name}/gtbin.log"
    run:
        args = gtbin.to_cmd_args()
        shell("gtbin infile={input} outfile={output} " + args)
