#!/bin/bash

# Hidden API URL (moved to the bottom)
API_URL=""

# Function to generate a fully random math question
generate_random_math_question() {
    num1=$((RANDOM % 100))
    num2=$((RANDOM % 100 + 1))  # Avoid division by zero
    operator=$((RANDOM % 4))    # 0 = +, 1 = -, 2 = ×, 3 = ÷

    case $operator in
        0) question="What is $num1 + $num2?" ;;
        1) question="What is $num1 - $num2?" ;;
        2) question="What is $num1 × $num2?" ;;
        3) question="What is $((num1 * num2)) ÷ $num2?" ;; # Ensures whole number result
    esac

    echo "$question"
}

# List of predefined GK questions
gk_questions=(
    "What is the capital of France?"
    "Who wrote 'Romeo and Juliet'?"
    "What is the largest planet in our Solar System?"
    "Who painted the Mona Lisa?"
    "What is the chemical symbol for gold?"
    "Who was the first President of the United States?"
    "What is the longest river in the world?"
    "Who discovered gravity?"
    "Which is the tallest mountain in the world?"
    "What is the hardest natural substance on Earth?"
    "What is the boiling point of water in Celsius?"
)

# Function to get a random GK question
generate_random_gk_question() {
    echo "${gk_questions[$RANDOM % ${#gk_questions[@]}]}"
}

# Function to handle the API request
send_request() {
    local message="$1"
    local api_key="$2"

    echo "📩 Sending Question: $message"

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
        ((success_count++))  # Increment success count
        echo "✅ [SUCCESS] Response $success_count Received!"
        echo "📝 Question: $message"
        echo "💬 Response: $response_message"
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
success_count=0  # Initialize success counter

while true; do
    current_time=$(date +%s)
    elapsed=$((current_time - start_time))

    if [[ "$elapsed" -ge "$max_duration" ]]; then
        echo "🛑 Time limit reached ($bot_hours hours). Exiting..."
        echo "📊 Total successful responses: $success_count"
        exit 0
    fi

    # Randomly decide whether to ask a math or GK question (50% chance each)
    if (( RANDOM % 2 == 0 )); then
        random_message=$(generate_random_math_question)
    else
        random_message=$(generate_random_gk_question)
    fi
    
    send_request "$random_message" "$api_key"
    sleep 2
done
