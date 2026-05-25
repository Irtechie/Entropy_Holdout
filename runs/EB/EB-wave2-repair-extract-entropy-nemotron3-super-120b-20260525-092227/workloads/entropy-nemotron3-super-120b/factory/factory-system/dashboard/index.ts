import { stations } from '../stations/stations';
import { productRouting } from '../stations/routing';
import { Product } from '../types/product';

// Simulate some throughput data (in a real system, this would come from a database or metrics)
const throughputPerStation = 5; // units per minute

// Simulate product state: we don't have any products, so we show an empty array
const productState: Product[] = []; // No products in the system

export function generateDashboardReport() {
  return {
    factoryConfiguration: {
      stations: stations.map(s => ({ id: s.id, location: s.location })),
      routing: {
        id: productRouting.id,
        steps: productRouting.steps
      }
    },
    throughput: {
      unitsPerMinutePerStation: throughputPerStation,
      totalUnitsPerMinute: throughputPerStation * stations.length
    },
    productState: {
      totalProducts: productState.length,
      products: productState
    }
  };
}

// If this script is run directly, print the report
if (require.main === module) {
  const report = generateDashboardReport();
  console.log(JSON.stringify(report, null, 2));}

