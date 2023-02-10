rule gather_event_files:
    output:
        expand("results/{sub_name}/events.txt", sub_name=config["sub_name"])
    shell: 
        "ls data/*_PH* > {output}"