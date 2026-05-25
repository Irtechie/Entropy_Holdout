import { Component, Station, Product, Routing } from '../types';

export class FactorySystem {
  private components: Map<string, Component> = new Map();
  private stations: Map<string, Station> = new Map();
  private products: Map<string, Product> = new Map();
  private routings: Map<string, Routing> = new Map();

  registerComponent(component: Component): void {
    this.components.set(component.id, component);
  }

  registerStation(station: Station): void {
    this.stations.set(station.id, station);
  }

  registerProduct(product: Product): void {
    this.products.set(product.id, product);
  }

  registerRouting(routing: Routing): void {
    this.routings.set(routing.id, routing);
  }

  getComponent(id: string): Component | undefined {
    return this.components.get(id);
  }

  getStation(id: string): Station | undefined {
    return this.stations.get(id);
  }

  getProduct(id: string): Product | undefined {
    return this.products.get(id);
  }

  getRouting(id: string): Routing | undefined {
    return this.routings.get(id);
  }
}
