rule gtbin:
    input:
        "results/{config_name}/{config_name}-events-selected-filtered.fits"
    output:
        "results/{config_name}/{config_name}-counts.fits"
    log: "logs/{config_name}/gtbin.log"
    shell: 
        "gtbin evfile={input} outfile={output} algorithm={config[gtbin][algorithm]} "
        "scfile={config[scfile]} "
        "coordsys={config[gtbin][coordsys]} binsz={config[gtbin][binsz]} "
        "nxpix={config[gtbin][nxpix]} nypix={config[gtbin][nypix]} "
        "xref={config[gtbin][xref]} yref={config[gtbin][yref]} "
        "proj={config[gtbin][proj]} ebinalg={config[gtbin][ebinalg]} "
        "emin={emin} emax={emax} "
        "enumbins={config[gtbin][enumbins]} axisrot={config[gtbin][axisrot]} "