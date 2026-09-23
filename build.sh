#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"

docker build -f Dockerfile.common -t agent-sandbox/base:latest .
for name in ${@:-pi opencode}; do
  docker build -f "Dockerfile.$name" -t "agent-sandbox/$name:latest" .
done
