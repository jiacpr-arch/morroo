#!/usr/bin/env bash
# Backfill existing blog articles to Facebook or Instagram (do NOT backfill LINE).
#
# Usage:
#   SITE=https://www.morroo.com BLOG_GENERATE_SECRET=xxx \
#     ./scripts/backfill-autopost.sh [count] [platform]
#
# Defaults: count=20, platform=fb
# Platforms:
#   fb  — 600s (10 min) between posts; FB spam detection is strict on new Pages
#   ig  — 180s (3 min) between posts; IG cap = 25 posts / 24h, ~5/hr soft limit

set -euo pipefail

SITE="${SITE:-https://www.morroo.com}"
SECRET="${BLOG_GENERATE_SECRET:?BLOG_GENERATE_SECRET env var is required}"
COUNT="${1:-20}"
PLATFORM="${2:-fb}"

case "$PLATFORM" in
  fb) DELAY_SECS=600 ;;
  ig) DELAY_SECS=240 ;;
  *) echo "Unknown platform: $PLATFORM (expected fb or ig)" >&2; exit 1 ;;
esac

echo "=== morroo backfill: $COUNT articles → $PLATFORM, ${DELAY_SECS}s between each ==="

for i in $(seq 1 "$COUNT"); do
  echo ""
  echo "--- [$i/$COUNT] $(date '+%Y-%m-%d %H:%M:%S') ---"
  result=$(curl -fsSL "$SITE/api/autopost/retry?secret=$SECRET&platform=$PLATFORM&limit=1" || echo '{"error":"curl failed"}')
  echo "$result"

  # Stop if no articles left to process
  if echo "$result" | grep -q '"No unposted articles found"'; then
    echo "All articles posted. Done."
    break
  fi

  if [ "$i" -lt "$COUNT" ]; then
    echo "Waiting ${DELAY_SECS}s before next post..."
    sleep "$DELAY_SECS"
  fi
done

echo ""
echo "=== Backfill complete ==="
