#!/bin/bash

# Function to send the API request
send_request() {
    local message="$1"
    local api_key="$2"
    local api_url="https://gacrypto.gaia.domains/v1/chat/completions"

    json_data=$(cat <<EOF
{
    "messages": [
        {"role": "system", "content": "You are a helpful assistant."},
        {"role": "user", "content": "$message"}
    ]
}
EOF
    )

    response=$(curl -s -w "\n%{http_code}" -X POST "$api_url" \
        -H "Authorization: Bearer $api_key" \
        -H "Accept: application/json" \
        -H "Content-Type: application/json" \
        -d "$json_data")

    http_status=$(echo "$response" | tail -n1)
    body=$(echo "$response" | head -n -1)

    if [[ "$http_status" -eq 200 ]]; then
        response_message=$(echo "$body" | jq -r '.choices[0].message.content')
        echo "✅ [SUCCESS] Request sent successfully!"
        echo "🔹 Question: $message"
        echo "🔸 Response: $response_message"
    else
        echo "⚠️ [ERROR] Request failed | Status: $http_status"
    fi
}

# New list of math-related messages
user_messages=(
    "What is 8 + 5?"
    "What is 12 - 7?"
    "What is 6 × 4?"
    "What is 20 ÷ 5?"
    "What is 15 + 9?"
    "What is 50 - 25?"
    "What is 9 × 3?"
    "What is 36 ÷ 6?"
    "What is 7 + 8?"
    "What is 14 - 6?"
    "What is 5 × 7?"
    "What is 81 ÷ 9?"
    "What is 25 + 17?"
    "What is 60 - 32?"
    "What is 11 × 6?"
    "What is 100 ÷ 20?"
    "What is 19 + 4?"
    "What is 45 - 18?"
    "What is 8 × 9?"
    "What is 72 ÷ 8?"
    "What is 13 + 29?"
    "What is 90 - 44?"
    "What is 4 × 12?"
    "What is 144 ÷ 12?"
    "What is 33 + 27?"
    "What is 81 - 39?"
    "What is 7 × 11?"
    "What is 225 ÷ 15?"
    "What is 56 + 14?"
    "What is 98 - 56?"
)

# Prompt for API Key (hidden input)
read -rsp "🔑 Enter your API Key: " api_key
echo ""

# Validate API Key
if [[ -z "$api_key" ]]; then
    echo "❌ Error: API Key is required!"
    exit 1
fi

echo "✅ Connection initialized successfully!"

# Random delay before sending the request (1-2 minutes)
initial_wait=$((60 + RANDOM % 61))
echo "⏳ Preparing request... (Waiting for $initial_wait seconds)"
sleep "$initial_wait"

# Pick a random message
random_message="${user_messages[$RANDOM % ${#user_messages[@]}]}"

# Send the request
send_request "$random_message" "$api_key"

echo "✅ Script execution complete."
