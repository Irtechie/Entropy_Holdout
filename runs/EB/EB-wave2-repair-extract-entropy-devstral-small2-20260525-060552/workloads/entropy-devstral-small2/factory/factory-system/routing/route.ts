import { BaseRoute } from './base';
import { Station } from '../core/types';

export class ProductRoute extends BaseRoute {
  constructor(
    id: string,
    name: string,
    stations: string[],
    productId: string
  ) {
    super(id, name, stations, productId);
  }
  
  execute(): void {
    console.log(`Executing route ${this.name} for product ${this.productId}`);
    console.log(`Stations: ${this.stations.join(' -> ')}`);
  }
}
