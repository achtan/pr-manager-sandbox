export const greeting = 'hello'

export function greet(options: { name: string }): string {
  const { name } = options
  return `${greeting}, ${name}`
}
