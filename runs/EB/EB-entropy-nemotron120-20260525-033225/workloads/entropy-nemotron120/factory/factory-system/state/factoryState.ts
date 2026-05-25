import { Station } from '../types/station';
import { stations } from '../stations/stations';

export interface StationState extends Station {
  currentProductId: string | null;
  throughput: number;
}

export const factoryState: StationState[] = stations.map(station => ({
  ...station,
  currentProductId: null,
  throughput: 0
}));
