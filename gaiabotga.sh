#!/bin/bash

# API Configuration
API_URL="https://gadao.gaia.domains/v1/chat/completions"

# Function to handle the API request
send_request() {
    local message="$1"
    local api_key="$2"

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
        response=$(curl -s -w "\n%{http_code}" -X POST "$API_URL" \
            -H "Authorization: Bearer $api_key" \
            -H "Accept: application/json" \
            -H "Content-Type: application/json" \
            -d "$json_data")

        # Extract the HTTP status code from the response
        http_status=$(echo "$response" | tail -n 1)
        body=$(echo "$response" | head -n -1)

        if [[ "$http_status" -eq 200 ]]; then
            echo "✅ [SUCCESS] API: $API_URL | Message: '$message'"
            
            # Extract the response message from the JSON
            response_message=$(echo "$body" | jq -r '.choices[0].message.content')

            # Print both the question and the response
            echo "Question: $message"
            echo "Response: $response_message"

            # Wait for 3 minutes before sending the next request
            echo "⏳ Waiting for 2 minutes before the next request..."
            sleep 120  # 120 seconds = 2 minutes
        else
            echo "⚠️ [ERROR] API: $API_URL | Status: $http_status | Retrying in a random time between 2-5 minutes..."

            # Generate a random delay between 120 (2 min) and 300 (5 min) seconds
            random_delay=$((RANDOM % 180 + 120))

            echo "⏳ Waiting for $random_delay seconds before retrying..."
            sleep $random_delay
        fi
    done
}

# Define a list of math-related questions for kids
user_messages=(
    "Who is the president of the United States"
    "What is the capital of Japan"
    "How does photosynthesis work"
    "Why is the sky blue"
    "Who wrote the book 1984"
    "Tell me a joke"
    "Can you create a short bedtime story"
    "What’s the best way to stay motivated"
    "If you could time travel where would you go"
    "What’s your favorite food"
    "If I have 5 apples and give 2 away how many do I have left"
    "What is 23 × 17"
    "Can you explain gravity in simple words"
    "How can I improve my memory"
    "What are some easy exercises to stay fit"
    "What are the best habits for success"
    "Can you describe a futuristic city"
    "Do you think AI will replace human jobs"
    "How do you define happiness"
    "What are the pros and cons of social media"
    "What is Python used for"
    "Can you explain what an API is"
    "How does blockchain technology work"
    "What is the difference between RAM and ROM"
    "What is the largest animal on Earth"
    "How many continents are there"
    "Who invented the lightbulb"
    "What is the boiling point of water"
    "What is the difference between a mammal and a reptile"
    "How does a computer work"
    "What is a black hole"
    "What are the main colors of the rainbow"
    "How do airplanes stay in the sky"
    "What is the fastest land animal"
    "What is the longest river in the world"
    "How old is the Earth"
    "Who discovered electricity"
    "What is the speed of light"
    "What are the phases of the moon"
    "What is the chemical formula for water"
    "Can you name the planets in our solar system"
    "What is the square root of 64"
    "What is the tallest mountain in the world"
    "How does the internet work"
    "What is the capital of France"
    "What does DNA stand for"
    "How many bones are in the human body"
    "How do fish breathe underwater"
    "What causes the seasons to change"
    "What is a food chain"
    "What is the smallest country in the world"
    "What are the primary colors"
    "How does a microwave oven work"
    "What is the hottest planet in the solar system"
    "What does the word “photosynthesis” mean"
    "What is the most common gas in the Earth’s atmosphere"
    "What is the largest desert in the world"
    "How many hours are in a day"
    "How many days are in a year"
    "What is the smallest planet in the solar system"
    "Who was the first man on the moon"
    "Why do we need sleep"
    "What is a solar eclipse"
    "What is the function of the heart"
    "What is the difference between weather and climate"
    "What is an ecosystem"
    "What is a cell"
    "How do magnets work"
    "What is the tallest tree in the world"
    "Who painted the Mona Lisa"
    "How do plants grow"
    "What is the main purpose of the lungs"
    "What is the largest ocean in the world"
    "How do clouds form"
    "What is a virus"
    "Why do we have two eyes"
    "What is the capital of Australia"
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

# Ask the user to input API Key
echo -n "Enter your API Key: "
read api_key

# Exit if the API Key is empty
if [ -z "$api_key" ]; then
    echo "Error: API Key is required!"
    exit 1
fi

# Function to run the thread (only one thread)
start_thread() {
    while true; do
        # Pick a random message from the predefined list
        random_message="${user_messages[$RANDOM % ${#user_messages[@]}]}"
        send_request "$random_message" "$api_key"
    done
}

# Graceful exit handling (SIGINT, SIGTERM)
trap "echo -e '\n🛑 Process terminated. Exiting gracefully...'; exit 0" SIGINT SIGTERM

# Start the single thread
start_thread

echo "All requests have been processed."  # This will never be reached because of the infinite loop
