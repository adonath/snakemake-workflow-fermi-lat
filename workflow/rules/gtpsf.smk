rule gtpsf:
    input:
        "config[path_results]/{config_name}/{config_name}-ltcube.fits"
    output:
        "config[path_results]/{config_name}/maps/{event_type}/{config_name}-{event_type}-psf.fits"
    log:
        "logs/{config_name}/{event_type}/gtpsf.log"
    run:
        args = gtpsf.to_cmd_args()
        evtype = EVENT_TYPE_TO_INT[wildcards.event_type]
        shell("gtpsf expcube={input} outfile={output} evtype={evtype} " + args)
