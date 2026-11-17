#!/usr/bin/env bash
H=docs.dev.fornax.sciencecloud.nasa.gov
D="evidence/$(date +%Y%m%d-%H%M%S)"; mkdir -p "$D"
{ echo "== dig =="; dig "$H" CNAME +noall +answer
  echo "== http =="; curl -s -D "$D/http_headers.txt" --max-time 20 "http://$H/" -o "$D/http_body.html"; cat "$D/http_headers.txt"
  echo "== https =="; curl -sI --max-time 20 "https://$H/"
  echo "== tls =="; echo | openssl s_client -connect "$H:443" -servername "$H" 2>/dev/null | openssl x509 -noout -subject -issuer -dates -ext subjectAltName
} > "$D/transcript.txt" 2>&1
printf 'saved -> %s\n' "$D"; ls -la "$D"
