from dataclasses import dataclass, field
from typing import List, Dict

@dataclass
class Component:
    id: str
    name: str
    description: str
    required_resources: Dict[str, int]

@dataclass
class Station:
    id: str
    name: str
    type: str  # e.g., 'Assembly', 'Processing', 'Inspection'
    capacity: int
    required_components: List[str]

@dataclass
class Product:
    id: str
    name: str
    required_components: List[str]
    production_time: float

@dataclass
class Route:
    route_id: str
    sequence: List[str]  # Sequence of Station IDs
    product_id: str
    description: str

class Factory:
    def __init__(self, name: str):
        self.name = name
        self.components: Dict[str, Component] = {}
        self.stations: Dict[str, Station] = {}
        self.products: Dict[str, Product] = {}
        self.routes: Dict[str, Route] = {}

    def add_component(self, component: Component):
        self.components[component.id] = component

    def add_station(self, station: Station):
        self.stations[station.id] = station

    def add_product(self, product: Product):
        self.products[product.id] = product

    def add_route(self, route: Route):
        self.routes[route.route_id] = route
