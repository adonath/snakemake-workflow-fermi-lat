rule prepare_gp_datasets_yaml:
    input:
        expand("{path_results}/{config_name}/datasets/{config_name}-{event_type}-dataset.fits", path_results=config["path_results"], config_name=config["name"], event_type=config_obj.event_types)
    output:
        "{path_results}/{config_name}/datasets/{config_name}-datasets-all.yaml"
    log:
        "{path_results}/{config_name}/logs/prepare-gp-datasets-yaml.log"
    run:

        from gammapy.utils.scripts import write_yaml
        from pathlib import Path
        from astropy.io import fits

        data = {}
        data["datasets"] = []

        for filename in input:
            filename = Path(filename)
            header = fits.getheader(filename)
            entry = {
                "type": "MapDataset",
                "name": header["NAME"],
                "filename": filename.name,
            }
            data["datasets"].append(entry)

        write_yaml(data, filename=output[0])