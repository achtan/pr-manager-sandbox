export const greeting = 'hi from conflict 20261021-181010'

export function greet(options: { name: string }): string {
  const { name } = options
  return `${greeting}, ${name}`
}
