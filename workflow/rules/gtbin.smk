rule gtbin:
    input:
        "results/{config_name}/events/{config_name}-{event_type}-events-selected-filtered.fits"
    output:
        "results/{config_name}/maps/{config_name}-{event_type}-counts.fits"
    log: "logs/{config_name}/{event_type}/gtbin.log"
    run:
        args = gtbin.to_cmd_args()
        shell("gtbin evfile={input} outfile={output} scfile={config[scfile]} " + args)
