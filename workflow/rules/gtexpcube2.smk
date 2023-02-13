rule gtexpcube2:
    input:
        "results/{config_name}/{config_name}-{event_type}-ltcube.fits"
    output:
        "results/{config_name}/maps/{config_name}-{event_type}-exposure.fits"
    log:
        "logs/{config_name}/{event_type}/gtexpcube2.log"
    run:
        args = gtexpcube2.to_cmd_args()
        shell("gtexpcube2 infile={input} outfile={output} " + args)
