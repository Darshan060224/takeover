#!/usr/bin/env bash
H=docs.dev.fornax.sciencecloud.nasa.gov
for i in $(seq 1 240); do
  B=$(curl -s --max-time 10 "http://$H/" | head -c 400)
  if printf '%s' "$B" | grep -qE 'Darshan|Takeover'; then
    echo "[$(date +%T)] LIVE after $i polls"; curl -sI --max-time 15 "https://$H/" | head -3; exit 0
  fi
  printf '[%s] poll %d — %s\n' "$(date +%T)" "$i" "$(printf '%s' "$B" | grep -o 'Site not found' || echo unknown)"
  sleep 30
done
echo "not live after 2h"; exit 1
