import { Station, Product, Routing } from '../types';

export const stations: Station[] = [
  { id: 'st-1', name: 'Assembly Station', capabilities: ['assemble'], status: 'idle' },
  { id: 'st-2', name: 'Testing Station', capabilities: ['test'], status: 'idle' },
  { id: 'st-3', name: 'Packaging Station', capabilities: ['package'], status: 'idle' },
];

export const sampleProduct: Product = {
  id: 'prod-101',
  sku: 'WIDGET-X1',
  name: 'Industrial Widget',
  requiredComponents: ['comp-a', 'comp-b'],
};

export const sampleRouting: Routing = {
  productId: 'prod-101',
  steps: [
    { stationId: 'st-1', operation: 'assemble', sequence: 1 },
    { stationId: 'st-2', operation: 'test', sequence: 2 },
    { stationId: 'st-3', operation: 'package', sequence: 3 },
  ],
};
