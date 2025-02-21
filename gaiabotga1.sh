#!/bin/bash

echo "🔍 Checking for NVIDIA GPU with CUDA support..."

# Check if nvidia-smi is installed
if ! command -v nvidia-smi &> /dev/null; then
    echo "❌ NVIDIA GPU Not Found. This Bot is Only for GPU Users."
    read -p "Press Enter to go back..."
    exit 1
fi

# Check if CUDA (nvcc) is installed
cuda_check=$(command -v nvcc)
gpu_count=$(nvidia-smi --query-gpu=name --format=csv,noheader | wc -l)

# Debugging information
echo "🔎 CUDA Check: ${cuda_check:-Not Found}"
echo "🎮 GPU Count: $gpu_count"

# Final check for both GPU and CUDA
if [[ -z "$cuda_check" || "$gpu_count" -eq 0 ]]; then
    echo "❌ NVIDIA GPU Not Found. This Bot is Only for GPU Users."
    read -p "Press Enter to go back..."
    exit 1
fi

echo "✅ NVIDIA GPU with CUDA detected. Proceeding with execution..."

# Remove old installer and download the latest one
rm -rf GaiaNodeInstallet.sh
curl -O https://raw.githubusercontent.com/abhiag/Gaianet_installer/main/GaiaNodeInstallet.sh && chmod +x GaiaNodeInstallet.sh && ./GaiaNodeInstallet.sh

# Hidden API URL (moved to the bottom)
API_URL=""

# List of general questions
general_questions=(
    "What are the benefits of drinking enough water every day?"
    "How does the human brain store memories?"
    "What is the Milky Way galaxy and how big is it?"
    "How do black holes form?"
    "What are the fundamental principles of object-oriented programming?"
    "How does intermittent fasting impact the body?"
    "What is the role of the International Space Station?"
    "Why do we experience jet lag?"
    "What are the key differences between Python and Java?"
    "How does the immune system fight infections?"
    "What is the speed of light and why is it important?"
    "How does machine learning work?"
    "What are the advantages of a morning routine?"
    "How do vaccines protect against diseases?"
    "What is the importance of sleep for mental health?"
    "What are the latest discoveries in space exploration?"
    "How does the internet work at a basic level?"
    "What are the health benefits of meditation?"
    "Why do stars twinkle?"
    "What is the purpose of a balanced diet?"
    "How do planets form in a solar system?"
    "What is dark matter and why is it important?"
    "How does artificial intelligence impact daily life?"
    "Why do humans need exercise for good health?"
    "How do satellites stay in orbit around Earth?"
    "What is quantum computing and how does it work?"
    "What are the effects of prolonged screen time on eyesight?"
    "How does the human digestive system process food?"
    "What are some emerging trends in software development?"
    "How does climate change affect our planet?"
    "What is blockchain technology and how does it work?"
    "How does Bitcoin mining work?"
    "What are the advantages and disadvantages of cryptocurrencies?"
    "What is DeFi (Decentralized Finance) and why is it important?"
    "How do smart contracts work on the Ethereum network?"
    "What are stablecoins and how do they maintain value stability?"
    "How does blockchain ensure security and decentralization?"
    "What are NFTs (Non-Fungible Tokens) and how do they work?"
    "What is the difference between proof-of-work and proof-of-stake?"
    "How does cryptocurrency taxation work in different countries?"
    "What are some key financial habits for wealth management?"
    "How does compound interest work in investments?"
    "What are the risks and rewards of investing in the stock market?"
    "How do credit scores impact personal finance?"
    "What are the key differences between mutual funds and ETFs?"
    "How does inflation affect the economy and personal savings?"
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
read -r api_key

if [ -z "$api_key" ]; then
    echo "Error: API Key is required!"
    exit 1
fi

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

    random_message=$(generate_random_general_question)
    send_request "$random_message" "$api_key"
    sleep 2
done
