rule gtmktime:
    input:
        "results/{config_name}/{config_name}-events-selected.fits"
    output:
        "results/{config_name}/{config_name}-events-selected-filtered.fits"
    log:
        "logs/{config_name}/gtmktime.log"
    shell: 
        "gtmktime scfile={config[scfile]} evfile={input} outfile={output} filter='{config[gtmktime][filter]}' roicut={config[gtmktime][roicut]}"