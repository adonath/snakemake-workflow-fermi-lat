rule gtselect:
    input:
        expand("results/{sub_name}/events.txt", sub_name=config["sub_name"])
    output:
        expand("results/{sub_name}/events.fits", sub_name=config["sub_name"])
    log: expand("logs/{sub_name}/gtselect.log", sub_name=config["sub_name"])
    params:
        arguments = config_obj.gtselect.to_fermi_tools()
    shell: "gtselect infile={input} outfile={output} {params.arguments}"