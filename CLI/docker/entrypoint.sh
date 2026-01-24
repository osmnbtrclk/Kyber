#!/bin/bash
set -euo pipefail

cp /root/.local/share/kyber/module/vivoxsdk.dll /mnt/battlefront

WINEPREFIX=/root/.local/share/maxima/wine/prefix /home/kyber/wine/bin/wine64 winecfg

export KYBER_BYPASS_DOCKER_I_REALLY_KNOW_WHAT_I_AM_DOING=1
echo "Starting KYBER Server named '${KYBER_SERVER_NAME:-unnamed}'"

args=(
  ./kyber_cli start_server
  --show-console
  --credentials="${MAXIMA_CREDENTIALS}"
  --token "${KYBER_TOKEN}"
  --game-path /mnt/battlefront/starwarsbattlefrontii.exe
  --verbose
)

args+=("$@")

if [[ "${MAXIMA_LOG_LEVEL:-}" == "debug" ]]; then
  args+=(--debug)
fi

exec "${args[@]}"
