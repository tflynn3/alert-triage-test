#!/bin/bash
set -e

PROJECT_ID="alert-triage-playground"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Creating alert policies in $PROJECT_ID..."

# Create Pub/Sub backlog alert
echo "Creating Pub/Sub backlog alert..."
gcloud alpha monitoring policies create \
  --policy-from-file="$SCRIPT_DIR/alerts/pubsub-backlog.json" \
  --project="$PROJECT_ID" 2>/dev/null || echo "Policy may already exist"

# Create Cloud Run latency alert
echo "Creating Cloud Run latency alert..."
gcloud alpha monitoring policies create \
  --policy-from-file="$SCRIPT_DIR/alerts/cloudrun-latency.json" \
  --project="$PROJECT_ID" 2>/dev/null || echo "Policy may already exist"

# Create Cloud Run error alert
echo "Creating Cloud Run error alert..."
gcloud alpha monitoring policies create \
  --policy-from-file="$SCRIPT_DIR/alerts/cloudrun-errors.json" \
  --project="$PROJECT_ID" 2>/dev/null || echo "Policy may already exist"

echo "Alert policies created!"
echo ""
echo "View policies at:"
echo "https://console.cloud.google.com/monitoring/alerting/policies?project=$PROJECT_ID"
