#!/usr/bin/env bash
set -euo pipefail

XVFB_WHD="${XVFB_WHD:-1400x900x24}"

echo "Starting virtual display ${DISPLAY} (${XVFB_WHD})"
Xvfb "${DISPLAY}" -screen 0 "${XVFB_WHD}" -ac +extension GLX +render -noreset &

echo "Starting lightweight window manager"
fluxbox >/tmp/fluxbox.log 2>&1 &

echo "Starting VNC server on 0.0.0.0:5900"
x11vnc -display "${DISPLAY}" -forever -shared -nopw -listen 0.0.0.0 -rfbport 5900 >/tmp/x11vnc.log 2>&1 &

echo "Starting Tolaria Tauri app"
exec pnpm tauri dev
