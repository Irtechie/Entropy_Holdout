import stationsConfig from '../config/stations.json';
import routesConfig from '../config/routes.json';
import productsConfig from '../config/products.json';

// Load configuration
const stations = stationsConfig.stations;
const routes = routesConfig.routes;
const products = productsConfig.products;

// Calculate station throughput
const stationThroughput = stations.map(station => ({
  id: station.id,
  name: station.name,
  type: station.type,
  capacity: station.capacity,
  utilization: Math.random() * 100 // Simulated utilization
}));

// Calculate product state
const productState = products.map(product => ({
  id: product.id,
  name: product.name,
  components: product.components,
  assemblyTime: product.assemblyTime,
  status: 'In Production' // Simulated status
}));

// Generate dashboard report
console.log('=== Factory Dashboard ===');
console.log('\nStation Throughput:');
stationThroughput.forEach(station => {
  console.log(`- ${station.name} (${station.type}): ${station.utilization.toFixed(1)}% utilization`);
});

console.log('\nProduct State:');
productState.forEach(product => {
  console.log(`- ${product.name}: ${product.status}`);
});

console.log('\nRoute Information:');
routes.forEach(route => {
  console.log(`- ${route.name}: ${route.stations.join(' -> ')}`);
});

console.log('\n=== Dashboard Report Complete ===');
