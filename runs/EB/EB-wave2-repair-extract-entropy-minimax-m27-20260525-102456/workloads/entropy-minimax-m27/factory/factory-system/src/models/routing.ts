import { v4 as uuidv4 } from 'uuid';
import { Routing, RoutingStep, EntityId } from '../types';

export class RoutingModel {
  private static routings: Map<EntityId, Routing> = new Map();

  static create(data: Omit<Routing, 'id' | 'createdAt' | 'updatedAt'>): Routing {
    const now = new Date();
    const routing: Routing = {
      id: uuidv4(),
      ...data,
      createdAt: now,
      updatedAt: now
    };
    this.routings.set(routing.id, routing);
    return routing;
  }

  static findById(id: EntityId): Routing | undefined {
    return this.routings.get(id);
  }

  static findByProductId(productId: EntityId): Routing[] {
    return Array.from(this.routings.values()).filter(r => r.productId === productId);
  }

  static findActiveByProductId(productId: EntityId): Routing | undefined {
    return Array.from(this.routings.values()).find(
      r => r.productId === productId && r.isActive
    );
  }

  static findAll(): Routing[] {
    return Array.from(this.routings.values());
  }

  static addStep(routingId: EntityId, step: RoutingStep): Routing | undefined {
    const existing = this.routings.get(routingId);
    if (!existing) return undefined;
    
    const updated: Routing = {
      ...existing,
      steps: [...existing.steps, step],
      updatedAt: new Date()
    };
    this.routings.set(routingId, updated);
    return updated;
  }

  static update(id: EntityId, data: Partial<Omit<Routing, 'id' | 'createdAt'>>): Routing | undefined {
    const existing = this.routings.get(id);
    if (!existing) return undefined;
    
    const updated: Routing = {
      ...existing,
      ...data,
      updatedAt: new Date()
    };
    this.routings.set(id, updated);
    return updated;
  }

  static delete(id: EntityId): boolean {
    return this.routings.delete(id);
  }

  static clear(): void {
    this.routings.clear();
  }
}

