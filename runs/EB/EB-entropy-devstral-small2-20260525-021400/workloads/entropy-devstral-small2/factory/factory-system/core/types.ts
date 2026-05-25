export interface Component {
  id: string;
  name: string;
  description?: string;
}

export interface Station extends Component {
  type: 'assembly' | 'processing' | 'quality' | 'storage';
  capacity: number;
  currentLoad: number;
}

export interface Product {
  id: string;
  name: string;
  description?: string;
  components: string[];
  assemblyTime: number;
}

export interface Route {
  id: string;
  name: string;
  stations: string[];
  productId: string;
}

