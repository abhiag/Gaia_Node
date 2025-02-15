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
            # Check if the response is valid JSON
            echo "$body" | jq . > /dev/null 2>&1
            if [ $? -eq 0 ]; then
                # Print the question and response content
                echo "✅ [SUCCESS] API: $api_url | Message: '$message'"

                # Extract the response message from the JSON
                response_message=$(echo "$body" | jq -r '.choices[0].message.content')
                
                # Print both the question and the response
                echo "Question: $message"
                echo "Response: $response_message"
                break  # Exit loop if request was successful
            else
                echo "⚠️ [ERROR] Invalid JSON response! API: $api_url"
                echo "Response Text: $body"
            fi
        else
            echo "⚠️ [ERROR] API: $api_url | Status: $http_status | Retrying..."
            sleep 2
        fi
    done
}

# Define a list of predefined messages
user_messages=(
    "Do you believe everything happens for a reason or do we create our own fate?"
    "If you could ask one question and get the absolute truth what would you ask?"
    "What’s something society values that you think is overrated?"
    "Do you think people are inherently good or bad?"
    "What’s the best book or movie you’ve experienced recently?"
    "If you could instantly master any skill what would it be?"
    "What’s the strangest coincidence you’ve ever experienced?"
    "If you had to describe yourself in three words what would they be?"
    "What’s the most unforgettable trip you’ve ever taken?"
    "Have you ever had a moment that completely changed your perspective on life?"
    "What’s one lesson you’ve learned the hard way?"
    "If you could give your younger self one piece of advice what would it be?"
    "What’s something you’re currently working on improving about yourself?"
    "What does success look like to you?"
    "If you could relive one day in your life which would it be and why?"
    "What’s a risk you took that paid off?"
    "How has your day been so far?"
    "What’s something interesting you’ve learned recently?"
    "Do you have any fun plans for the weekend?"
    "What’s a hobby you’ve been into lately?"
    "What do you enjoy doing in your free time?"
    "If you could live anywhere in the world where would it be?"
    "What’s your favorite way to relax after a long day?"
    "Do you prefer movies books or TV shows?"
    "If you could have dinner with any historical figure who would it be?"
    "What’s a belief or opinion you’ve changed over time?"
    "What’s something you’re really passionate about?"
    "If money wasn’t an issue how would you spend your time?"
    "What do you love most about your job?"
    "What’s the best career advice you’ve ever received?"
    "If you could start your own business what would it be?"
    "What skills are you currently working on improving?"
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

# Set number of threads to 1 (default)
num_threads=1
echo "✅ Using 1 thread..."

# Function to run the single thread
start_thread() {
    while true; do
        # Pick a random message from the predefined list
        random_message="${user_messages[$RANDOM % ${#user_messages[@]}]}"
        send_request "$random_message" "$api_key" "$api_url"
    done
}

# Start the single thread
start_thread &

# Wait for the thread to finish (this will run indefinitely)
wait

# Graceful exit handling (SIGINT, SIGTERM)
trap "echo -e '\n🛑 Process terminated. Exiting gracefully...'; exit 0" SIGINT SIGTERM
