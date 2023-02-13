rule gtpsf:
    input:
        "results/{config_name}/ltcubes/{config_name}-{event_type}-ltcube.fits"
    output:
        "results/{config_name}/maps/{event_type}/{config_name}-{event_type}-psf.fits"
    log:
        "logs/{config_name}/{event_type}/gtpsf.log"
    run:
        args = gtpsf.to_cmd_args()
        evtype = EVENT_TYPE_TO_INT[wildcards.event_type]
        shell("gtpsf expcube={input} outfile={output} evtype={evtype} " + args)
