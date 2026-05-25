import { Station } from "./station";
import { Product } from "./product";
import { Routing } from "./routing";

export const stations: Station[] = [
  { id: "s1", name: "Station 1", location: "A" },
  { id: "s2", name: "Station 2", location: "B" },
  { id: "s3", name: "Station 3", location: "C" }
];

export const product: Product = {
  id: "p1",
  name: "Widget",
  sku: "WGT-001"
};

export const routings: Routing[] = [
  { id: "r1", fromStationId: "s1", toStationId: "s2", productId: "p1" },
  { id: "r2", fromStationId: "s2", toStationId: "s3", productId: "p1" }
];

