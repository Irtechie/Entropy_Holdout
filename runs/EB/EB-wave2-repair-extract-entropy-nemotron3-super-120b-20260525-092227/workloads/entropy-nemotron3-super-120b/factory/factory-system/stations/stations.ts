import { Station } from '../types/station';

// Load stations from configuration
const stationsData = require('../config/stations.json');
export const stations: Station[] = stationsData;
