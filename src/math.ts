export function sum(options: { values: number[] }): number {
  const { values } = options
  return values.reduce((total, value) => total + value, 0)
}
// behind 20261021-181010
