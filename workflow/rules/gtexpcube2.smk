rule gtexpcube2:
    input:
        "config[path_results]/{config_name}/{config_name}-ltcube.fits"
    output:
        "config[path_results]/{config_name}/maps/{event_type}/{config_name}-{event_type}-exposure.fits"
    log:
        "logs/{config_name}/{event_type}/gtexpcube2.log"
    run:
        args = gtexpcube2.to_cmd_args()
        shell("gtexpcube2 infile={input} outfile={output} " + args)
