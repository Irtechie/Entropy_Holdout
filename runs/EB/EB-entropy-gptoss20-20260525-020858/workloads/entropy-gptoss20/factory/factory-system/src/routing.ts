import { Component } from './component';
import { Station } from './station';
import { Product } from './product';

export interface Routing {
  from: Station;
  to: Station;
  component: Component;
  product: Product;
}

