class Routing:
    """Defines the flow path of a product through the factory stations."""
    def __init__(self, route_id: str, product_id: str, sequence: list):
        self.route_id = route_id
        self.product_id = product_id
        self.sequence = sequence  # List of Station IDs in order

    def __repr__(self):
        return f"Routing(id={self.route_id}, product_id={self.product_id}, steps={len(self.sequence)})"
