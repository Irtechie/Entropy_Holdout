# Main entry point for the Factory System
from .src.types.component import Component
from .src.types.station import Station
from .src.types.product import Product
from .src.types.routing import Routing

class FactorySystem:
    """Manages the entire factory layout and production flow."""
    def __init__(self):
        self.components: dict[str, Component] = {}
        self.stations: dict[str, Station] = {}
        self.products: dict[str, Product] = {}
        self.routings: dict[str, Routing] = {}

    def add_component(self, component: Component):
        self.components[component.component_id] = component

    def add_station(self, station: Station):
        self.stations[station.station_id] = station

    def add_product(self, product: Product):
        self.products[product.product_id] = product

    def add_routing(self, routing: Routing):
        self.routings[routing.route_id] = routing

    def get_layout_summary(self):
        return {
            "components_count": len(self.components),
            "stations_count": len(self.stations),
            "products_count": len(self.products),
            "routings_count": len(self.routings)
        }

# --- Example Usage for Stage 2: Adding Stations and Routing Flow ---

def setup_factory_flow():
    """Sets up a multi-station production flow for a sample product."""
    system = FactorySystem()

    # 1. Define Components
    c1 = Component(component_id="C_FRAME", description="Metal Frame", properties={})
    c2 = Component(component_id="C_ENGINE", description="Engine Unit", properties={})
    system.add_component(c1)
    system.add_component(c2)

    # 2. Define Stations
    s_assembly = Station(station_id="S_ASM", name="Assembly Line", capacity=10, required_components=["C_FRAME"])
    s_welding = Station(station_id="S_WLD", name="Welding Bay", capacity=5, required_components=[])
    s_qc = Station(station_id="S_QC", name="Quality Control", capacity=8, required_components=["C_ENGINE"])
    
    system.add_station(s_assembly)
    system.add_station(s_welding)
    system.add_station(s_qc)

    # 3. Define Product
    p_product_a = Product(product_id="P_A", name="Heavy Duty Unit", required_stations=["S_ASM", "S_WLD", "S_QC"])
    system.add_product(p_product_a)

    # 4. Define Routing Flow
    r_flow_a = Routing(route_id="R_A_FLOW", product_id="P_A", sequence=["S_ASM", "S_WLD", "S_QC"])
    system.add_routing(r_flow_a)

    return system

if __name__ == "__main__":
    factory_system = setup_factory_flow()
    summary = factory_system.get_layout_summary()
    print("--- Factory Layout Summary ---")
    print(f"Stations Count: {summary['stations_count']}")
    print(f"Products Count: {summary['products_count']}")
    print(f"Routings Count: {summary['routings_count']}")

