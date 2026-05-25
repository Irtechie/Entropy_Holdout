class Component:
    """Represents a physical component in the factory."""
    def __init__(self, component_id: str, description: str, properties: dict):
        self.component_id = component_id
        self.description = description
        self.properties = properties

    def __repr__(self):
        return f"Component(id={self.component_id}, desc='{self.description}')"
