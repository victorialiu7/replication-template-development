#!/bin/bash

# Get directory of current file 
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

export result="$1"
export JIRA_KEY="$2"

# Source the secrets.env from the same directory
source "$DIR/secrets.env"
# Remember to add ticket number when running in the terminal

export WEBHOOK_URL="https://automation.atlassian.com/pro/hooks/${WEBHOOK_SECRET}?issue=${JIRA_KEY}"

input="Processing for Bitbucket repository "$JIRA_KEY": "$result". Container terminated at $(date)."

# Make sure to set automation to: {{webhookData.fields.summary}}
webhookData=$(cat <<EOF
{
    "key": "AEAREP-6173",
    "fields": {
        "summary": "$input"
    }
}
EOF
)


curl -X POST \
  -H "Content-Type: application/json" \
  -d "$webhookData" \
  $WEBHOOK_URL

# Capture exit codes 
echo $?

echo "Notification sent to Jira ticket AEAREP-6173."
