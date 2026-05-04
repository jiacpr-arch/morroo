#!/usr/bin/env bash
# Backfill existing blog articles to Facebook (FB only — do NOT backfill LINE).
#
# Usage:
#   SITE=https://morroo.com BLOG_GENERATE_SECRET=xxx ./scripts/backfill-autopost.sh [count]
#
# Default count: 20 articles, 10 min apart to avoid FB spam detection.
# New Pages are more sensitive — keep the delay at 10 min minimum.

set -euo pipefail

SITE="${SITE:-https://morroo.com}"
SECRET="${BLOG_GENERATE_SECRET:?BLOG_GENERATE_SECRET env var is required}"
COUNT="${1:-20}"
DELAY_SECS=600  # 10 minutes between posts

echo "=== morroo FB backfill: $COUNT articles, ${DELAY_SECS}s between each ==="

for i in $(seq 1 "$COUNT"); do
  echo ""
  echo "--- [$i/$COUNT] $(date '+%Y-%m-%d %H:%M:%S') ---"
  result=$(curl -fsS "$SITE/api/autopost/retry?secret=$SECRET&platform=fb&limit=1" || echo '{"error":"curl failed"}')
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
