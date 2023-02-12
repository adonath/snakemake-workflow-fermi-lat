import logging

from gammapy.catalogs import SOURCE_CATALOGS
from gammapy.maps import Map
from gammapy.models import create_iso_diffuse_model

log = logging.getLogger(__file__)


def read_counts_map_geom():
    pass


def cutout_galactic_diffuse():
    model = Map.read("$FERMI_DIR/refdata/fermi/galdiffuse/gll_iem_v07.fits")
    cutout = model.cutout()
    cutout.slice_by_energy()
    cutout.write()


def select_catalog_sources(catalogs):
    pass


if __name__ == "__main__":
    pass
