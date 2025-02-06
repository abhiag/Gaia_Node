#!/bin/bash

# Trap to stop execution on Ctrl+C
trap "echo 'Stopping all threads...'; exit" SIGINT SIGTERM

# Function to send an API request
send_request() {
    local message="$1"
    local api_key="$2"
    local api_url="$3"

    attempt=0
    max_attempts=5

    while (( attempt < max_attempts )); do
        json_data=$(cat <<EOF
{
    "messages": [
        {"role": "system", "content": "You are a helpful assistant."},
        {"role": "user", "content": "$message"}
    ]
}
EOF
        )

        response=$(curl -s -w "%{http_code}" -X POST "$api_url" \
            -H "Authorization: Bearer $api_key" \
            -H "Accept: application/json" \
            -H "Content-Type: application/json" \
            -d "$json_data")

        http_status=$(echo "$response" | tail -n 1)
        body=$(echo "$response" | head -n -1)

        if [[ "$http_status" -eq 200 ]]; then
            if echo "$body" | jq . > /dev/null 2>&1; then
                echo "✅ [SUCCESS] Message: '$message'"
                echo "$body"
                return 0
            else
                echo "⚠️ [ERROR] Invalid JSON response!"
            fi
        else
            echo "⚠️ [ERROR] API Status: $http_status | Retrying in $((2**attempt))s..."
            sleep $((2**attempt))
        fi
        ((attempt++))
    done
    echo "❌ [FAILED] Max retries reached for message: '$message'"
    return 1
}

# Read messages from message.txt
mapfile -t user_messages < <(grep . message.txt)

if [ ${#user_messages[@]} -eq 0 ]; then
    echo "Error: No messages in message.txt!"
    exit 1
fi

# Get API details
read -s -p "Enter your API Key: " api_key
echo
read -p "Enter the Domain URL: " api_url

if [[ -z "$api_key" || -z "$api_url" ]]; then
    echo "Error: Both API Key and Domain URL are required!"
    exit 1
fi

# Get number of threads and limit per thread
read -p "Enter number of threads: " num_threads
read -p "Enter max API calls per thread: " max_calls

if ! [[ "$num_threads" =~ ^[0-9]+$ ]] || [ "$num_threads" -lt 1 ] || ! [[ "$max_calls" =~ ^[0-9]+$ ]]; then
    echo "Invalid input. Please enter integers greater than 0."
    exit 1
fi

# Function to start a thread
start_thread() {
    for ((i = 0; i < max_calls; i++)); do
        random_message=$(shuf -n 1 message.txt)
        send_request "$random_message" "$api_key" "$api_url"
        sleep 1
    done
}

# Start threads
for ((i = 0; i < num_threads; i++)); do
    start_thread &
done

wait
echo "✅ All requests completed."
