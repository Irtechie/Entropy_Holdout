class Product:
    """Represents the final product being manufactured."""
    def __init__(self, product_id: str, name: str, required_stations: list):
        self.product_id = product_id
        self.name = name
        self.required_stations = required_stations

    def __repr__(self):
        return f"Product(id={self.product_id}, name='{self.name}')"
