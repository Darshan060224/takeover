# Subdomain Takeover PoC — docs.dev.fornax.sciencecloud.nasa.gov

**Reporter:** Darshan U — GitHub `Darshan060224`, Bugcrowd `DARSHAN242U`
**Program:** Bugcrowd, NASA VDP
**VRT:** Misconfigured DNS → Subdomain Takeover (P3)
**Status:** dangling confirmed, claim staged

## Why this works

`docs.dev.fornax.sciencecloud.nasa.gov` is a CNAME to `nasa-fornax.github.io`. The Pages site that used
to answer there is gone — the apex returns 404 and GitHub serves its "Site not found · GitHub Pages"
page on the hostname, with no certificate for it.

The sibling `docs.fornax.sciencecloud.nasa.gov` points at the same target and is live with the real
Fornax documentation and its own cert. `docs.dev` is the stale duplicate.

GitHub Pages routes on the `Host` header, so any Pages site declaring this hostname in its `CNAME` file
is served here. No DNS change and no org membership needed.

## Blocker

GitHub requires domain verification before the custom domain can be attached, and the record sits in a
Route53 zone the reporter cannot write to. One TXT record completes the takeover:

    _github-pages-challenge-Darshan060224.docs.dev.fornax.sciencecloud.nasa.gov  TXT  "7af9abd8179a4ba3e00d32cc67d7b6"

## Files

| File | Purpose |
|---|---|
| `index.html` | PoC page, live at https://darshan060224.github.io/takeover/ |
| `CNAME` | Exactly one line: the hostname |
| `404.html` | Optional Pages 404 |
| `REPORT.md` | Submission write-up with evidence |
| `confirm.sh` | Prints the full confirmation table |
| `verify.sh` | PASS/FAIL checks |
| `capture.sh` | Dated evidence snapshots |
| `watch_verify.sh` | Polls for the TXT and submits the claim automatically |

— Darshan U
