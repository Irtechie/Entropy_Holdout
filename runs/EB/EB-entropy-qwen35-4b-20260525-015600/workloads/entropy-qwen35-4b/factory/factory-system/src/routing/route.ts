import { Station } from '../stations/station';
import { Product } from '../products/product';
import { Routing } from './routing';

export class Route {
  sourceStation: Station;
  destinationStation: Station;
  product: Product;
  path: string[];

  constructor(source: Station, destination: Station, product: Product) {
    this.sourceStation = source;
    this.destinationStation = destination;
    this.product = product;
    this.path = [source.id, destination.id];
  }

  execute(): boolean {
    if (this.sourceStation.id === this.destinationStation.id) {
      return false;
    }
    return true;
  }

  getRouting(): Routing {
    return {
      source: this.sourceStation.id,
      destination: this.destinationStation.id,
      path: this.path,
    };
  }
}

