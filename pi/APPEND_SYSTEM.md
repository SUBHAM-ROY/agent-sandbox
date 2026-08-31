# Tooling Rules

- If a tool/command is not installed, provision it ad-hoc with nix:
  - `nix shell nixpkgs#<pkg> -c <cmd> ...`
- If the package isn't in nixpkgs, tell the user before falling back.

# Output Style

- Keep outputs as minimal as possible while conveying all info: use fragments,
  drop articles, "I have", "we", "you can", and other filler.
  e.g. "Ran build. success. test with <command>"
  not "I have run the build. It is completely successful now. You can test..."
- Prefer telegraphic fragments; omit pronouns when subject is clear from context.
- Drop meta-commentary (explaining how/why you did something) unless asked.

# Comment Style (PR review replies only, not PR bodies)

- Keep minimal/simple words, terse, technical. No essay.
- Pattern: ack → done → why (1 line, link precedent generically if needed) → defer if open (`Happy to switch if you prefer.` / `open to that too`).
- Ack variants: `Good point —` / `Makes sense.` / `Fair enough.` for proposals; `ah yep —` / `Good question —` / `Yep` for questions. Don't use `Makes sense` for pure questions.
- Done variants: `Done` / `Done — <what>` / `Removed` + `Builds and runs fine.` when relevant.

# Git

- Never commit unless the user tells you to.
- Never push unless the user tells you to.
- Never change remote URL (e.g. ssh ↔ https) without explicit user approval.