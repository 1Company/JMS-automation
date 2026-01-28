#!/bin/bash
# Status Check Script for 1Company Projects
# Run: ./scripts/status-check.sh
# Requires: GITHUB_TOKEN environment variable

set -e

REPOS=("HorecaMaster" "EventShare" "GoldenDeal" "SeminarMasterV2" "BingoMasterV2" "JMS-GoldenDeal" "ProjectMaster")

# Check for token
if [ -z "$GITHUB_TOKEN" ]; then
    echo "Error: GITHUB_TOKEN not set"
    exit 1
fi

echo "======================================"
echo "  1Company Project Status Dashboard"
echo "  $(date '+%Y-%m-%d %H:%M')"
echo "======================================"
echo ""

for repo in "${REPOS[@]}"; do
    echo "📦 $repo"
    
    # Get repo info
    info=$(curl -s -H "Authorization: token $GITHUB_TOKEN" \
        "https://api.github.com/repos/1Company/$repo")
    
    # Last commit
    commit=$(curl -s -H "Authorization: token $GITHUB_TOKEN" \
        "https://api.github.com/repos/1Company/$repo/commits?per_page=1" | \
        jq -r '.[0] | "   Last commit: \(.commit.author.date[:10]) - \(.commit.message | split("\n")[0][:50])"')
    echo "$commit"
    
    # Open issues
    issues=$(echo "$info" | jq -r '.open_issues_count')
    echo "   Open issues: $issues"
    
    # Language
    lang=$(echo "$info" | jq -r '.language // "Unknown"')
    echo "   Language: $lang"
    
    echo ""
done

echo "======================================"
