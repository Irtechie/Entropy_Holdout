import { Routing } from '../types/routing';
import { stations } from './stations';

// Load routing from configuration
const routingData = require('../config/routing.json');
export const productRouting: Routing = routingData;
