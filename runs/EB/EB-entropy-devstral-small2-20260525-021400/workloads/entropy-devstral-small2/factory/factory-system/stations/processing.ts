import { BaseStation } from './base';

export class ProcessingStation extends BaseStation {
  constructor(
    id: string,
    name: string,
    capacity: number,
    description?: string
  ) {
    super(id, name, 'processing', capacity, 0, description);
  }
  
  process(): void {
    console.log(`${this.name} is processing materials`);
    this.addToLoad(1);
  }
}
