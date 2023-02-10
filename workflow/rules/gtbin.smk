rule fermitools-gtbin:
    input:
        "path/to/inputfile"
    output:
        "path/to/outputfile"
    log: "logs/gtbin.log"
    shell: "gtbin evfile=$EVENTS outfile=$COUNTS algorithm=CCUBE SCFILE=$SPACECRAFT \
      coordsys=GAL binsz=0.05 nxpix=400 nypix=200 xref=0 yref=0 proj=CAR ebinalg=LOG \
      emin=$EMIN emax=$EMAX enumbins=$NEBINS axisrot=0"