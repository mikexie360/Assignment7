#!/usr/bin/env bash
#
# deploy-wp.sh — runs ON the VVV/WordPress VM (invoked over SSH by Jenkins).
# Reads /tmp/paper.html and creates or updates the WordPress page.
#
set -euo pipefail
export PATH="$PATH:/usr/local/bin"   # ensure wp is found under non-interactive SSH

SITE_PATH="/srv/www/wordpress-one/public_html"   # adjust to your VVV site
SLUG="vagrant-vs-docker"
TITLE="Vagrant vs Docker"
PAPER="/tmp/paper.html"

EXISTING_ID=$(wp post list --post_type=page --name="$SLUG" --field=ID --path="$SITE_PATH" || true)

if [ -z "$EXISTING_ID" ]; then
  wp post create "$PAPER" \
    --post_type=page \
    --post_title="$TITLE" \
    --post_name="$SLUG" \
    --post_status=publish \
    --path="$SITE_PATH"
  echo "Created WordPress page."
else
  wp post update "$EXISTING_ID" "$PAPER" --path="$SITE_PATH"
  echo "Updated WordPress page ID $EXISTING_ID."
fi
