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
    "How does photosynthesis work?"
    "Can you explain gravity in simple words?"
    "How does blockchain technology work?"
    "How does a computer work?"
    "What is a black hole?"
    "How do airplanes stay in the sky?"
    "How old is the Earth?"
    "What causes the seasons to change?"
    "How does the internet work?"
    "What does DNA stand for?"
    "How do fish breathe underwater?"
    "Why do we need sleep?"
    "What is a solar eclipse?"
    "What is the function of the heart?"
    "What is the difference between weather and climate?"
    "What is an ecosystem?"
    "What is a cell?"
    "How do magnets work?"
    "How do plants grow?"
    "What is a virus?"
    "What is Python used for?"
    "Can you explain what an API is?"
    "Do you think AI will replace human jobs?"
    "How can I improve my memory?"
    "What are the best habits for success?"
    "How do you define happiness?"
    "What are the pros and cons of social media?"
    "Can you describe a futuristic city?"
    "If you could time travel, where would you go?"
    "Why do humans need to exercise?"
    "How do vaccines work?"
    "What are the effects of climate change?"
    "Why is the ocean important to the planet?"
    "How does the human brain store memories?"
    "Why do humans dream?"
    "How does electricity work?"
    "What happens when you mix baking soda and vinegar?"
    "How do birds know where to migrate?"
    "Why is water essential for life?"
    "What happens inside a volcano?"
    "Why do different cultures have different traditions?"
    "How do historians study ancient civilizations?"
    "How do astronauts prepare for space missions?"
    "What makes a good leader?"
    "How do submarines work?"
    "What are the steps of the scientific method?"
    "Why do people speak different languages?"
    "How does renewable energy work?"
    "Why do some animals hibernate?"
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
    sleep 0
done
