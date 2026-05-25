import { Station } from '../src/station';
import { Product } from '../src/product';
import { Component } from '../src/component';
import { Routing } from '../src/routing';

export const stationA: Station = { id: 'A', name: 'Station A' };
export const stationB: Station = { id: 'B', name: 'Station B' };
export const stationC: Station = { id: 'C', name: 'Station C' };

export const componentX: Component = { id: 'X', name: 'Component X' };

export const productY: Product = { id: 'Y', name: 'Product Y' };

export const routingAB: Routing = { from: stationA, to: stationB, component: componentX, product: productY };
export const routingBC: Routing = { from: stationB, to: stationC, component: componentX, product: productY };

export const routingFlow: Routing[] = [routingAB, routingBC];
