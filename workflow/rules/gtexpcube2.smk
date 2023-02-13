rule gtexpcube2:
    input:
        "results/{config_name}/{config_name}-ltcube.fits"
    output:
        "results/{config_name}/maps/{config_name}-exposure.fits"
    log:
        "logs/{config_name}/gtexpcube2.log"
    run:
        args = gtexpcube2.to_cmd_args()
        shell("gtexpcube2 infile={input} outfile={output} " + args)
