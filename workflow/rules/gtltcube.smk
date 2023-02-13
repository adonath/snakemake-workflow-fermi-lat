rule gtltcube:
    input:
        "results/{config_name}/{config_name}-events-selected-filtered.fits"
    output:
        "results/{config_name}/{config_name}-ltcube.fits"
    log:
        "logs/{config_name}/gtltcube.log"
    run:
        args = gtltcube.to_cmd_args()
        shell("gtltcube evfile={input} outfile={output} scfile={config[scfile]}" + args)