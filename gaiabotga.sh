#!/bin/bash

# Function to check if NVIDIA CUDA is installed
if command -v nvidia-smi &> /dev/null && nvidia-smi -L &> /dev/null; then
    echo "❌ NVIDIA GPU detected! This script is for non-GPU users only."
    exit 1
fi

echo "✅ No NVIDIA GPU detected. Proceeding with the script..."

# Hidden API domain (not displayed to users)
API_URL="https://hyper.gaia.domains/v1/chat/completions"

# Function to generate a random math question
generate_random_math_question() {
    local num1=$((RANDOM % 100))
    local num2=$((RANDOM % 100))
    local operators=("+ - * ÷")
    local operator=($operators)
    echo "What is $num1 ${operator[RANDOM % ${#operator[@]}]} $num2?"
}

# Function to generate a random general knowledge question
generate_random_gk_question() {
    local gk_questions=(
        "Who is the current President of the United States?"
        "What is the capital of Japan?"
        "Which planet is known as the Red Planet?"
        "Who wrote 'To Kill a Mockingbird'?"
        "What is the largest ocean on Earth?"
        "Which country has the most population?"
        "What is the fastest land animal?"
        "Who discovered gravity?"
    )
    echo "${gk_questions[RANDOM % ${#gk_questions[@]}]}"
}

# Function to send an API request
send_request() {
    local message="$1"
    local api_key="$2"
    local count="$3"

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

        response=$(curl -s -w "\n%{http_code}" -X POST "$API_URL" \
            -H "Authorization: Bearer $api_key" \
            -H "Accept: application/json" \
            -H "Content-Type: application/json" \
            -d "$json_data")

        http_status=$(echo "$response" | tail -n 1)
        body=$(echo "$response" | head -n -1)

        if [[ "$http_status" -eq 200 ]]; then
            echo "$body" | jq . > /dev/null 2>&1
            if [ $? -eq 0 ]; then
                response_message=$(echo "$body" | jq -r '.choices[0].message.content')
                
                echo "✅ [SUCCESS] Response $count Received!"
                echo "Question: $message"
                echo "Response: $response_message"
                break  
            else
                echo "⚠️ [ERROR] Invalid JSON response!"
                echo "Response Text: $body"
            fi
        else
            echo "⚠️ [ERROR] Status: $http_status | Retrying..."
            sleep 2
        fi
    done
}

# Ask for API Key
echo -n "Enter your API Key: "
read api_key

if [ -z "$api_key" ]; then
    echo "Error: API Key is required!"
    exit 1
fi

echo "⏳ Waiting 30 seconds before sending the first request..."
sleep 30

# Response counter
response_count=0

# Function to start the process
start_thread() {
    while true; do
        # Randomly decide between math and GK questions
        if (( RANDOM % 2 == 0 )); then
            random_message=$(generate_random_math_question)
        else
            random_message=$(generate_random_gk_question)
        fi

        ((response_count++))
        send_request "$random_message" "$api_key" "$response_count"
        sleep 20
    done
}

start_thread &

wait

trap "echo -e '\n🛑 Process terminated. Exiting gracefully...'; exit 0" SIGINT SIGTERM
