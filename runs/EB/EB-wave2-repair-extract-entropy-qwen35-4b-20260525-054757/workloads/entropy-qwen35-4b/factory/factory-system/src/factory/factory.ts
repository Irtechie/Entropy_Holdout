import { Component } from '../components/component';
import { Station } from '../stations/station';
import { Product } from '../products/product';
import { Routing } from '../routing/routing';
import { Stations } from '../stations/stations';
import { StationGraph } from '../stations/stations';

export class Factory {
  components: Component[];
  stations: Station[];
  products: Product[];
  routing: Routing;
  stationGraph: StationGraph;

  constructor() {
    this.components = [];
    this.stations = [];
    this.products = [];
    this.routing = null;
    this.stationGraph = new StationGraph();
  }

  addStation(station: Station): void {
    this.stations.push(station);
  }

  addProduct(product: Product): void {
    this.products.push(product);
  }

  setRouting(source: string, destination: string, path: string[]): void {
    this.routing = new Routing(source, destination, path);
  }

  canRoute(): boolean {
    return this.routing !== null && this.routing.canExecute();
  }

  executeRoute(): boolean {
    if (!this.canRoute()) return false;
    return this.routing.execute();
  }
}

