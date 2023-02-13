rule gtltcube:
    input:
        "results/{config_name}/events/{config_name}-{event_type}-events-selected-filtered.fits"
    output:
        "results/{config_name}/{config_name}-{event_type}-ltcube.fits"
    log:
        "logs/{config_name}/{event_type}/gtltcube.log"
    run:
        args = gtltcube.to_cmd_args()
        shell("gtltcube evfile={input} outfile={output} scfile={config[scfile]} " + args)
        # TODO: for testing just copy...
        #shell("cp {config[ltcube]} {output}")