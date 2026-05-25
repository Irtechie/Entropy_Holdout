/**
 * Factory System
 * 
 * A manufacturing system that manages:
 * - Components: Raw materials and parts
 * - Stations: Workstations for manufacturing operations
 * - Products: Final products being manufactured
 * - Routings: Process flows through stations
 */

export * from './types';
export { ComponentModel } from './models/component';
export { StationModel } from './models/station';
export { ProductModel } from './models/product';
export { RoutingModel } from './models/routing';

import { ComponentModel } from './models/component';
import { StationModel } from './models/station';
import { ProductModel } from './models/product';
import { RoutingModel } from './models/routing';

/**
 * FactorySystem class provides a unified interface for managing
 * all factory entities
 */
export class FactorySystem {
  components = ComponentModel;
  stations = StationModel;
  products = ProductModel;
  routings = RoutingModel;

  /**
   * Reset all factory data
   */
  reset(): void {
    ComponentModel.clear();
    StationModel.clear();
    ProductModel.clear();
    RoutingModel.clear();
  }
}

export default FactorySystem;

