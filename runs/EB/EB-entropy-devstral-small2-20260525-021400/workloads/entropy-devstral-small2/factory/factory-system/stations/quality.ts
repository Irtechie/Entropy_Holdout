import { BaseStation } from './base';

export class QualityStation extends BaseStation {
  constructor(
    id: string,
    name: string,
    capacity: number,
    description?: string
  ) {
    super(id, name, 'quality', capacity, 0, description);
  }
  
  process(): void {
    console.log(`${this.name} is performing quality checks`);
    this.addToLoad(1);
  }
}
