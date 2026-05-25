class Station:
    """Represents a processing station or workstation."""
    def __init__(self, station_id: str, name: str, capacity: int, required_components: list):
        self.station_id = station_id
        self.name = name
        self.capacity = capacity
        self.required_components = required_components

    def __repr__(self):
        return f"Station(id={self.station_id}, name='{self.name}')"
