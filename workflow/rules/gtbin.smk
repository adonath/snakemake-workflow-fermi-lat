rule gtbin:
    input:
        "{path_results}/{config_name}/events/filtered/{config_name}-{event_type}-events-selected-filtered.fits"
    output:
        "{path_results}/{config_name}/maps/{event_type}/{config_name}-{event_type}-counts.fits"
    log: "{path_results}/{config_name}/logs/{event_type}/gtbin.log"
    run:
        args = gtbin.to_cmd_args()
        shell("gtbin evfile={input} outfile={output} scfile={config[scfile]} " + args)
