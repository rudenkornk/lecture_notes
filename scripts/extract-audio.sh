#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 2 ]]; then
  echo "Usage: bash scripts/extract-audio.sh VIDEO OUTPUT.wav" >&2
  exit 1
fi

ffmpeg -nostdin -hide_banner -loglevel error -n -i "$1" \
  -map 0:a:0 -vn -ac 1 -ar 16000 -c:a pcm_s16le "$2"
