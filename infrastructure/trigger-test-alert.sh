#!/bin/bash
# Trigger a test alert by publishing messages without consuming them

PROJECT_ID="alert-triage-playground"
TOPIC="alert-queue"

echo "Publishing 100 messages to create backlog..."
for i in {1..100}; do
  gcloud pubsub topics publish "$TOPIC" \
    --message="Test message $i at $(date -u +%Y-%m-%dT%H:%M:%SZ)" \
    --project="$PROJECT_ID" \
    --quiet
done

echo ""
echo "Messages published. The Pub/Sub backlog alert should fire within 1-2 minutes."
echo "Monitor at: https://console.cloud.google.com/monitoring/alerting?project=$PROJECT_ID"
echo ""
echo "To manually trigger the workflow, run:"
echo "gh api repos/tflynn3/alert-triage-test/dispatches -X POST \\"
echo "  -f event_type=alert_triage \\"
echo "  -f 'client_payload={\"incident\":{\"incident_id\":\"test-$(date +%s)\",\"resource_name\":\"pubsub_subscription:alert-queue-sub\",\"policy_name\":\"Pub/Sub Backlog Over 60 seconds\",\"observed_value\":\"120\",\"threshold_value\":\"60\",\"started_at\":\"$(date -u +%Y-%m-%dT%H:%M:%SZ)\",\"state\":\"open\"}}'"
