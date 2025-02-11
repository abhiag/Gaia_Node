#!/bin/bash

# Function to handle the API request
send_request() {
    local message="$1"
    local api_key="$2"
    local api_url="$3"

    while true; do
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

        http_status=$(echo "$response" | tail -n 1)
        body=$(echo "$response" | head -n -1)

        if [[ "$http_status" -eq 200 ]]; then
            if ! echo "$body" | jq empty 2>/dev/null; then
                echo "⚠️ [ERROR] Invalid JSON response! API: $api_url"
                echo "Response Text: $body"
                continue
            fi

            response_message=$(echo "$body" | jq -r '.choices[0].message.content' | sed 's/<|im_end|>//g; s/<|eot_id|>//g; s/<|end_of_text|>//g')

            echo "✅ [SUCCESS] API: $api_url | Message: '$message'"
            echo "Question: $message"
            echo "Response: $response_message"
            break
        else
            echo "⚠️ [ERROR] API: $api_url | Status: $http_status | Retrying..."
            sleep 2
        fi
    done
}

# Define a list of predefined messages
user_messages=(
    "What is 1 + 1"
    "What is 2 + 2"
    "What is 3 + 1"
    "What is 4 + 2"
    "What is 5 + 3"
    "What is 6 + 1"
    "What is 7 + 2"
    "What is 8 + 3"
    "What is 9 + 1"
)

# Ask the user how many API keys they want to enter
echo -n "How many API keys do you want to enter? (1-2-3-4...): "
read num_keys

# Validate the input
if ! [[ "$num_keys" =~ ^[0-9]+$ ]] || [ "$num_keys" -lt 1 ]; then
    echo "❌ Error: Please enter a valid number greater than 0!"
    exit 1
fi

# Collect API keys
declare -a api_keys
for ((i = 1; i <= num_keys; i++)); do
    echo -n "Enter API Key $i: "
    read api_keys[i]
done

# Ask for the API Domain URL
echo -n "Enter the API Domain URL: "
read api_url

# Exit if the API URL is empty
if [ -z "$api_url" ]; then
    echo "❌ Error: API Domain URL is required!"
    exit 1
fi

echo "✅ Using $num_keys API keys..."

# Function to start sending requests using different API keys
start_threads() {
    local key_index=0
    while true; do
        random_message="${user_messages[$RANDOM % ${#user_messages[@]}]}"
        api_key="${api_keys[$key_index]}"  # Select API key in round-robin order
        send_request "$random_message" "$api_key" "$api_url"

        key_index=$(( (key_index + 1) % num_keys ))  # Move to the next API key
        sleep 1
    done
}

# Start API requests
start_threads &
wait

# Graceful exit handling
trap "echo -e '\n🛑 Process terminated. Exiting gracefully...'; exit 0" SIGINT SIGTERM
