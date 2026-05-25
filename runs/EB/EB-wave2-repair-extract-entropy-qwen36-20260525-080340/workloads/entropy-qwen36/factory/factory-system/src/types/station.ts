export interface Station {
  id: string;
  name: string;
  components: string[];
  capacity: number;
  state: 'running' | 'stopped' | 'maintenance' | 'error';
  throughput?: number;
}
