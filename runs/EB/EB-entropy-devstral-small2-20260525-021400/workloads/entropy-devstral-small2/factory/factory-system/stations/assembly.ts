import { BaseStation } from './base';

export class AssemblyStation extends BaseStation {
  constructor(
    id: string,
    name: string,
    capacity: number,
    description?: string
  ) {
    super(id, name, 'assembly', capacity, 0, description);
  }
  
  process(): void {
    console.log(`${this.name} is assembling components`);
    this.addToLoad(1);
  }
}
