#!/bin/bash

# Predefined API URL
API_URL="https://soneium.gaia.domains/v1/chat/completions"

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

# Check for CUDA before proceeding
check_cuda

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

# List of predefined messages
user_messages=(
    "What is 8 + 5?" "What is 12 - 7?" "What is 6 × 4?" "What is 20 ÷ 5?"
    "What is 15 + 9?" "What is 50 - 25?" "What is 9 × 3?" "What is 36 ÷ 6?"
    "What is 7 + 8?" "What is 14 - 6?" "What is 5 × 7?" "What is 81 ÷ 9?"
    "What is 25 + 17?" "What is 60 - 32?" "What is 11 × 6?" "What is 100 ÷ 20?"
)

# Ask for API Key
echo -n "Enter your API Key: "
read api_key

if [ -z "$api_key" ]; then
    echo "Error: API Key is required!"
    exit 1
fi

# Ask user how many hours to run the bot
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

echo "✅ Using 1 thread..."
echo "⏳ Waiting 30 seconds before sending the first request..."
sleep 30

echo "🚀 Starting requests..."

# Function to start sending messages
start_thread() {
    local start_time=$(date +%s)

    while true; do
        # Check if time limit is reached
        current_time=$(date +%s)
        elapsed=$((current_time - start_time))

        if [[ "$elapsed" -ge "$max_duration" ]]; then
            echo "🛑 Time limit reached ($bot_hours hours). Exiting..."
            exit 0
        fi

        # Pick a random message and send request
        random_message="${user_messages[$RANDOM % ${#user_messages[@]}]}"
        send_request "$random_message" "$api_key"

        sleep 2  # Small delay to prevent overwhelming the API
    done
}

# Start the request loop
start_thread &
wait
