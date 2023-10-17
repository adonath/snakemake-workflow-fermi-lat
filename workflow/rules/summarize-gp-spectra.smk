rule summarize_gp_spectra:
    input:
        "config[path_results]/{config_name}/datasets/{config_name}-datasets-all.yaml"
    output:
        report("config[path_results]/{config_name}/summary/images/{config_name}-counts-spectra.png", caption="../report/caption-counts.rst", category="Counts"),
        report("config[path_results]/{config_name}/summary/images/{config_name}-exposure-spectra.png", caption="../report/caption-counts.rst", category="Exposure"),
        report("config[path_results]/{config_name}/summary/images/{config_name}-psf-spectra.png", caption="../report/caption-counts.rst", category="PSF"),
    log:
        "logs/{config_name}/summarize-gp-spectra.log"
    run:
        import matplotlib
        matplotlib.use('agg')

        import matplotlib.pyplot as plt
        from gammapy.datasets import Datasets
        import numpy as np

        dpi = 150
        datasets = Datasets.read(input[0])

        fig = plt.figure(figsize=(8, 5))

        for dataset in datasets:
            spectrum = dataset.counts.to_region_nd_map(func=np.sum)
            spectrum.plot(label=dataset.name)
        
        plt.legend()
        plt.savefig(output[0], dpi=dpi)

        fig = plt.figure(figsize=(8, 5))

        for dataset in datasets:
            spectrum = dataset.exposure.to_region_nd_map(func=np.mean)
            spectrum.plot(label=dataset.name)
        
        plt.legend()
        plt.savefig(output[1], dpi=dpi)

        fig = plt.figure(figsize=(8, 5))

        for dataset in datasets:
            spectrum = dataset.psf.plot_containment_radius_vs_energy()
        
        plt.legend()
        plt.savefig(output[2], dpi=dpi)
