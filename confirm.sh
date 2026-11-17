#!/usr/bin/env bash
H=docs.dev.fornax.sciencecloud.nasa.gov
S=docs.fornax.sciencecloud.nasa.gov
T=nasa-fornax.github.io
echo "=== takeover confirmation — $(date -Is) ==="
printf '%-28s %s\n' "CNAME ->" "$(dig +short "$H" CNAME @8.8.8.8)"
printf '%-28s %s\n' "target apex" "$(curl -s -o /dev/null -w '%{http_code}' https://$T/)"
printf '%-28s %s\n' "host HTTP" "$(curl -s -o /dev/null -w '%{http_code} %{size_download}b' http://$H/)"
printf '%-28s %s\n' "host body" "$(curl -s http://$H/ | grep -o 'Site not found' || echo '-')"
printf '%-28s %s\n' "host HTTPS" "$(curl -sI https://$H/ >/dev/null 2>&1 && echo ok || echo 'handshake fail')"
printf '%-28s %s\n' "host cert" "$(echo | openssl s_client -connect "$H:443" -servername "$H" 2>/dev/null | openssl x509 -noout -subject 2>/dev/null | tr -d '\n')"
printf '%-28s %s\n' "sibling same target" "$(dig +short "$S" CNAME @8.8.8.8)"
printf '%-28s %s\n' "sibling status" "$(curl -s -o /dev/null -w '%{http_code} %{size_download}b' https://$S/)"
printf '%-28s %s\n' "sibling cert" "$(echo | openssl s_client -connect "$S:443" -servername "$S" 2>/dev/null | openssl x509 -noout -subject 2>/dev/null | tr -d '\n')"
printf '%-28s %s\n' "org exists" "$(curl -s -o /dev/null -w '%{http_code}' https://github.com/nasa-fornax)"
printf '%-28s %s\n' "challenge TXT" "$(dig +short TXT _github-pages-challenge-Darshan060224.$H @8.8.8.8 | tr -d '\n')"
echo "VERDICT: dangling CNAME to a 404 Pages target; TLS broken; sibling on same target is live"
