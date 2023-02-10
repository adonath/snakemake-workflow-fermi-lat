rule gather_event_files:
    output:
        "results/events.txt"
    shell: 
        "ls data/*_PH* > results/events.txt"