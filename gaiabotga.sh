#!/bin/bash

# Function to handle the API request
send_request() {
    local message="$1"
    local api_key="$2"
    local api_url="$3"

    while true; do
        # Prepare the JSON payload
        json_data=$(cat <<EOF
{
    "messages": [
        {"role": "system", "content": "You are a helpful assistant."},
        {"role": "user", "content": "$message"}
    ]
}
EOF
        )

        # Send the request using curl and capture both the response and status code
        response=$(curl -s -w "\n%{http_code}" -X POST "$api_url" \
            -H "Authorization: Bearer $api_key" \
            -H "Accept: application/json" \
            -H "Content-Type: application/json" \
            -d "$json_data")

        # Extract the HTTP status code from the response
        http_status=$(echo "$response" | tail -n 1)
        body=$(echo "$response" | head -n -1)

        if [[ "$http_status" -eq 200 ]]; then
            echo "✅ [SUCCESS] API: $api_url | Message: '$message'"
            
            # Extract the response message from the JSON
            response_message=$(echo "$body" | jq -r '.choices[0].message.content')

            # Print both the question and the response
            echo "Question: $message"
            echo "Response: $response_message"

            # Wait for 3 minutes before sending the next request
            echo "⏳ Waiting for 2 minutes before the next request..."
            sleep 120  # 180 seconds = 2 minutes
            break  # Exit loop if request was successful
        else
            echo "⚠️ [ERROR] API: $api_url | Status: $http_status | Retrying in 3 minutes..."
            sleep 180  # 180 seconds = 3 minutes
        fi
    done
}

# Define a list of math-related questions for kids
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
    "What is 10 + 5"
    "What is 7 + 5"
    "What is 9 + 6"
    "What is 11 + 2"
    "What is 12 + 3"
    "What is 15 + 4"
    "What is 18 + 2"
    "What is 2 - 1"
    "What is 4 - 2"
    "What is 5 - 3"
    "What is 6 - 2"
    "What is 7 - 5"
    "What is 8 - 4"
    "What is 9 - 6"
    "What is 10 - 3"
    "What is 12 - 7"
    "What is 15 - 5"
    "What is 13 - 6"
    "What is 14 - 8"
    "What is 16 - 9"
    "What is 20 - 4"
    "What is 22 - 10"
    "What is 25 - 5"
)

# Ask the user to input API Key and Domain URL
echo -n "Enter your API Key: "
read api_key
echo -n "Enter the Domain URL: "
read api_url

# Exit if the API Key or URL is empty
if [ -z "$api_key" ] || [ -z "$api_url" ]; then
    echo "Error: Both API Key and Domain URL are required!"
    exit 1
fi

# Ask the user how many threads to use
echo -n "Enter the number of threads you want to use: "
read num_threads

if ! [[ "$num_threads" =~ ^[0-9]+$ ]] || [ "$num_threads" -lt 1 ]; then
    echo "Invalid input. Please enter an integer greater than 0."
    exit 1
fi

# Function to run the thread
start_thread() {
    while true; do
        # Pick a random message from the predefined list
        random_message="${user_messages[$RANDOM % ${#user_messages[@]}]}"
        send_request "$random_message" "$api_key" "$api_url"
    done
}

# Start the threads
for ((i = 0; i < num_threads; i++)); do
    start_thread &
done

# Wait for all threads to finish (this will run indefinitely)
wait

echo "All requests have been processed."  # This will never be reached because of the infinite loop
