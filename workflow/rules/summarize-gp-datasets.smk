rule summarize_gp_dataset:
    input:
        "{path_results}/{config_name}/datasets/{config_name}-{event_type}-dataset.fits"
    output:
        report("{path_results}/{config_name}/summary/images/{event_type}/{config_name}-{event_type}-counts-image.png", caption="../report/caption-counts.rst", category="Counts", subcategory="{event_type}"),
        report("{path_results}/{config_name}/summary/images/{event_type}/{config_name}-{event_type}-counts-grid.png", caption="../report/caption-counts.rst", category="Counts", subcategory="{event_type}"),
    
        report("{path_results}/{config_name}/summary/images/{event_type}/{config_name}-{event_type}-exposure-image.png", caption="../report/caption-exposure.rst", category="Exposure", subcategory="{event_type}"),
        report("{path_results}/{config_name}/summary/images/{event_type}/{config_name}-{event_type}-exposure-grid.png", caption="../report/caption-exposure.rst", category="Exposure", subcategory="{event_type}"),
    log:
        "{path_results}/{config_name}/logs/{event_type}/prepare-gp-dataset.log"
    run:

        import matplotlib
        matplotlib.use('agg')
        
        import matplotlib.pyplot as plt

        from gammapy.datasets import MapDataset
        import numpy as np

        dpi = 150

        dataset = MapDataset.read(input[0])

        fig = plt.figure()
        dataset.counts.sum_over_axes().plot()
        plt.savefig(output[0], dpi=dpi)

        dataset.counts.plot_grid()
        plt.savefig(output[1], dpi=dpi)

        fig = plt.figure(figsize=(8, 5))
        dataset.exposure.sum_over_axes().plot()
        plt.savefig(output[2], dpi=dpi)

        dataset.exposure.plot_grid()
        plt.savefig(output[3], dpi=dpi)

