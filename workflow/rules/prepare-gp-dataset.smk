rule prepare_gp_dataset:
    input:
        "results/{config_name}/maps/{event_type}/{config_name}-{event_type}-counts.fits",
        "results/{config_name}/maps/{event_type}/{config_name}-{event_type}-exposure.fits",
        "results/{config_name}/maps/{event_type}/{config_name}-{event_type}-psf.fits",
    output:
        "results/{config_name}/datasets/{config_name}-{event_type}-dataset.fits",
    log:
        "logs/{config_name}/{event_type}/prepare-gp-dataset.log"
    run:
        from gammapy.maps import Map 
        from gammapy.datasets import MapDataset
        from gammapy.irf import PSFMap, EDispKernelMap
        from astropy.table import Table

        counts = Map.read(input[0])
        exposure = Map.read(input[1])
        psf = PSFMap.read(input[2], format="gtpsf")

        energy_axis_true = exposure.geom.axes["energy_true"]
        energy_axis = counts.geom.axes["energy"]

        edisp = EDispKernelMap.from_diagonal_response(
            energy_axis_true=energy_axis_true, energy_axis=energy_axis
        )
        mask_safe = counts.geom.boundary_mask(width="0.2 deg")

        row = {"TELESCOP": "Fermi-LAT"}
        meta_table = Table([row])

        dataset = MapDataset(
            name=f"{wildcards.config_name}-{wildcards.event_type}",
            counts=counts,
            exposure=exposure,
            psf=psf,
            edisp=edisp,
            mask_safe=mask_safe,
            meta_table=meta_table,
        )

        dataset.write(output[0])
