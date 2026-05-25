export interface MathOperations {
  add(a: number, b: number): number;
  multiply(a: number, b: number): number;
  power(a: number, b: number): number;
}

export const MathOperations: MathOperations = {
  add: (a, b) => a + b,
  multiply: (a, b) => a * b,
  power: (a, b) => Math.pow(a, b)
};

