from .types import Factory, Component, Station, Product, Route

class FactoryLayout:
    def __init__(self, factory: Factory):
        self.factory = factory

    def define_layout(self):
        # 1. Define Components
        comp_a = Component(id="C001", name="Motor", description="Electric motor", required_resources={})
        comp_b = Component(id="C002", name="Housing", description="Product casing", required_resources={})
        self.factory.add_component(comp_a)
        self.factory.add_component(comp_b)

        # 2. Define Stations
        station_m1 = Station(id="S001", name="Motor Assembly", type="Assembly", capacity=5)
        station_p1 = Station(id="S002", name="Processing", type="Processing", capacity=10)
        station_i1 = Station(id="S003", name="Inspection", type="Inspection", capacity=5)
        
        # Added multiple stations for the new flow
        station_q1 = Station(id="S004", name="Quality Check", type="Inspection", capacity=8)
        station_p2 = Station(id="S005", name="Packaging", type="Packaging", capacity=15)

        self.factory.add_station(station_m1)
        self.factory.add_station(station_p1)
        self.factory.add_station(station_i1)
        self.factory.add_station(station_q1)
        self.factory.add_station(station_p2)

        # 3. Define Products
        product_x = Product(id="P001", name="Product X", required_components=["C001", "C002"], production_time=1.5)
        product_y = Product(id="P002", name="Product Y", required_components=["C001", "C002"], production_time=2.0)
        self.factory.add_product(product_x)
        self.factory.add_product(product_y)

        # 4. Define Routing
        # Route for Product X
        route_1 = Route(
            route_id="R001",
            sequence=["S001", "S002", "S003"],
            product_id="P001",
            description="Standard production flow for Product X"
        )
        self.factory.add_route(route_1)

        # New routing flow for Product Y, moving between new stations
        route_2 = Route(
            route_id="R002",
            sequence=["S001", "S004", "S005"],
            product_id="P002",
            description="Flow for Product Y through quality check and packaging"
        )
        self.factory.add_route(route_2)

        print(f"Factory Layout defined for {self.factory.name}.")

    def get_layout_summary(self):
        print("--- Factory Layout Summary ---")
        print(f"Components: {len(self.factory.components)}")
        print(f"Stations: {len(self.factory.stations)}")
        print(f"Products: {len(self.factory.products)}")
        print(f"Routes: {len(self.factory.routes)}")
