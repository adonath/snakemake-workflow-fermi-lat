# Snakemake workflow for Fermi-LAT data reduction

This is an example snakemake workflow for data reduction of Fermi-LAT data. 
The workflow will run the standrad `fermitools` for a given configuration
and produce as an output FITS file in a format the Gammapy can read.
Thereby it will handle the reduction of counts, exposure and point
spread function (PSF) for various  

## Getting Started

### Setup Environment 
Start by cloning this repository to your local machine:
```bash
git clone https://github.com/adonath/snakemake-workflow-fermi-lat.git
```

If you havn't done yet, please install [conda](https://www.anaconda.com/products/distribution)
or [mamba](https://mamba.readthedocs.io/en/latest/installation.html).

Now change to the directory of the repository:
```bash
cd snakemake-workflow-fermi-lat/
```

And create the conda environment using:
```bash
mamba env create -f environment.yaml
```

Once the process is done you can activate the environment:

```bash
conda activate snakemake-workflow-fermi-lat
```

### Download Data

Go to https://fermi.gsfc.nasa.gov/cgi-bin/ssc/LAT/LATDataQuery.cgi and download the data 
you are interested in. The data should be downloaded to the `./data` folder.

### Configure and Run the Workflow
Now you should adapt the configuration in [config/config.yaml](config/config.yaml)
to match your data. 

Then you are ready to run the workflow, like:
```bash
snakemake --cores 8
```

You can also create a report to see previews of the counts, exposure and PSF images:
```bash
snakemake --report report.html
open report.html
```

Finally you can read and print the datasets as well as models using Gammapy:
```python3

from gammapy.datasets import Datasets
from gammapy.modeling.models import Models

datasets = Datasets.read("results/<my-config>/datasets/<my-config>-datasets-all.yaml")
models = Models.read("results/<my-config>/model/<my-config>-model.yaml")

print(datasets)
print(models)
```
