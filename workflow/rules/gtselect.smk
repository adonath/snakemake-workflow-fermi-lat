rule gtselect:
    input:
        "results/{config_name}/{config_name}-events.txt"
    output:
        "results/{config_name}/{config_name}-events-selected.fits"
    log:
        "logs/{config_name}/gtselect.log"
    shell: 
        "gtselect infile={input} outfile={output} ra={ra} dec={dec} rad={rad} "
        "tmin={tmin} tmax={tmax} emin={emin} emax={emax} "
        "zmax={zmax}"