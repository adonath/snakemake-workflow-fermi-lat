rule prepare_gp_model:
    output:
        "results/{config_name}/model/{config_name}-model.yaml",
        "results/{config_name}/model/{config_name}-galactic-diffuse-model.fits",
    log:
        "logs/{config_name}/prepare-gp-model.log"
    run:

        from gammapy.maps import Map
        from gammapy.modeling.models import (
            PowerLawNormSpectralModel,
            SkyModel,
            TemplateSpatialModel,
            create_fermi_isotropic_diffuse_model,
            Models,
        )
        from gammapy.utils.scripts import make_path
        from gammapy.catalog import CATALOG_REGISTRY
        from astropy import units as u

        cutout_margin = 2 * u.deg

        path = make_path("$FERMI_DIR/refdata/fermi/galdiffuse")
        model = Map.read(path / "gll_iem_v07.fits")

        cutout = model.cutout(gtselect.center_skydir, width=gtselect.width + cutout_margin)
        
        axis = cutout.geom.axes["energy_true"]
        idx_min, idx_max = axis.coord_to_idx([gtexpcube2.emin, gtexpcube2.emax] * u.MeV)
        cuotut = cutout.slice_by_idx({"energy": slice(idx_min, idx_max)})
        cutout.write(output[1])

        models = Models()

        for idx, event_type in enumerate(config_obj.event_types):
            filename = path / f"iso_{gtexpcube2.irfs}_{event_type.upper()}_v1.txt"
                
            diffuse_iso = create_fermi_isotropic_diffuse_model(
                filename=filename, interp_kwargs={"fill_value": None},
            )
            diffuse_iso._name = f"diffuse-iso-{event_type}"
            diffuse_iso.datasets_names = [f"{config_obj.name}-{event_type}"]
            models.append(diffuse_iso)


        template_diffuse = TemplateSpatialModel.read(
            filename=output[1], normalize=False
        )

        diffuse_iem = SkyModel(
            spectral_model=PowerLawNormSpectralModel(),
            spatial_model=template_diffuse,
            name="diffuse-iem",
        )
        models.append(diffuse_iem)

        catalog = CATALOG_REGISTRY.get_cls("3fhl")()

        selection = cutout.geom.to_image().contains(catalog.positions)
        
        for source in catalog[selection]:
            models.append(source.sky_model())

        models.write(output[0], write_covariance=False)

