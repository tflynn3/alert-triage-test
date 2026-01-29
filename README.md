# Alert Triage Test

Testing GCP Alert Triage Agent with Claude Code.

## Architecture

```
GCP Monitoring Alert fires
    ↓ webhook (repository_dispatch)
GitHub Actions workflow
    ↓ Workload Identity Federation → GCP APIs
    ↓ Claude Code CLI with system prompt
    ↓ Queries metrics, logs
    ↓ Creates GitHub Issue
    ↓
Posts to Google Chat (optional)
```

## Setup

### Prerequisites
- GCP Project: `alert-triage-playground`
- Workload Identity Pool: `github-pool`
- Service Account: `github-triage-agent@alert-triage-playground.iam.gserviceaccount.com`

### GitHub Secrets Required
1. `ANTHROPIC_API_KEY` - Claude API key
2. `GCHAT_WEBHOOK_URL` - Google Chat incoming webhook (optional)

### Create Alert Policies
```bash
chmod +x infrastructure/setup-alerts.sh
./infrastructure/setup-alerts.sh
```

## Testing

### Manual Trigger
```bash
gh api repos/tflynn3/alert-triage-test/dispatches -X POST \
  -f event_type=alert_triage \
  -f 'client_payload={"incident":{"incident_id":"test-123","resource_name":"pubsub_subscription:alert-queue-sub","policy_name":"Pub/Sub Backlog Over 60 seconds","observed_value":"120","threshold_value":"60","started_at":"2024-01-28T10:00:00Z","state":"open"}}'
```

### Create Real Backlog
```bash
chmod +x infrastructure/trigger-test-alert.sh
./infrastructure/trigger-test-alert.sh
```

## GCP Resources

| Resource | Type | Purpose |
|----------|------|---------|
| hello-service | Cloud Run | Simple test service |
| alert-queue | Pub/Sub Topic | Test message queue |
| alert-queue-sub | Pub/Sub Subscription | For backlog alerts |

## Workflow

The `.github/workflows/alert-triage.yml` workflow:

1. Receives alert via `repository_dispatch`
2. Authenticates to GCP via Workload Identity
3. Checks for duplicate issues
4. Searches historical issues for context
5. Runs Claude Code to triage
6. Creates GitHub issue with triage report
7. Posts to Google Chat

## Issue Labels

| Label | Color | Meaning |
|-------|-------|---------|
| severity:critical | Red | Immediate action required |
| severity:warning | Orange | Investigate soon |
| severity:info | Green | Informational |
| triage | Purple | Auto-triaged alert |
