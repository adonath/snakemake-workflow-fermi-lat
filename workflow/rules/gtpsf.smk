rule gtpsf:
    input:
        "results/{config_name}/{config_name}-ltcube.fits"
    output:
        "results/{config_name}/{config_name}-psf.fits"
    log:
        "logs/{config_name}/gtpsf.log"
    run:
        args = gtpsf.to_cmd_args()
        shell("gtpsf expcube={input} outfile={output} " + args)
