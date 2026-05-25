/**
 * Core type definitions for the Factory System
 */

// Unique identifier type
export type EntityId = string;

// Component: Raw materials or parts used in manufacturing
export interface Component {
  id: EntityId;
  name: string;
  description: string;
  unitOfMeasure: string;
  quantity: number;
  createdAt: Date;
  updatedAt: Date;
}

// Station: Workstation where manufacturing operations occur
export interface Station {
  id: EntityId;
  name: string;
  description: string;
  type: StationType;
  capacity: number;
  status: StationStatus;
  createdAt: Date;
  updatedAt: Date;
}

export enum StationType {
  ASSEMBLY = 'ASSEMBLY',
  MACHINING = 'MACHINING',
  PAINTING = 'PAINTING',
  PACKAGING = 'PACKAGING',
  QUALITY_CONTROL = 'QUALITY_CONTROL',
  WAREHOUSE = 'WAREHOUSE'
}

export enum StationStatus {
  IDLE = 'IDLE',
  OPERATIONAL = 'OPERATIONAL',
  MAINTENANCE = 'MAINTENANCE',
  OFFLINE = 'OFFLINE'
}

// Product: Final output being manufactured
export interface Product {
  id: EntityId;
  name: string;
  description: string;
  sku: string;
  components: ProductComponent[];
  createdAt: Date;
  updatedAt: Date;
}

export interface ProductComponent {
  componentId: EntityId;
  quantityRequired: number;
}

// Routing: Process flow defining how products are manufactured through stations
export interface Routing {
  id: EntityId;
  name: string;
  description: string;
  productId: EntityId;
  steps: RoutingStep[];
  isActive: boolean;
  createdAt: Date;
  updatedAt: Date;
}

export interface RoutingStep {
  stepNumber: number;
  stationId: EntityId;
  stationType: StationType;
  durationMinutes: number;
  sequenceOrder: number;
}

// Factory System main export
export interface FactorySystem {
  components: Map<EntityId, Component>;
  stations: Map<EntityId, Station>;
  products: Map<EntityId, Product>;
  routings: Map<EntityId, Routing>;
}

