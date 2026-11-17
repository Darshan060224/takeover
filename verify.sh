#!/usr/bin/env bash
H=docs.dev.fornax.sciencecloud.nasa.gov
T=nasa-fornax.github.io
P=0; F=0
ok(){ printf '  [PASS] %s\n' "$1"; P=$((P+1)); }
no(){ printf '  [FAIL] %s\n' "$1"; F=$((F+1)); }
echo "=== $H — verification — $(date -Is) ==="
echo "[1] CNAME"
C=$(dig +short "$H" CNAME | head -1)
[ "$C" = "$T." ] && ok "CNAME -> $C" || no "CNAME is '$C', expected $T."
echo "[2] target state"
R=$(curl -s -o /dev/null -w '%{http_code}' "https://$T/")
[ "$R" = "404" ] && ok "Pages apex 404 (unclaimed)" || no "Pages apex returns $R"
O=$(curl -s -o /dev/null -w '%{http_code}' "https://api.github.com/orgs/nasa-fornax")
[ "$O" = "200" ] && ok "org exists (name not registerable)" || no "org check $O"
echo "[3] HTTP body"
B=$(curl -s --max-time 15 "http://$H/")
case "$B" in
  *"Site not found"*) ok "GitHub 'Site not found' -> unclaimed" ;;
  *Darshan*|*Takeover*) ok "claimed page served — TAKEOVER LIVE" ;;
  *) no "unrecognised body: $(printf '%s' "$B" | head -c 80)" ;;
esac
echo "[4] TLS"
S=$(curl -sI --max-time 15 "https://$H/" | head -1)
if printf '%s' "$S" | grep -q 200; then ok "HTTPS 200 — cert issued for the hostname"
elif printf '%s' "$S" | grep -qi 'HTTP/'; then no "HTTPS status: $S"
else no "HTTPS handshake fails (no cert for the name yet)"; fi
SUB=$(echo | openssl s_client -connect "$H:443" -servername "$H" 2>/dev/null | openssl x509 -noout -subject 2>/dev/null)
printf '  cert subject: %s\n' "${SUB:-<none>}"
echo "---"; echo "PASS=$P FAIL=$F"
if [ "$F" -eq 0 ] && [ "$P" -ge 4 ]; then echo "VERDICT: CONFIRMED AND LIVE"; exit 0; fi
if printf '%s' "$B" | grep -q 'Site not found'; then echo "VERDICT: DANGLING — claimable, not yet claimed"; else echo "VERDICT: see failures"; fi
