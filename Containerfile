FROM ghcr.io/anomalyco/opencode:latest

RUN apk add --no-cache \
    git \
    luajit \
    fd \
    jq \
    python3

RUN adduser -D -u 1000 coder

USER coder
RUN mkdir -p /home/coder/.local/state /home/coder/.local/share/opencode
