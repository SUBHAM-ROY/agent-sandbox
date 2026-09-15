#!/bin/sh
# copy.sh — container -> host clipboard via OSC 52 (plain + tmux passthrough)
# Usage: copy.sh ["text"] | copy.sh < stdin | copy.sh --file <path> | copy.sh -f <path>
set -eu

if [ "${1:-}" = "--file" ] || [ "${1:-}" = "-f" ]; then
  [ $# -lt 2 ] && { echo "copy.sh: --file needs a path" >&2; exit 1; }
  [ -f "$2" ] || { echo "copy.sh: not found: $2" >&2; exit 1; }
  data=$(python3 -c 'import sys; s=sys.stdin.buffer.read().replace(b"\r\n",b"\n").replace(b"\r",b"\n").rstrip(b"\n"); sys.stdout.buffer.write(s)' < "$2")
elif [ $# -gt 0 ]; then
  data=$(printf '%s' "$*" | python3 -c 'import sys; s=sys.stdin.buffer.read().replace(b"\r\n",b"\n").replace(b"\r",b"\n").rstrip(b"\n"); sys.stdout.buffer.write(s)')
else
  data=$(python3 -c 'import sys; s=sys.stdin.buffer.read().replace(b"\r\n",b"\n").replace(b"\r",b"\n").rstrip(b"\n"); sys.stdout.buffer.write(s)')
fi

if [ -z "$data" ]; then
  echo "copy.sh: no input (nothing copied)" >&2
  exit 1
fi

tty_path=$(readlink /proc/1/fd/0 || true)
if [ -z "$tty_path" ] || [ ! -w "$tty_path" ]; then
  echo "copy.sh: no writable tty at /proc/1/fd/0" >&2
  exit 1
fi

b64=$(printf '%s' "$data" | base64 -w0)
n=$(printf '%s' "$data" | wc -c)

printf '\033]52;c;%s\a' "$b64" > "$tty_path"
printf '\033Ptmux;\033\033]52;c;%s\a\033\\' "$b64" > "$tty_path"

echo "copy: $n bytes -> host clipboard" >&2
