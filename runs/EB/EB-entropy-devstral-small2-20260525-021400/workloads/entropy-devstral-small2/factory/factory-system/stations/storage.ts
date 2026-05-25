import { BaseStation } from './base';

export class StorageStation extends BaseStation {
  constructor(
    id: string,
    name: string,
    capacity: number,
    description?: string
  ) {
    super(id, name, 'storage', capacity, 0, description);
  }
  
  process(): void {
    console.log(`${this.name} is storing products`);
    this.addToLoad(1);
  }
}
