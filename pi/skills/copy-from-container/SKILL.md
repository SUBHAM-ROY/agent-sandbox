---
name: copy-from-container
description: Copy text or files from inside the coding container to the host clipboard via OSC 52 with tmux passthrough. Use when you need to make container output pasteable on the host (kitty + tmux).
---

# Copy From Container

Copies stdin, a string, or a file to the host clipboard through `container -> tmux -> kitty`.

Works even though the container has no `tmux`/`kitty` — writes directly to the host terminal (`/dev/pts/0`, the pty of pid 1) with both plain OSC 52 and tmux passthrough wrap.

Requires host tmux `allow-passthrough on` (already set). No `set-clipboard` change needed.

## Usage

```bash
# string
copy-from-container/copy.sh "hello world"

# stdin / pipe
echo "hello world" | copy-from-container/copy.sh
cat /tmp/dexlink.log | copy-from-container/copy.sh

# file
copy-from-container/copy.sh --file /tmp/dexlink.log
```

Then paste on the host with Ctrl+V / Cmd+V.

## Notes

- Base64 encodes, so binary is fine.
- Emits both `ESC]52;c;<b64>BEL` (raw kitty) and `ESC P tmux; ESC ESC]52;c;<b64>BEL ESC\` (through tmux).
- Writes to `/dev/pts/0`; if that tty is missing it falls back to stdout.
