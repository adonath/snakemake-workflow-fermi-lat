rule prepare_gp_dataset:
    input:
        "results/{config_name}/maps/{config_name}-counts.fits",
        "results/{config_name}/maps/{config_name}-exposure.fits",
        "results/{config_name}/maps/{config_name}-psf.fits",
    output:
        "results/{config_name}/datasets/{config_name}-dataset.fits"
    log:
        "logs/{config_name}/prepare-gp-dataset.log"
    run:

        from gammapy.maps import Map 
        from gammapy.datasets import MapDataset
        from gammapy.irf import PSFMap, EDispKernelMap

        counts = Map.read(input[0])
        exposure = Map.read(input[1])
        psf = PSFMap.read(input[2], format="gtpsf")

        energy_axis_true = exposure.geom.axes["energy_true"]
        energy_axis = counts.geom.axes["energy"]

        edisp = EDispKernelMap.from_diagonal_response(
            energy_axis_true=energy_axis_true, energy_axis=energy_axis
        )

        dataset = MapDataset(counts=counts)
        dataset.write(output[0])
