from pathlib import Path

from astropy.coordinates import Angle, SkyCoord
from astropy.time import Time
from astropy.units import Quantity
from gammapy.analysis.config import AngleType, EnergyType, FrameEnum
from pydantic import BaseModel


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
