import { Station } from './src/types/station';
import { Routing } from './src/types/routing';

export const stations: Station[] = [
  { id: 's1', location: 'Assembly Line 1' },
  { id: 's2', location: 'Assembly Line 2' },
  { id: 's3', location: 'Quality Check' },
  { id: 's4', location: 'Packaging' }
];

export const productRouting: Routing = {
  id: 'routing-1',
  steps: ['s1', 's2', 's3', 's4']
};
