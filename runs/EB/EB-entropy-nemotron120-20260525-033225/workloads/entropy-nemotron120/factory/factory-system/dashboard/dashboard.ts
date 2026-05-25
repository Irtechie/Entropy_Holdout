import { factoryState } from '../state/factoryState';
import { productRouting } from '../stations/routing';

export function generateDashboardReport() {
  const totalStations = factoryState.length;
  const stationsWithProducts = factoryState.filter(s => s.currentProductId !== null).length;
  const totalThroughput = factoryState.reduce((sum, s) => sum + s.throughport, 0);
  const routingLength = productRouting.steps.length;

  return {
    totalStations,
    stationsWithProducts,
    totalThroughput,
    routingLength,
    stationDetails: factoryState.map(s => ({
      id: s.id,
      location: s.location,
      currentProductId: s.currentProductId,
      throughput: s.throughput
    }));
  }
}
