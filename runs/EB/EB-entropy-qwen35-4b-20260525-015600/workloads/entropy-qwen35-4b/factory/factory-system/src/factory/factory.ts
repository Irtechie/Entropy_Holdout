import { Component } from '../components/component';
import { Station } from '../stations/station';
import { Product } from '../products/product';
import { Routing } from '../routing/routing';
import { Route } from '../routing/route';
import { Stations } from '../stations/stations';

export class Factory {
  components: Component[];
  stations: Station[];
  products: Product[];
  routing: Routing;
  stationsManager: Stations;

  constructor() {
    this.components = [];
    this.stations = [];
    this.products = [];
    this.routing = null;
    this.stationsManager = new Stations();
  }

  addStation(station: Station): void {
    this.stations.push(station);
  }

  addProduct(product: Product): void {
    this.products.push(product);
  }

  createRoute(sourceId: string, destinationId: string, product: Product): Route | null {
    const source = this.stationsManager.getStation(sourceId);
    const destination = this.stationsManager.getStation(destinationId);

    if (!source || !destination) {
      return null;
    }

    return new Route(source, destination, product);
  }

  getRouting(): Routing {
    if (this.routing) {
      return this.routing;
    }
    return {
      source: 'S1',
      destination: 'S3',
      path: ['S1', 'S2', 'S3'],
    };
  }
}

