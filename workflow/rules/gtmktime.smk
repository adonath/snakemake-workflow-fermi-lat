rule gtmktime:
    input:
        "{path_results}/{config_name}/events/{config_name}-{event_type}-events-selected.fits"
    output:
        "{path_results}/{config_name}/events/filtered/{config_name}-{event_type}-events-selected-filtered.fits"
    log:
        "{path_results}/{config_name}/logs/{event_type}/gtmktime.log"
    run:
        args = gtmktime.to_cmd_args()
        shell("gtmktime scfile={config[scfile]} evfile={input} outfile={output} " + args)
        # TODO: for testing just copy...
        #shell("cp {input} {output}")