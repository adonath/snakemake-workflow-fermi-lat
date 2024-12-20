rule gtdrm:
    input:
        cmap="{path_results}/{config_name}/maps/{event_type}/{config_name}-{event_type}-counts.fits",
        expcube="{path_results}/{config_name}/{config_name}-ltcube.fits",
        bexpmap="{path_results}/{config_name}/maps/{event_type}/{config_name}-{event_type}-exposure.fits",
    output:
        "{path_results}/{config_name}/maps/{event_type}/{config_name}-{event_type}-edisp.fits"
    log:
        "{path_results}/{config_name}/logs/{event_type}/gtdrm.log"
    run:
        args = gtdrm.to_cmd_args()
        evtype = EVENT_TYPE_TO_INT[wildcards.event_type]
        shell("gtdrm cmap={input.cmap} outfile={output} expcube={input.expcube} bexpmap={input.bexpmap} " + args)