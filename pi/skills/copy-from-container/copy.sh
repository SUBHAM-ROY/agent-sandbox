#!/bin/sh
# copy.sh — container -> host clipboard via OSC 52 (plain + tmux passthrough)
# Usage: copy.sh ["text"] | copy.sh < stdin | copy.sh --file <path> | copy.sh -f <path>
set -eu

if [ "${1:-}" = "--file" ] || [ "${1:-}" = "-f" ]; then
  [ $# -lt 2 ] && { echo "copy.sh: --file needs a path" >&2; exit 1; }
  [ -f "$2" ] || { echo "copy.sh: not found: $2" >&2; exit 1; }
  data=$(cat -- "$2")
elif [ $# -gt 0 ]; then
  data="$*"
else
  data=$(cat)
fi

if [ -z "$data" ]; then
  echo "copy.sh: no input (nothing copied)" >&2
  exit 1
fi

b64=$(printf '%s' "$data" | base64 | tr -d '\n')

tty_target="/dev/pts/0"
if [ ! -w "$tty_target" ]; then
  tty_target="/dev/stdout"
fi

printf '\033]52;c;%s\a' "$b64" > "$tty_target"
printf '\033Ptmux;\033\033]52;c;%s\a\033\\' "$b64" > "$tty_target"

if [ "$tty_target" = "/dev/stdout" ]; then printf '\n'; fi

echo "copy: $(printf '%s' "$data" | wc -c) bytes -> host clipboard" >&2
