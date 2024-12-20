rule prepare_gp_dataset:
    input:
        "{path_results}/{config_name}/maps/{event_type}/{config_name}-{event_type}-counts.fits",
        "{path_results}/{config_name}/maps/{event_type}/{config_name}-{event_type}-exposure.fits",
        "{path_results}/{config_name}/maps/{event_type}/{config_name}-{event_type}-psf.fits",
        "{path_results}/{config_name}/maps/{event_type}/{config_name}-{event_type}-edisp.fits",
    output:
        "{path_results}/{config_name}/datasets/{config_name}-{event_type}-dataset.fits",
    log:
        "{path_results}/{config_name}/logs/{event_type}/prepare-gp-dataset.log"
    run:
        from gammapy.maps import Map, RegionGeom, MapAxis
        from gammapy.datasets import MapDataset
        from gammapy.irf import PSFMap, EDispKernelMap, EDispKernel
        from gammapy.irf.edisp.map import get_overlap_fraction
        import numpy as np

        from astropy.table import Table
        from regions import PointSkyRegion

        EDispKernel.default_unit = u.Unit("")

        SLICE_LOOKUP = {
            0 : slice(None),
            2 : slice(1, -1),
        }

        def read_drm_table(filename):
            table_drm = Table.read(filename, hdu="DRM")
            table_drm["ENERG_LO"].unit = "MeV"
            table_drm["ENERG_HI"].unit = "MeV"
            return table_drm
            

        def create_edisp_kernel(table_drm, energy_true_exposure):
            energy_true_drm = MapAxis.from_table(table_drm, format="ogip-arf")

            redistribute = get_overlap_fraction(energy_true_drm, energy_true_exposure)
            matrix_drm = np.stack(table_drm["MATRIX"].data)

            diff = energy_true_drm.nbin - table_drm.meta["DETCHANS"]
            energy_axis = energy_true_drm.slice(SLICE_LOOKUP[diff]).copy(name="energy")
            return EDispKernel(
                axes=[energy_true_exposure, energy_axis],
                data=redistribute @ matrix_drm,
            )



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

        table_drm = read_drm_table(input[3])
        edisp_kernel = create_edisp_kernel(table_drm, energy_axis_true)

        edisp = EDispKernelMap.from_edisp_kernel(edisp_kernel, geom=geom)
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
