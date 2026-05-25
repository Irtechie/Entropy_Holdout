import { Station } from '../src/stations/station';

export interface StationConfig {
  id: string;
  name: string;
  capacity: number;
}

export interface DependenciesConfig {
  [key: string]: string[];
}

export interface StationsConfig {
  stations: StationConfig[];
  dependencies: DependenciesConfig;
}

export interface RouteConfig {
  source: string;
  destination: string;
  path: string[];
}

export interface RoutingConfig {
  routes: RouteConfig[];
}

export interface Config {
  stations: StationsConfig;
  routing: RoutingConfig;
}

export class ConfigLoader {
  private stations: StationsConfig;
  private routing: RoutingConfig;

  constructor(stations: StationsConfig, routing: RoutingConfig) {
    this.stations = stations;
    this.routing = routing;
  }

  getStations(): StationsConfig {
    return this.stations;
  }

  getRouting(): RoutingConfig {
    return this.routing;
  }

  getStation(id: string): Station | undefined {
    const station = this.stations.stations.find(s => s.id === id);
    if (!station) return undefined;
    return new Station(station.id, station.name, station.capacity);
  }

  getRoute(source: string, destination: string): RouteConfig | undefined {
    return this.routing.routes.find(r => r.source === source && r.destination === destination);
  }
}

