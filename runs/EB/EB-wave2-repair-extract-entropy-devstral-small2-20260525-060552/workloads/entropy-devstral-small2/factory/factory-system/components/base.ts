import { Component } from '../core/types';

export abstract class BaseComponent implements Component {
  constructor(public id: string, public name: string, public description?: string) {}
  
  abstract operate(): void;
}
