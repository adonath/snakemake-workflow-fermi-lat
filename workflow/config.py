import json
import logging
from pathlib import Path

import yaml
from astropy.coordinates import Angle, SkyCoord
from astropy.time import Time
from astropy.units import Quantity
from gammapy.analysis.config import AngleType, EnergyType, FrameEnum
from gammapy.utils.scripts import make_path, read_yaml
from pydantic import BaseModel

log = logging.getLogger(__name__)


class PathType(Path):
    @classmethod
    def __get_validators__(cls):
        yield cls.validate

    @classmethod
    def validate(cls, v):
        return Path(v)


class BaseConfig(BaseModel):
    """Base config"""

    class Config:
        validate_all = True
        validate_assignment = True
        extra = "forbid"
        json_encoders = {
            Angle: lambda v: v.to_string(),
            Quantity: lambda v: f"{v.value} {v.unit}",
            Time: lambda v: f"{v.value}",
        }


class SkyCoordConfig(BaseConfig):
    frame: FrameEnum = FrameEnum.icrs
    lon: AngleType = Angle("06h35m46.5079301472s")
    lat: AngleType = Angle("-75d16m16.816418256s")

    @property
    def sky_coord(self):
        """SkyCoord"""
        return SkyCoord(self.lon, self.lat, frame=self.frame)


class SnakemakeFermiLATConfig(BaseConfig):
    """Snakemake workflow config"""

    name: str = "my-analysis"
    sub_name: str = "my-config"
    path_data: PathType = Path("./data")

    @classmethod
    def read(cls, path):
        """Reads from YAML file."""
        log.info(f"Reading {path}")
        config = read_yaml(path)
        return cls(**config)

    @classmethod
    def from_yaml(cls, config_str):
        """Create from YAML string."""
        settings = yaml.safe_load(config_str)
        return cls(**settings)

    def write(self, path, overwrite=False):
        """Write to YAML file."""
        path = make_path(path)

        if path.exists() and not overwrite:
            raise IOError(f"File exists already: {path}")

        path.write_text(self.to_yaml())

    def __str__(self):
        """Display settings in pretty YAML format."""
        info = self.__class__.__name__ + "\n\n\t"
        data = self.to_yaml()
        data = data.replace("\n", "\n\t")
        info += data
        return info.expandtabs(tabsize=2)

    def to_yaml(self):
        """Convert to YAML string."""
        # Here using `dict()` instead of `json()` would be more natural.
        # We should change this once pydantic adds support for custom encoders
        # to `dict()`. See https://github.com/samuelcolvin/pydantic/issues/1043

        data = self.json()

        config = json.loads(data)
        return yaml.dump(
            config, sort_keys=False, indent=4, width=80, default_flow_style=False
        )
