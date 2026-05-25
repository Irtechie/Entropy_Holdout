import { stations, productRouting } from '../../config/stationConfig';

export function generateDashboard() {
  return {
    stationCount: stations.length,
    stations: stations.map(s => ({ id: s.id, location: s.location })),
    routing: productRouting,
  };
}
