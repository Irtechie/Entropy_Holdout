import { BaseRoute } from './base';
import { Station } from '../core/types';

export class ProductRoute extends BaseRoute {
  constructor(
    id: string,
    name: string,
    public stations: Station[],
    productId: string
  ) {
    super(id, name, stations.map(s => s.id), productId);
  }
  
  execute(): void {
    console.log(`Starting route ${this.name} for product ${this.productId}`);
    this.stations.forEach(station => {
      console.log(`Processing at ${station.name}`);
      station.process();
    });
    console.log(`Route ${this.name} completed`);
  }
}
