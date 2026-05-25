import { Station, Product, Routing } from '../src/types';

export class StationManager {
  constructor(private stations: Station[]) {}

  async moveProduct(product: Product, routing: Routing): Promise<void> {
    const sortedSteps = [...routing.steps].sort((a, b) => a.sequence - b.sequence);

    for (const step of sortedSteps) {
      const station = this.stations.find(s => s.id === step.stationId);
      if (!station) {
        throw new Error(`Station ${step.stationId} not found in the factory configuration`);
      }

      // Mark station as busy and assign product
      station.status = 'busy';
      station.currentProductId = product.id;

      // Simulate the operation taking place
      await new Promise(resolve => setTimeout(resolve, 10));

      // Mark station as idle and clear product
      station.status = 'idle';
      station.currentProductId = undefined;
    }
  }
}
