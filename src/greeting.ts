export const greeting = 'hello from main 20261021-181010'

export function greet(options: { name: string }): string {
  const { name } = options
  return `${greeting}, ${name}`
}
