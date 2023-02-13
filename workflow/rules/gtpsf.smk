rule gtpsf:
    input:
        "results/{config_name}/{config_name}-{event_type}-ltcube.fits"
    output:
        "results/{config_name}/maps/{config_name}-{event_type}-psf.fits"
    log:
        "logs/{config_name}/{event_type}/gtpsf.log"
    run:
        args = gtpsf.to_cmd_args()
        shell("gtpsf expcube={input} outfile={output} " + args)
