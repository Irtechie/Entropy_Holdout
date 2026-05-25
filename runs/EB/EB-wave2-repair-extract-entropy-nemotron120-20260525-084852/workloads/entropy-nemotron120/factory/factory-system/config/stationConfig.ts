export const stations = [
  { id: 'station-1', location: 'Assembly Line A' },
  { id: 'station-2', location: 'Assembly Line B' },
  { id: 'station-3', location: 'Quality Control' },
  { id: 'station-4', location: 'Packaging' }
];

export const productRouting = {
  id: 'product-routing-001',
  steps: stations.map(s => s.id)
};
