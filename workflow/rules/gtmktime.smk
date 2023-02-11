rule gtmktime:
    input:
        "results/{config_name}/{config_name}-events-selected.fits"
    output:
        "results/{config_name}/{config_name}-events-selected-filtered.fits"
    log:
        "logs/{config_name}/gtmktime.log"
    run:
        args = gtmktime.to_cmd_args()
        shell("gtmktime scfile={config[scfile]} evfile={input} outfile={output} " + args)