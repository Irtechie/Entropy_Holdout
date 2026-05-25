export interface Component {
  id: string;
  name: string;
  type: string;
  status: 'idle' | 'active' | 'error' | 'offline';
  metadata?: Record<string, any>;
}
