import { AssemblyStation } from './stations/assembly';
import { ProcessingStation } from './stations/processing';
import { QualityStation } from './stations/quality';
import { StorageStation } from './stations/storage';
import { ProductRoute } from './routing/route';
import { ExampleProduct } from './products/product';
import stationsConfig from './config/stations.json';
import routesConfig from './config/routes.json';
import productsConfig from './config/products.json';

// Create stations from config
const stations: any = {};
stationsConfig.stations.forEach(station => {
  switch(station.type) {
    case 'assembly':
      stations[station.id] = new AssemblyStation(station.id, station.name, station.capacity, station.description);
      break;
    case 'processing':
      stations[station.id] = new ProcessingStation(station.id, station.name, station.capacity, station.description);
      break;
    case 'quality':
      stations[station.id] = new QualityStation(station.id, station.name, station.capacity, station.description);
      break;
    case 'storage':
      stations[station.id] = new StorageStation(station.id, station.name, station.capacity, station.description);
      break;
  }
});

// Create product from config
const products: any = {};
productsConfig.products.forEach(product => {
  products[product.id] = new ExampleProduct();
});

// Create routes from config
const routes: any = {};
routesConfig.routes.forEach(route => {
  routes[route.id] = new ProductRoute(route.id, route.name, route.stations, route.productId);
});

// Execute route
routes['route-001'].execute();

// Process product through stations
routesConfig.routes[0].stations.forEach(stationId => {
  stations[stationId].process();
});

console.log('Factory operations completed');
