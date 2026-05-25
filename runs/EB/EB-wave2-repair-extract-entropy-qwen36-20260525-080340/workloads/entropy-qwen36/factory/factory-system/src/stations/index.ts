import { readFileSync } from 'fs';
import { join } from 'path';
import { Station, Product, Routing } from '../types';

const configPath = join(__dirname, '../../config/stations.json');
const config = JSON.parse(readFileSync(configPath, 'utf-8'));

export const stationGraph: Station[] = config.stationGraph;
export const routingFlow: Routing = config.routingFlow;

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
