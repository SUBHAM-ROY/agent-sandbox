---
name: copy-from-container
description: Copy text or files from inside the coding container to the host clipboard via OSC 52 (plain + tmux passthrough). Use when container output must be pasteable on the host.
---

# Copy From Container

Copies a string, stdin, or a file to the host clipboard. Dual-emits plain OSC 52 and tmux DCS wrap so one sequence lands (bare terminal vs tmux with `allow-passthrough on`).

TTY is `readlink /proc/1/fd/0` (Bash-tool has no `/dev/tty`). Unix LF only; trailing newlines stripped. Also paste the text in chat if OSC fails.

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

- Emits both `ESC]52;c;<b64>BEL` and `ESC P tmux; ESC ESC]52;c;<b64>BEL ESC\`.
- Host tmux needs `allow-passthrough on` for the wrapped sequence.
- No stdout fallback (that dumps OSC into the log).
