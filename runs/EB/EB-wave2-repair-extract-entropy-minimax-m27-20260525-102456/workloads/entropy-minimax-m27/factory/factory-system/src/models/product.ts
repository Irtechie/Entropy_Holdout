import { v4 as uuidv4 } from 'uuid';
import { Product, ProductComponent, EntityId } from '../types';

export class ProductModel {
  private static products: Map<EntityId, Product> = new Map();

  static create(data: Omit<Product, 'id' | 'createdAt' | 'updatedAt'>): Product {
    const now = new Date();
    const product: Product = {
      id: uuidv4(),
      ...data,
      createdAt: now,
      updatedAt: now
    };
    this.products.set(product.id, product);
    return product;
  }

  static findById(id: EntityId): Product | undefined {
    return this.products.get(id);
  }

  static findBySku(sku: string): Product | undefined {
    return Array.from(this.products.values()).find(p => p.sku === sku);
  }

  static findAll(): Product[] {
    return Array.from(this.products.values());
  }

  static addComponent(productId: EntityId, component: ProductComponent): Product | undefined {
    const existing = this.products.get(productId);
    if (!existing) return undefined;
    
    const updated: Product = {
      ...existing,
      components: [...existing.components, component],
      updatedAt: new Date()
    };
    this.products.set(productId, updated);
    return updated;
  }

  static update(id: EntityId, data: Partial<Omit<Product, 'id' | 'createdAt'>>): Product | undefined {
    const existing = this.products.get(id);
    if (!existing) return undefined;
    
    const updated: Product = {
      ...existing,
      ...data,
      updatedAt: new Date()
    };
    this.products.set(id, updated);
    return updated;
  }

  static delete(id: EntityId): boolean {
    return this.products.delete(id);
  }

  static clear(): void {
    this.products.clear();
  }
}

