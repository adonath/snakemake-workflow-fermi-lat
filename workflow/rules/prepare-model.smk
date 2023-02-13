rule prepare_model:
    output:
        "results/{config_name}/model/{config_name}-model.yaml"
        "results/{config_name}/model/{config_name}-galactic-diffuse-model.fits"
        "results/{config_name}/model/{config_name}-isotropic-diffuse-model.txt"
    log:
        "logs/{config_name}/prepare-gp-dataset.log"
    run:

        from gammapy.maps import Map
        from gammapy.modeling.models import (
            PowerLawNormSpectralModel,
            SkyModel,
            TemplateSpatialModel,
            create_fermi_isotropic_diffuse_model,
        )

        model = Map.read("$FERMI_DIR/refdata/fermi/galdiffuse/gll_iem_v07.fits")
        cutout = model.cutout()
        cutout.slice_by_energy()
        cutout.write(output[1])

        diffuse_iso = create_fermi_isotropic_diffuse_model(
            filename=filename, interp_kwargs={"fill_value": None}
        )

        template_diffuse = TemplateSpatialModel.read(
            filename="$GAMMAPY_DATA/fermi-3fhl-gc/gll_iem_v06_gc.fits.gz", normalize=False
        )

        diffuse_iem = SkyModel(
            spectral_model=PowerLawNormSpectralModel(),
            spatial_model=template_diffuse,
            name="diffuse-iem",
        )

        models.extend([diffuse_iso, diffuse_iem])
        models.write(output[0])

