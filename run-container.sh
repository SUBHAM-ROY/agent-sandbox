#!/usr/bin/env bash
set -euo pipefail

TOOL="${1:-}"
if [[ -z "$TOOL" ]]; then
  echo "Usage: $0 <pi|opencode|claude|cursor> [args...]" >&2
  exit 1
fi
shift

case "$TOOL" in
  pi) COMPOSE_SUFFIX="pi"; SERVICE="pi-sandbox" ;;
  opencode) COMPOSE_SUFFIX="opencode"; SERVICE="opencode" ;;
  claude) COMPOSE_SUFFIX="claude"; SERVICE="agent-sandbox" ;;
  cursor) COMPOSE_SUFFIX="cursor"; SERVICE="cursor-sandbox" ;;
  *) echo "Unknown tool: $TOOL" >&2; exit 1 ;;
esac

ROOT="$(cd "$(dirname "$0")" && pwd)"
COMPOSE_FILE="$ROOT/compose.${COMPOSE_SUFFIX}.yaml"
if [[ ! -f "$COMPOSE_FILE" ]]; then
  echo "No sandbox container file found: $COMPOSE_FILE" >&2
  exit 1
fi

GIT_COMMON_DIR="$(git rev-parse --path-format=absolute --git-common-dir 2>/dev/null || echo "$PWD")"
export GIT_COMMON_DIR

if ! command -v docker >/dev/null 2>&1; then
  echo "No container runtime found (docker not found)" >&2
  exit 1
fi

ENV_VOL=()
if [[ -e "$PWD/.env" ]]; then
  ENV_VOL=(--volume "/dev/null:${PWD}/.env:ro")
fi

exec docker compose -f "$COMPOSE_FILE" run --rm "${ENV_VOL[@]}" "$SERVICE" "$@"
