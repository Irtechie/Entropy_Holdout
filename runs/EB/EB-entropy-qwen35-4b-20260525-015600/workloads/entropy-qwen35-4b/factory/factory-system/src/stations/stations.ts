import { Station } from './station';

export class Stations {
  stations: Station[];

  constructor() {
    this.stations = [
      new Station('S1', 'Assembly Station 1', 100),
      new Station('S2', 'Assembly Station 2', 150),
      new Station('S3', 'Quality Station', 80),
    ];
  }

  getStation(id: string): Station | undefined {
    return this.stations.find(s => s.id === id);
  }

  getAllStations(): Station[] {
    return [...this.stations];
  }
}

