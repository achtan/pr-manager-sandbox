export const greeting = 'hello from main 20261021-192325'

export function greet(options: { name: string }): string {
  const { name } = options
  return `${greeting}, ${name}`
}
