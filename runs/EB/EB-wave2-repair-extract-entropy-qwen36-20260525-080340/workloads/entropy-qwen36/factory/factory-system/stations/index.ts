import { Station, Product, Routing } from '../src/types';

export const stationGraph: Station[] = [
  { id: 'station-1', name: 'Station 1', components: ['comp-a'], capacity: 10, state: 'running' },
  { id: 'station-2', name: 'Station 2', components: ['comp-b'], capacity: 10, state: 'running' },
  { id: 'station-3', name: 'Station 3', components: ['comp-c'], capacity: 10, state: 'running' }
];

export const routingFlow: Routing = {
  id: 'route-1',
  name: 'Main Flow',
  sequence: ['station-1', 'station-2', 'station-3'],
  conditions: {}
};

export function executeRoute(product: Product, stations: Station[], route: Routing): Product {
  let result = { ...product, status: 'in_progress' as const };
  for (const step of route.sequence) {
    const station = stations.find(s => s.id === step);
    if (station) {
      result = { ...result, status: 'in_progress' };
    }
  }
  result.status = 'completed';
  return result;
}
