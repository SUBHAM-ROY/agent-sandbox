# agent-sandbox

Coding agents (mainly [pi](https://pi.dev), plus opencode) in a locked-down container: non-root uid 1000, all capabilities dropped, `no-new-privileges`, read-only rootfs, and CPU/memory/pid limits. Works with Docker or Podman (via the `docker` CLI shim).

## Layout

- `Dockerfile.common` — base image (`agent-sandbox/base`): Debian + single-user Nix, git, gh, jq, ripgrep, fd, python3.
- `Dockerfile.<agent>` — one thin layer per agent on top of the base: `pi`, `opencode`, `claude`, `cursor`.
- `compose.common.yaml` — shared hardening, limits, workspace mount, tmpfs.
- `compose.<agent>.yaml` — per-agent config/state mounts.
- `build.sh` — builds the base, then the requested agent images.
- `run-container.sh` — runs an agent against the current directory.

## Setup

```bash
./build.sh                  # base + pi + opencode
./build.sh claude cursor    # base + any other agents

mkdir -p ~/.agent-sandbox/pi/settings \
         ~/.agent-sandbox/gh \
         ~/.agent-sandbox/opencode/config/skills \
         ~/.agent-sandbox/opencode/{state,cache,tui-state}
```

`opencode/config/skills` must exist up front: the config dir is mounted read-only, so the runtime can't create the skills mount point inside it.

## Run

From any project directory:

```bash
~/Codes/agent-sandbox/run-container.sh pi
~/Codes/agent-sandbox/run-container.sh opencode
```

Extra args are passed to the agent's command. The container is removed on exit.

## Mounts

Every agent gets:

- `$PWD` at the same absolute path, plus the repo's git common dir, so linked worktrees resolve.
- `.env` in `$PWD` masked with `/dev/null`, so secrets aren't readable.
- tmpfs for `/tmp`, `~/.cache`, `~/.local/state`, and an anonymous volume for `/nix`, all discarded on exit.

Skills and personal rules live in my dotfiles (`~/dotfiles/nix/home-manager/agents/skills`) and are mounted into pi (read-write) and opencode (read-only). Rules are a `user-rules` skill, not a system-prompt file.

| Agent | Host | Container |
|---|---|---|
| pi | `~/.agent-sandbox/pi/settings` | `~/.pi/agent` |
| pi | `~/.agent-sandbox/gh` (ro) | `~/.config/gh` |
| opencode | `~/.agent-sandbox/opencode/config` (ro) | `~/.config/opencode` |
| opencode | `~/.agent-sandbox/opencode/{state,cache,tui-state}` | opencode's data, cache, and TUI state dirs |
| both | `~/.gitconfig` (ro) | `~/.gitconfig` |
