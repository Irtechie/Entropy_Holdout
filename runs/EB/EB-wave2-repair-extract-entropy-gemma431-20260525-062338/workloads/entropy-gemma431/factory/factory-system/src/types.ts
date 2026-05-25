export interface Component {
  id: string;
  name: string;
  type: string;
  properties: Record<string, any>;
}

export interface Station {
  id: string;
  name: string;
  capabilities: string[];
  status: 'idle' | 'busy' | 'offline';
  currentProductId?: string;
}

export interface Product {
  id: string;
  sku: string;
  name: string;
  requiredComponents: string[];
}

export interface Routing {
  productId: string;
  steps: { 
    stationId: string; 
    operation: string; 
    sequence: number; 
  }[];
}

