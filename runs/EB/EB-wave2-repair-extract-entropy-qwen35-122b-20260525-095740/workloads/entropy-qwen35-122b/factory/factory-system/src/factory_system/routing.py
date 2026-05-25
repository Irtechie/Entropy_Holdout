from .core.types import Product, Routing, Station
from .stations import StationGraph

def run_route(graph: StationGraph, routing: Routing, product: Product) -> bool:
    if not graph.validate():
        return False
    
    if not routing.stations:
        return False
    
    for i, station in enumerate(routing.stations):
        if station.id not in graph.stations:
            return False
        
        if i < len(routing.stations) - 1:
            next_station = routing.stations[i + 1]
            found = False
            for conn in graph.connections:
                if conn.from_station_id == station.id and conn.to_station_id == next_station.id:
                    found = True
                    break
            if not found:
                return False
    
    return True

