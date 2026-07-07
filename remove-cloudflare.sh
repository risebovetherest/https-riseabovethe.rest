#!/bin/bash
# remove-cloudflare.sh - Remove Cloudflare code from HTML files
# Usage: ./remove-cloudflare.sh /path/to/your/html/files

HTML_DIR="${1:-.}"

echo "🧹 Removing Cloudflare code from HTML files..."

# Remove Cloudflare challenge/injection scripts
find "$HTML_DIR" -name "*.html" -exec sed -i \
    -e '/<script>(function(){function c()/,/})()};/d' \
    -e '/cdn-cgi\/challenge-platform/d' \
    -e '/cdn-cgi\/scripts/d' \
    -e '/rocket-loader/d' \
    -e '/<script>/,/window\.__CF\$cv\$params/d' \
    {} \;

# Remove dns-prefetch to cloudflare
find "$HTML_DIR" -name "*.html" -exec sed -i \
    -e '/cloudflare/d' \
    {} \;

# Remove Cloudflare-specific meta tags
find "$HTML_DIR" -name "*.html" -exec sed -i \
    -e '/cf-ray/d' \
    -e '/cf-cache-status/d' \
    {} \;

echo "✅ Done! Cloudflare code removed."
echo ""
echo "⚠️  IMPORTANT: Review the files manually to ensure nothing critical was removed."
echo "   Some Cloudflare code might be inlined in complex ways."
