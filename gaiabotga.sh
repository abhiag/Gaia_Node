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

        # Send the request using curl
        response=$(curl -s -w "%{http_code}" -X POST "$api_url" \
            -H "Authorization: Bearer $api_key" \
            -H "Accept: application/json" \
            -H "Content-Type: application/json" \
            -d "$json_data")

        # Extract the HTTP status code from the response
        http_status=$(echo "$response" | tail -n 1)
        body=$(echo "$response" | head -n -1)

        if [[ "$http_status" -eq 200 ]]; then
            # Check if the response is valid JSON
            echo "$body" | jq . > /dev/null 2>&1
            if [ $? -eq 0 ]; then
                echo "✅ [SUCCESS] API: $api_url | Message: '$message'"
                echo "$body"
                break  # Exit loop if request was successful
            else
                echo "⚠️ [ERROR] Invalid JSON response! API: $api_url"
                echo "Response Text: $body"
            fi
        else
            echo "⚠️ [ERROR] API: $api_url | Status: $http_status | Retrying in 2s..."
            sleep 2
        fi
    done
}

# Read the messages from message.txt
user_messages=()
while IFS= read -r msg; do
    if [[ -n "$msg" ]]; then
        user_messages+=("$msg")
    fi
done < message.txt

# Exit if there are no messages
if [ ${#user_messages[@]} -eq 0 ]; then
    echo "Error: No messages in message.txt!"
    exit 1
fi

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
        # Select a random message from user_messages
        random_message="${user_messages[$RANDOM % ${#user_messages[@]}]}"
        
        # Debug: Print the selected random message
        echo "Selected Message: $random_message"
        
        # Send the request
        send_request "$random_message" "$api_key" "$api_url"

        # Add a small delay to prevent hitting rate limits
        sleep 1  # You can adjust this value as needed
    done
}

# Start the threads
for ((i = 0; i < num_threads; i++)); do
    start_thread &  # Run the thread in the background
done

# Wait for all threads to finish (this will run indefinitely)
wait

echo "All requests have been processed."  # This will never be reached because of the infinite loop
