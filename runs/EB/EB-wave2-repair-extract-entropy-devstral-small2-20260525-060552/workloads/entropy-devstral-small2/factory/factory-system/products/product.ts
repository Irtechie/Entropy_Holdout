import { BaseProduct } from './base';

export class ExampleProduct extends BaseProduct {
  constructor() {
    super(
      'prod-001',
      'Example Product',
      ['comp-001', 'comp-002'],
      10,
      'A sample product for testing'
    );
  }
  
  assemble(): void {
    console.log(`Assembling ${this.name} with components: ${this.components.join(', ')}`);
  }
}
