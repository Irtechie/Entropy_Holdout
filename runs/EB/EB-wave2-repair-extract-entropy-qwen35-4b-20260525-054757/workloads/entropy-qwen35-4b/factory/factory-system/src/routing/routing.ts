import { Station } from '../stations/station';
import { Product } from '../products/product';

export class Routing {
  source: string;
  destination: string;
  path: string[];

  constructor(source: string, destination: string, path: string[]) {
    this.source = source;
    this.destination = destination;
    this.path = path;
  }

  canExecute(): boolean {
    return this.path.length > 0 && this.path[this.path.length - 1] === this.destination;
  }

  execute(): boolean {
    if (!this.canExecute()) return false;
    
    for (let i = 0; i < this.path.length; i++) {
      const stationId = this.path[i];
      const station = this.getStation(stationId);
      if (!station) return false;
    }
    
    return true;
  }

  getStation(id: string): Station | undefined {
    return this.getStationFromPath(id);
  }

  getStationFromPath(id: string): Station | undefined {
    const station = this.path.find(s => s === id);
    if (!station) return undefined;
    
    const stations = [
      { id: 'station-1', name: 'Assembly Station', capacity: 100 },
      { id: 'station-2', name: 'Quality Check Station', capacity: 50 },
      { id: 'station-3', name: 'Packaging Station', capacity: 75 }
    ];
    
    return stations.find(s => s.id === station);
  }
}

