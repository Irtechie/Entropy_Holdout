import { Product } from '../core/types';

export abstract class BaseProduct implements Product {
  constructor(
    public id: string,
    public name: string,
    public components: string[],
    public assemblyTime: number,
    public description?: string
  ) {}
  
  abstract assemble(): void;
}
