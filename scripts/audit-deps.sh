#!/bin/bash
# Dependency Audit Script for 1Company Projects
# Run: ./scripts/audit-deps.sh
# Requires: GITHUB_TOKEN environment variable

set -e

REPOS=("HorecaMaster" "EventShare" "GoldenDeal" "SeminarMasterV2" "BingoMasterV2" "JMS-GoldenDeal")
REPORT_DIR="$(dirname "$0")/../reports"
REPORT_FILE="$REPORT_DIR/deps-audit-$(date +%Y-%m-%d).md"

# Check for token
if [ -z "$GITHUB_TOKEN" ]; then
    echo "Error: GITHUB_TOKEN not set"
    exit 1
fi

echo "# Dependency Audit Report" > "$REPORT_FILE"
echo "Generated: $(date '+%Y-%m-%d %H:%M:%S')" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

for repo in "${REPOS[@]}"; do
    echo "Checking $repo..."
    echo "## $repo" >> "$REPORT_FILE"
    echo "" >> "$REPORT_FILE"
    
    # Get package.json
    pkg=$(curl -s -H "Authorization: token $GITHUB_TOKEN" \
        "https://api.github.com/repos/1Company/$repo/contents/package.json" 2>/dev/null | \
        jq -r '.content // empty' | base64 -d 2>/dev/null)
    
    if [ -z "$pkg" ]; then
        # Check for monorepo structure
        pkg=$(curl -s -H "Authorization: token $GITHUB_TOKEN" \
            "https://api.github.com/repos/1Company/$repo/contents/app/package.json" 2>/dev/null | \
            jq -r '.content // empty' | base64 -d 2>/dev/null)
    fi
    
    if [ -z "$pkg" ]; then
        echo "⚠️ No package.json found" >> "$REPORT_FILE"
        echo "" >> "$REPORT_FILE"
        continue
    fi
    
    # Extract key dependencies
    echo "### Dependencies" >> "$REPORT_FILE"
    echo '```' >> "$REPORT_FILE"
    echo "$pkg" | jq -r '.dependencies // {} | to_entries[] | "\(.key): \(.value)"' 2>/dev/null | head -20 >> "$REPORT_FILE"
    echo '```' >> "$REPORT_FILE"
    echo "" >> "$REPORT_FILE"
    
    # Check for common outdated patterns
    echo "### Checks" >> "$REPORT_FILE"
    
    # Next.js version
    nextver=$(echo "$pkg" | jq -r '.dependencies.next // .devDependencies.next // "not found"')
    if [ "$nextver" != "not found" ]; then
        echo "- Next.js: $nextver" >> "$REPORT_FILE"
    fi
    
    # React version  
    reactver=$(echo "$pkg" | jq -r '.dependencies.react // "not found"')
    if [ "$reactver" != "not found" ]; then
        echo "- React: $reactver" >> "$REPORT_FILE"
    fi
    
    # TypeScript version
    tsver=$(echo "$pkg" | jq -r '.devDependencies.typescript // "not found"')
    if [ "$tsver" != "not found" ]; then
        echo "- TypeScript: $tsver" >> "$REPORT_FILE"
    fi
    
    echo "" >> "$REPORT_FILE"
done

echo "✅ Report saved to: $REPORT_FILE"
cat "$REPORT_FILE"
