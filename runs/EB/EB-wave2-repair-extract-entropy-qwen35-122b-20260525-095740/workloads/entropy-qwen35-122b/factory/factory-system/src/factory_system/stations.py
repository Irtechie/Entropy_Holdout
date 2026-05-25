from typing import Dict, List
from .core.types import Station, Connection

class StationGraph:
    def __init__(self):
        self.stations: Dict[str, Station] = {}
        self.connections: List[Connection] = []

    def add_station(self, station: Station):
        self.stations[station.id] = station

    def add_connection(self, connection: Connection):
        self.connections.append(connection)

    def validate(self) -> bool:
        station_ids = set(self.stations.keys())
        for conn in self.connections:
            if conn.from_station_id not in station_ids or conn.to_station_id not in station_ids:
                return False
        return True

