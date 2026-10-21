# pr-manager-sandbox

Toy repo for exercising a dev instance of pr-manager (jigx-com/ai-tooling `packages/pr-manager`). Its PRs are
throwaway scenarios from `scripts/scenarios.sh`; nothing here ships.

- Check: `bun install && bun run typecheck`. CI runs the same as the `typecheck` check, required on `main` together
  with being up to date.
- Prefer a single `options` object parameter, destructured on the first line.
