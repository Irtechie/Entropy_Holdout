export interface Product {
  id: string;
  name: string;
  version: string;
  requiredComponents: string[];
  routingId: string;
  status: 'pending' | 'in_progress' | 'completed' | 'failed';
}
