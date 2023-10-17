rule gtltcube:
    input:
       expand("{path_results}/{config_name}/events/filtered/{config_name}-{event_type}-events-selected-filtered.fits", path_results=config["path_results"], config_name=config["name"], event_type=config_obj.event_types)
    output:
        "{path_results}/{config_name}/{config_name}-ltcube.fits"
    log:
        "{path_results}/{config_name}/logs/gtltcube.log"
    run:
        if config_obj.ltcube is not None:
            shell("cp {config[ltcube]} {input}")
        else:
            args = gtltcube.to_cmd_args()
            shell("gtltcube evfile={input[0]} outfile={output} scfile={config[scfile]} " + args)