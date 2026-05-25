from dataclasses import dataclass
from typing import List

@dataclass
class Component:
    id: str
    name: str

@dataclass
class Station:
    id: str
    name: str
    capacity: int

@dataclass
class Product:
    id: str
    name: str
    components: List[Component]

@dataclass
class Routing:
    id: str
    product_id: str
    stations: List[Station]

