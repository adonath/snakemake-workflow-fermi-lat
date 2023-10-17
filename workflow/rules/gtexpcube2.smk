rule gtexpcube2:
    input:
        "{path_results}/{config_name}/{config_name}-ltcube.fits"
    output:
        "{path_results}/{config_name}/maps/{event_type}/{config_name}-{event_type}-exposure.fits"
    log:
        "{path_results}/{config_name}/logs/{event_type}/gtexpcube2.log"
    run:
        args = gtexpcube2.to_cmd_args()
        shell("gtexpcube2 infile={input} outfile={output} " + args)
