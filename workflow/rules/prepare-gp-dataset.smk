rule prepare_galldiff:
    output:
        "results/{config_name}/{config_name}-events-selected.fits"
    log:
        "logs/{config_name}/prepare-galldiff.log"
    run: 

        from gammapy.maps import maps
        
        model = Map.read("$FERMI_DIR/refdata/fermi/galdiffuse/gll_iem_v07.fits")
        cutout = model.cutout()
        cutout.write()