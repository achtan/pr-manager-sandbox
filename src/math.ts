export function sum(options: { values: number[] }): number {
  const { values } = options
  return values.reduce((total, value) => total + value, 0)
}

export const broken: string = 'not a number (20261021-192325)'
