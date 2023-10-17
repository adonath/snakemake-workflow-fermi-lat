rule gather_event_files:
    output:
        "{path_results}/events.txt"
    shell: 
        "ls {config[path_data]}/*_PH* > {output}"