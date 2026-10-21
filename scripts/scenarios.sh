#!/usr/bin/env bash
# Opens one labelled PR per state pr-manager acts on: conflicting, behind main, failing the typecheck check.
# Each run makes fresh branches and moves main, so it can be rerun; close old scenario PRs by hand.
# The behind PR shows BEHIND only because main requires branches to be up to date.
# Usage: scripts/scenarios.sh [label]   (default pr-manager-dev)
set -euo pipefail

label=${1:-pr-manager-dev}
stamp=$(date +%Y%m%d-%H%M%S)
cd "$(git rev-parse --show-toplevel)"

if [ -n "$(git status --porcelain)" ]; then
  echo "working tree not clean" >&2
  exit 1
fi

git switch -q main
git pull -q --ff-only

openPr() {
  local branch=$1 title=$2
  # Right after main moves, GitHub sometimes rejects a new branch with a spurious required-check error.
  for attempt in 1 2 3; do
    git push -q -u origin "$branch" && break
    [ "$attempt" = 3 ] && return 1
    sleep 5
  done
  gh pr create --head "$branch" --base main --title "$title" --body "pr-manager scenario $stamp" --label "$label"
  git switch -q main
}

# Branched before main moves: the conflict PR edits the same line as main's next commit; the behind PR doesn't.
git switch -q -c "scenario/conflict-$stamp"
sed -i.bak "s/^export const greeting = .*/export const greeting = 'hi from conflict $stamp'/" src/greeting.ts && rm src/greeting.ts.bak
git commit -q -am "Change the greeting ($stamp)"
openPr "scenario/conflict-$stamp" "Scenario: conflict ($stamp)"

git switch -q -c "scenario/behind-$stamp"
echo "// behind $stamp" >> src/math.ts
git commit -q -am "Note on sum ($stamp)"
openPr "scenario/behind-$stamp" "Scenario: behind ($stamp)"

sed -i.bak "s/^export const greeting = .*/export const greeting = 'hello from main $stamp'/" src/greeting.ts && rm src/greeting.ts.bak
git commit -q -am "Main moves on ($stamp)"
git push -q origin main

# Branched after main moved, so its only problem is the type error.
git switch -q -c "scenario/failing-check-$stamp"
cat >> src/math.ts <<TS

export const broken: number = 'not a number ($stamp)'
TS
git commit -q -am "Add a constant ($stamp)"
openPr "scenario/failing-check-$stamp" "Scenario: failing check ($stamp)"
