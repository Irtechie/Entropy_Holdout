import { v4 as uuidv4 } from 'uuid';
import { Component, EntityId } from '../types';

export class ComponentModel {
  private static components: Map<EntityId, Component> = new Map();

  static create(data: Omit<Component, 'id' | 'createdAt' | 'updatedAt'>): Component {
    const now = new Date();
    const component: Component = {
      id: uuidv4(),
      ...data,
      createdAt: now,
      updatedAt: now
    };
    this.components.set(component.id, component);
    return component;
  }

  static findById(id: EntityId): Component | undefined {
    return this.components.get(id);
  }

  static findAll(): Component[] {
    return Array.from(this.components.values());
  }

  static update(id: EntityId, data: Partial<Omit<Component, 'id' | 'createdAt'>>): Component | undefined {
    const existing = this.components.get(id);
    if (!existing) return undefined;
    
    const updated: Component = {
      ...existing,
      ...data,
      updatedAt: new Date()
    };
    this.components.set(id, updated);
    return updated;
  }

  static delete(id: EntityId): boolean {
    return this.components.delete(id);
  }

  static clear(): void {
    this.components.clear();
  }
}

