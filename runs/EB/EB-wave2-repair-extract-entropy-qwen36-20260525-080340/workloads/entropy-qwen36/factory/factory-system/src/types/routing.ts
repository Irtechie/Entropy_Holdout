export interface Routing {
  id: string;
  name: string;
  sequence: string[];
  conditions: Record<string, any>;
  fallback?: string;
}
