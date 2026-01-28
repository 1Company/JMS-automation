# JMS-automation 🤖

Automation, monitoring, and tooling for 1Company projects.

**Managed by:** James (AI Assistant)  
**Owner:** Arnold

---

## What's This?

This repo contains scripts and tools that help manage Arnold's portfolio of SaaS products. James (the AI) runs these to:

- 🔍 Audit dependencies for security issues and updates
- 📊 Monitor project status and health
- 🚀 Automate repetitive tasks
- 📝 Generate reports

## Projects Monitored

| Project | Description | Type |
|---------|-------------|------|
| HorecaMaster | Order tracking for takeaway restaurants | SaaS €14-49/mo |
| EventShare | Event photo sharing + TV slideshow | Per-event $49 |
| GoldenDeal | Deals/voucher marketplace | Marketplace |
| SeminarMasterV2 | Live Q&A for seminars | Event tool |
| BingoMasterV2 | Bingo event management | Event tool |
| JMS-GoldenDeal | Dark theme fork of GoldenDeal | Fork |

## Scripts

### `scripts/audit-deps.sh`
Checks all repos for outdated npm dependencies and security vulnerabilities.

```bash
./scripts/audit-deps.sh
```

### `scripts/status-check.sh`
Quick status overview of all projects (last commit, open issues, etc.)

```bash
./scripts/status-check.sh
```

## Reports

Generated reports are stored in `/reports` with timestamps.

---

## For Arnold

You don't need to do anything here - James manages this repo. If you see PRs from this repo to your other projects, those are improvements I've identified.

Questions? Just ask me on WhatsApp! 📱
