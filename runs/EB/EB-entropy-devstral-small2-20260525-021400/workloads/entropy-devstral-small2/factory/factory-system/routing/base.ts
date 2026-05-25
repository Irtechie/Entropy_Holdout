import { Route } from '../core/types';

export abstract class BaseRoute implements Route {
  constructor(
    public id: string,
    public name: string,
    public stations: string[],
    public productId: string
  ) {}
  
  abstract execute(): void;
}
