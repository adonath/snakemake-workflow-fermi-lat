rule gtexpcube2:
    input:
        "path/to/inputfile"
    output:
        "path/to/outputfile"
    log: "logs/gtbin.log"
    shell: 
        "gtexpcube2 infile=$LIVETIME outfile=$EXPOSURE irf=$IRF coordsys=GAL binsz=0.05"
        "nxpix=400 nypix=200 xref=0 yref=0 proj=CAR ebinalg=$EBINALG cmap=none"
        "emin=$EMIN emax=$EMAX enumbins=$NEBINS axisrot=0 bincalc=EDGE"