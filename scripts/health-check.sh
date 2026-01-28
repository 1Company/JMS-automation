#!/bin/bash
# Health Check Script for 1Company Live Deployments
# Run: ./scripts/health-check.sh
# No tokens required - checks public URLs

DEPLOYMENTS=(
    "horeca-master.vercel.app|HorecaMaster"
    "eventshare.vercel.app|EventShare"
    "golden-deal.vercel.app|GoldenDeal"
    "answerthis.vercel.app|SeminarMaster (AnswerThis)"
    "bingo-master.vercel.app|BingoMaster"
    "jms-golden-deal.vercel.app|JMS-GoldenDeal"
)

REPORT_DIR="$(dirname "$0")/../reports"
REPORT_FILE="$REPORT_DIR/health-$(date +%Y-%m-%d_%H%M).txt"

echo "======================================"
echo "  1Company Health Check"
echo "  $(date '+%Y-%m-%d %H:%M:%S')"
echo "======================================"
echo ""

all_healthy=true

for entry in "${DEPLOYMENTS[@]}"; do
    url="${entry%%|*}"
    name="${entry##*|}"
    
    # Check HTTP status and response time
    start=$(date +%s%3N)
    status=$(curl -s -o /dev/null -w "%{http_code}" "https://$url" --max-time 10 2>/dev/null || echo "000")
    end=$(date +%s%3N)
    time=$((end - start))
    
    if [ "$status" = "200" ] || [ "$status" = "307" ] || [ "$status" = "308" ]; then
        echo "✅ $name"
        echo "   URL: https://$url"
        echo "   Status: $status | Response: ${time}ms"
    else
        echo "❌ $name"
        echo "   URL: https://$url"
        echo "   Status: $status (PROBLEM!)"
        all_healthy=false
    fi
    echo ""
done

echo "======================================"
if [ "$all_healthy" = true ]; then
    echo "✅ All systems operational"
else
    echo "⚠️  Some systems have issues - check above"
fi
echo "======================================"

# Save to report file
mkdir -p "$REPORT_DIR"
{
    echo "Health Check: $(date '+%Y-%m-%d %H:%M:%S')"
    echo "Status: $([ "$all_healthy" = true ] && echo 'ALL OK' || echo 'ISSUES DETECTED')"
} >> "$REPORT_FILE"
