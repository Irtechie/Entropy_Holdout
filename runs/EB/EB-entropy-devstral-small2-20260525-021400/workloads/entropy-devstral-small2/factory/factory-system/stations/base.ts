import { Station } from '../core/types';
import { BaseComponent } from '../components/base';

export abstract class BaseStation extends BaseComponent implements Station {
  constructor(
    public id: string,
    public name: string,
    public type: 'assembly' | 'processing' | 'quality' | 'storage',
    public capacity: number,
    public currentLoad: number = 0,
    description?: string
  ) {
    super(id, name, description);
  }
  
  abstract process(): void;
  
  addToLoad(amount: number): void {
    this.currentLoad += amount;
    if (this.currentLoad > this.capacity) {
      throw new Error('Station capacity exceeded');
    }
  }
  
  removeFromLoad(amount: number): void {
    this.currentLoad -= amount;
    if (this.currentLoad < 0) {
      throw new Error('Station load cannot be negative');
    }
  }
}
