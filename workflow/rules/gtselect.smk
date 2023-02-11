rule gtselect:
    input:
        "results/events.txt"
    output:
        "results/{config_name}/{config_name}-events-selected.fits"
    log:
        "logs/{config_name}/gtselect.log"
    run: 
        args = gtselect.to_cmd_args()
        shell("gtselect infile={input} outfile={output} " + args)