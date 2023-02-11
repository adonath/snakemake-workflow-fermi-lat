rule gather_event_files:
    output:
        "results/{config_name}/{config_name}-events.txt"
    shell: 
        "ls data/*_PH* > {output}"