import { Station } from './station';

export class Stations {
  stations: Station[];

  constructor() {
    this.stations = [
      new Station('station-1', 'Assembly Station', 100),
      new Station('station-2', 'Quality Check Station', 50),
      new Station('station-3', 'Packaging Station', 75)
    ];
  }

  getStation(id: string): Station | undefined {
    return this.stations.find(s => s.id === id);
  }

  getAllStations(): Station[] {
    return this.stations;
  }
}

export class StationGraph {
  stations: Station[];
  dependencies: Map<string, string[]>;

  constructor() {
    this.stations = [
      new Station('station-1', 'Assembly Station', 100),
      new Station('station-2', 'Quality Check Station', 50),
      new Station('station-3', 'Packaging Station', 75)
    ];
    this.dependencies = new Map();
    this.dependencies.set('station-1', []);
    this.dependencies.set('station-2', ['station-1']);
    this.dependencies.set('station-3', ['station-2']);
  }

  isValid(): boolean {
    const visited = new Set<string>();
    const queue = [this.stations[0].id];
    
    while (queue.length > 0) {
      const current = queue.shift();
      if (visited.has(current)) continue;
      visited.add(current);
      
      const deps = this.dependencies.get(current) || [];
      for (const dep of deps) {
        if (!visited.has(dep)) {
          queue.push(dep);
        }
      }
    }
    
    return visited.size === this.stations.length;
  }
}

