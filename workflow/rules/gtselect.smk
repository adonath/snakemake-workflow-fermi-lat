rule gtselect:
    input:
        "{path_results}/events.txt"
    output:
        "{path_results}/{config_name}/events/{config_name}-{event_type}-events-selected.fits"
    log:
        "{path_results}/{config_name}/logs/{event_type}/gtselect.log"
    run: 
        args = gtselect.to_cmd_args()
        evtype = EVENT_TYPE_TO_INT[wildcards.event_type]
        shell("gtselect infile={input} outfile={output} evtype={evtype} " + args)