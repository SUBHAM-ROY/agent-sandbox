---
name: create-worktree
description: >
  Create a git worktree for a branch name (local, remote-only, or new). Use when
  asked to create a worktree, check out a branch in a worktree, or similar.
argument-hint: [branch-name]
arguments: [branch]
---

# Create Worktree

Never detached HEAD. Input: branch name (`$branch`).
`$dir` = `$branch` with `/` → `-` (so `abc/efg` → `abc-efg`). Git refs stay `$branch`. Path is never nested.

## Already there
`git worktree list`. If `$branch` matches a worktree (branch name or dir basename, including `$dir`) → report that path. Stop.
Git allows one worktree per branch. If add fails because it's already checked out, report that path. Don't force.

## Fetch
`git fetch origin $branch` (ok if the ref is missing).
Then check `refs/heads/$branch` and `refs/remotes/origin/$branch`.

## Path
`.worktrees/$dir` at the repo root. If that path exists and is not a worktree, stop and say so.

## Create
- Local exists → `git worktree add .worktrees/$dir $branch`. No upstream and `origin/$branch` exists → `git branch --set-upstream-to=origin/$branch $branch`. Local + remote counts as local. Don't reset.
- Remote only → `git worktree add --track -b $branch .worktrees/$dir origin/$branch`.
- Nowhere → `origin/master` if it exists, else `origin/main` → `git worktree add -b $branch .worktrees/$dir origin/<default>`. No upstream until first `git push -u`.

## Confirm
Branch, tracking (`git status -sb` in the worktree), path.
