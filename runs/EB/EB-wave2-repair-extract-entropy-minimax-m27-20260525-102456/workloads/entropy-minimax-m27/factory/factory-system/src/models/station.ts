import { v4 as uuidv4 } from 'uuid';
import { Station, StationType, StationStatus, EntityId } from '../types';

export class StationModel {
  private static stations: Map<EntityId, Station> = new Map();

  static create(data: Omit<Station, 'id' | 'createdAt' | 'updatedAt'>): Station {
    const now = new Date();
    const station: Station = {
      id: uuidv4(),
      ...data,
      createdAt: now,
      updatedAt: now
    };
    this.stations.set(station.id, station);
    return station;
  }

  static findById(id: EntityId): Station | undefined {
    return this.stations.get(id);
  }

  static findByType(type: StationType): Station[] {
    return Array.from(this.stations.values()).filter(s => s.type === type);
  }

  static findByStatus(status: StationStatus): Station[] {
    return Array.from(this.stations.values()).filter(s => s.status === status);
  }

  static findAll(): Station[] {
    return Array.from(this.stations.values());
  }

  static update(id: EntityId, data: Partial<Omit<Station, 'id' | 'createdAt'>>): Station | undefined {
    const existing = this.stations.get(id);
    if (!existing) return undefined;
    
    const updated: Station = {
      ...existing,
      ...data,
      updatedAt: new Date()
    };
    this.stations.set(id, updated);
    return updated;
  }

  static delete(id: EntityId): boolean {
    return this.stations.delete(id);
  }

  static clear(): void {
    this.stations.clear();
  }
}

