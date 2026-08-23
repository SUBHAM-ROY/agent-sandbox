# agent-sandbox

Sandboxed opencode environment running in a rootless-ish Podman/Docker container with dropped capabilities, no-new-privileges, and a keep-id user mapping.

## Layout

- `Containerfile` — image based on `ghcr.io/anomalyco/opencode:latest`, adds git, luajit, fd, jq, python3, and the `coder` user (uid 1000).
- `compose.yaml` — service definition and all volume mounts.
- `opencode/` — persistent container-side state (config, state, cache, TUI state). Gitignored.

## What gets mounted

| Host | Container | Purpose |
|---|---|---|
| `$PWD` | `$PWD` | Workspace at the same path (keeps git worktrees happy) |
| `./opencode/config` | `/home/coder/.config/opencode` | opencode config |
| `~/.config/opencode/skills` | `/home/coder/.config/opencode/skills` | Skills (single source of truth in host user config) |
| `~/.gitconfig` | `/home/coder/.gitconfig` (ro) | Git identity |
| `./opencode/state` | `/home/coder/.local/share/opencode` | Persistent opencode state |
| `./opencode/cache` | `/home/coder/.cache/opencode` | Cache |
| `./opencode/tui-state` | `/home/coder/.local/state/opencode` | TUI state |

Anonymous volumes inside the state mount: `/home/coder/.local/share/opencode/repos` and `/home/coder/.local/share/opencode/log`.

## Setup

```bash
cd agent-sandbox
podman compose build   # or: docker compose build

# create the persistent dirs if they don't exist yet
mkdir -p opencode/config opencode/state opencode/cache opencode/tui-state
```

## Run

Run from any project directory — it is mounted as the workspace:

```bash
cd ~/Codes/some-project
podman compose -f ~/Codes/agent-sandbox/compose.yaml run --rm opencode
```

The container starts opencode with `--auto` in an interactive TTY session.
