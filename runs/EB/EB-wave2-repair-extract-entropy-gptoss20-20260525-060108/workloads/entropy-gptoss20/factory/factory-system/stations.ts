import { Station } from './src/station';
import { Product } from './src/product';
import { Routing } from './src/routing';
import { Component } from './src/component';

export const stations: Station[] = [
  { id: 's1', name: 'Station 1' },
  { id: 's2', name: 'Station 2' },
  { id: 's3', name: 'Station 3' }
];

export const component: Component = { id: 'c1', name: 'Component 1' };

export const product: Product = { id: 'p1', name: 'Product 1' };

export const routing: Routing[] = [
  { from: stations[0], to: stations[1], component, product },
  { from: stations[1], to: stations[2], component, product }
];

export function runRouting(): void {
  console.log(`Starting routing for product ${product.id}`);
  for (const r of routing) {
    console.log(`Moving product ${product.id} from ${r.from.name} to ${r.to.name} using component ${r.component.name}`);
  }
  console.log(`Routing complete for product ${product.id}`);
}
