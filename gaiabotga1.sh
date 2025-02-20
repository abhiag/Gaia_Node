#!/bin/bash

# Empty API URL (hidden at the top)
API_URL=""

# Function to check if NVIDIA CUDA is installed
check_cuda() {
    if ! command -v nvcc &> /dev/null || ! command -v nvidia-smi &> /dev/null; then
        echo "❌ NVIDIA CUDA is not found! You must have an NVIDIA GPU."
        exit 1
    else
        echo "✅ NVIDIA CUDA is installed."
        nvcc --version
        nvidia-smi
    fi
}

# Function to handle the API request
send_request() {
    local message="$1"
    local api_key="$2"

    json_data=$(cat <<EOF
{
    "messages": [
        {"role": "system", "content": "You are a helpful assistant."},
        {"role": "user", "content": "$message"}
    ]
}
EOF
    )

    response=$(curl -s -w "\n%{http_code}" -X POST "$API_URL" \
        -H "Authorization: Bearer $api_key" \
        -H "Accept: application/json" \
        -H "Content-Type: application/json" \
        -d "$json_data")

    http_status=$(echo "$response" | tail -n 1)
    body=$(echo "$response" | head -n -1)

    if [[ "$http_status" -eq 200 ]]; then
        response_message=$(echo "$body" | jq -r '.choices[0].message.content')
        echo "✅ [SUCCESS] Message sent successfully."
        echo "Question: $message"
        echo "Response: $response_message"
    else
        echo "⚠️ [ERROR] API request failed | Status: $http_status | Retrying..."
        sleep 2
    fi
}

# Asking for API Key
echo -n "Enter your API Key: "
read api_key

if [ -z "$api_key" ]; then
    echo "Error: API Key is required!"
    exit 1
fi

# Asking for duration
echo -n "⏳ How many hours do you want the bot to run? "
read bot_hours

# Convert hours to seconds
if [[ "$bot_hours" =~ ^[0-9]+$ ]]; then
    max_duration=$((bot_hours * 3600))
    echo "🕒 The bot will run for $bot_hours hour(s) ($max_duration seconds)."
else
    echo "⚠️ Invalid input! Please enter a number."
    exit 1
fi

# Hidden API URL (moved to the bottom)
API_URL="https://soneium.gaia.domains/v1/chat/completions"

# Display thread information
echo "✅ Using 1 thread..."
echo "⏳ Waiting 30 seconds before sending the first request..."
sleep 30

echo "🚀 Starting requests..."
start_time=$(date +%s)

while true; do
    current_time=$(date +%s)
    elapsed=$((current_time - start_time))

    if [[ "$elapsed" -ge "$max_duration" ]]; then
        echo "🛑 Time limit reached ($bot_hours hours). Exiting..."
        exit 0
    fi

    random_message="What is $(($RANDOM % 100)) + $(($RANDOM % 100))?"
    send_request "$random_message" "$api_key"

    sleep 2
done
