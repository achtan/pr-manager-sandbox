export const greeting = 'hi from conflict 20261021-192325'

export function greet(options: { name: string }): string {
  const { name } = options
  return `${greeting}, ${name}`
}
