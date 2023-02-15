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
        from gammapy.maps import Map, RegionGeom
        from gammapy.datasets import MapDataset
        from gammapy.irf import PSFMap, EDispKernelMap
        from astropy.table import Table
        from regions import PointSkyRegion

        counts = Map.read(input[0])
        counts.data = counts.data.astype("float32")
        
        # for some reason the WCS definitions are not aligned...
        exposure = Map.read(input[1])
        exposure.geom._wcs = counts.geom.wcs

        psf = PSFMap.read(input[2], format="gtpsf")

        # Add missing PSF meta data, see https://github.com/fermi-lat/Likelihood/issues/117
        center = SkyCoord(config_obj.fermitools.gtpsf.ra, config_obj.fermitools.gtpsf.dec, unit="deg")
        point_region = PointSkyRegion(center)
        geom = RegionGeom.from_regions(point_region)
        
        geom_psf = geom.to_cube(psf.psf_map.geom.axes)

        psf.psf_map._geom = geom_psf
        psf.exposure_map._geom = geom_psf.squash("rad")
        psf.exposure_map = psf.exposure_map.to_unit("m2 s") 
        
        energy_axis_true = exposure.geom.axes["energy_true"]
        energy_axis = counts.geom.axes["energy"]

        edisp = EDispKernelMap.from_diagonal_response(
            energy_axis_true=energy_axis_true,
            energy_axis=energy_axis,
            geom=geom_psf
        )
        
        edisp.exposure_map = psf.exposure_map.rename_axes(["rad"], ["energy"])

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
