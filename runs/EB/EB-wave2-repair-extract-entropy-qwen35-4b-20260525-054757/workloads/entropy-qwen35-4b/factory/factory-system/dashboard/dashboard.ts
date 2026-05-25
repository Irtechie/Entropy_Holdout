import { Station } from '../src/stations/station';
import { Product } from '../src/products/product';
import { Factory } from '../src/factory/factory';

export interface DashboardStats {
  totalStations: number;
  totalProducts: number;
  activeRoutes: number;
  throughput: number;
}

export interface StationReport {
  id: string;
  name: string;
  capacity: number;
  currentLoad: number;
  status: 'idle' | 'processing' | 'completed';
}

export interface ProductReport {
  id: string;
  name: string;
  specifications: Record<string, any>;
  currentLocation: string;
  status: 'in-progress' | 'completed' | 'failed';
}

export class Dashboard {
  private factory: Factory;
  private stats: DashboardStats;

  constructor(factory: Factory) {
    this.factory = factory;
    this.stats = this.calculateStats();
  }

  private calculateStats(): DashboardStats {
    return {
      totalStations: this.factory.stations.length,
      totalProducts: this.factory.products.length,
      activeRoutes: this.factory.routing ? 1 : 0,
      throughput: this.factory.stations.reduce((sum, station) => sum + station.capacity, 0)
    };
  }

  getStationReport(stationId: string): StationReport | undefined {
    const station = this.factory.getStation(stationId);
    if (!station) return undefined;
    
    return {
      id: station.id,
      name: station.name,
      capacity: station.capacity,
      currentLoad: 0,
      status: 'idle'
    };
  }

  getProductReport(productId: string): ProductReport | undefined {
    const product = this.factory.products.find(p => p.id === productId);
    if (!product) return undefined;
    
    return {
      id: product.id,
      name: product.name,
      specifications: product.specifications,
      currentLocation: 'pending',
      status: 'in-progress'
    };
  }

  getFullReport(): {
    stats: DashboardStats;
    stations: StationReport[];
    products: ProductReport[];
  } {
    const stationReports = this.factory.stations.map(s => ({
      id: s.id,
      name: s.name,
      capacity: s.capacity,
      currentLoad: 0,
      status: 'idle'
    }));

    const productReports = this.factory.products.map(p => ({
      id: p.id,
      name: p.name,
      specifications: p.specifications,
      currentLocation: 'pending',
      status: 'in-progress'
    }));

    return {
      stats: this.stats,
      stations: stationReports,
      products: productReports
    };
  }

  executeRoute(): boolean {
    return this.factory.executeRoute();
  }
}

