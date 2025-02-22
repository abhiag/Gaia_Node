#!/bin/bash

# Function to check if NVIDIA CUDA or GPU is present
check_cuda() {
    if command -v nvcc &> /dev/null || command -v nvidia-smi &> /dev/null; then
        echo "✅ NVIDIA GPU with CUDA detected. Proceeding with execution..."
    else
        echo "❌ NVIDIA GPU Not Found. This Bot is Only for GPU Users."
        echo "Press Enter to go back and Run on GPU Device..."  
        read -r  # Waits for user input

        # Restart installer
        rm -rf GaiaNodeInstallet.sh
        curl -O https://raw.githubusercontent.com/abhiag/Gaianet_installer/main/GaiaNodeInstallet.sh && chmod +x GaiaNodeInstallet.sh && ./GaiaNodeInstallet.sh

        exit 1
    fi
}

# Run the check
check_cuda

# Check if jq is installed, and if not, install it
if ! command -v jq &> /dev/null; then
    echo "❌ jq not found. Installing jq..."
    sudo apt update && sudo apt install jq -y
    if [ $? -eq 0 ]; then
        echo "✅ jq installed successfully!"
    else
        echo "❌ Failed to install jq. Please install jq manually and re-run the script."
        exit 1
    fi
else
    echo "✅ jq is already installed."
fi

# List of general questions
general_questions=( 
    "What is the capital of France?"
    "Who wrote 'Romeo and Juliet'?"
    "What is the largest ocean on Earth?"
    "How many continents are there?"
    "What is the boiling point of water in Celsius?"
    "Who was the first person to walk on the moon?"
    "Which planet is known as the Red Planet?"
    "What is the national animal of the United States?"
    "Who discovered gravity?"
    "What is the tallest mountain in the world?"
    "What is the chemical symbol for gold?"
    "Which country is known as the Land of the Rising Sun?"
    "What is the longest river in the world?"
    "How many bones are there in the human body?"
    "Who painted the Mona Lisa?"
    "What is the hardest natural substance on Earth?"
    "Which is the smallest country in the world?"
    "Who invented the telephone?"
    "What is the currency of Japan?"
    "Which gas do plants use for photosynthesis?"
    "Who was the first President of the United States?"
    "Which ocean is the deepest?"
    "What is the main language spoken in Brazil?"
    "Which planet has the most moons?"
    "Who is known as the Father of Computers?"
    "What is the capital of Canada?"
    "What is the national sport of India?"
    "What does DNA stand for?"
    "Which country has the largest population?"
    "What year did World War II end?"
    "What is the square root of 144?"
    "How many hearts does an octopus have?"
    "Which element is represented by 'O' on the periodic table?"
    "What is the speed of light in a vacuum?"
    "Who discovered America?"
    "What is the largest desert in the world?"
    "Which blood type is known as the universal donor?"
    "What is the capital of Australia?"
    "How many planets are in our solar system?"
    "What is the largest mammal on Earth?"
)

# Function to get a random general question
generate_random_general_question() {
    echo "${general_questions[$RANDOM % ${#general_questions[@]}]}"
}

# Function to handle the API request
send_request() {
    local message="$1"
    local api_key="$2"

    echo "📬 Sending Question: $message"

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

    # Extract the 'content' from the JSON response using jq (Suppress errors)
    response_message=$(echo "$body" | jq -r '.choices[0].message.content' 2>/dev/null)

    if [[ "$http_status" -eq 200 ]]; then
        if [[ -z "$response_message" ]]; then
            echo "⚠️ Response content is empty!"
        else
            ((success_count++))  # Increment success count
            echo "✅ [SUCCESS] Response $success_count Received!"
            echo "📝 Question: $message"
            echo "💬 Response: $response_message"
        fi
    else
        echo "⚠️ [ERROR] API request failed | Status: $http_status | Retrying..."
        sleep 2
    fi
}

# Asking for API Key (loops until a valid key is provided)
while true; do
    echo -n "Enter your API Key: "
    read -r api_key

    if [ -z "$api_key" ]; then
        echo "❌ Error: API Key is required!"
        echo "🔄 Restarting the installer..."

        # Restart installer
        rm -rf GaiaNodeInstallet.sh
        curl -O https://raw.githubusercontent.com/abhiag/Gaianet_installer/main/GaiaNodeInstallet.sh && chmod +x GaiaNodeInstallet.sh && ./GaiaNodeInstallet.sh

        exit 1
    else
        break  # Exit loop if API key is provided
    fi
done

# Asking for duration
echo -n "⏳ How many hours do you want the bot to run? "
read -r bot_hours

# Convert hours to seconds
if [[ "$bot_hours" =~ ^[0-9]+$ ]]; then
    max_duration=$((bot_hours * 3600))
    echo "🕒 The bot will run for $bot_hours hour(s) ($max_duration seconds)."
else
    echo "⚠️ Invalid input! Please enter a number."
    exit 1
fi

# Hidden API URL (moved to the bottom)
API_URL="https://gadao.gaia.domains/v1/chat/completions"

# Display thread information
echo "✅ Using 1 thread..."
echo "⏳ Waiting 30 seconds before sending the first request..."
sleep 5

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

    random_message=$(generate_random_general_question)
    send_request "$random_message" "$api_key"
    sleep 2
done
