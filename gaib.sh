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
    "How do black holes form, and what happens if an object falls into one?"
    "What are the fundamental forces of nature, and how do they govern the universe?"
    "How does the process of nuclear fusion power the sun and other stars?"
    "What are quantum mechanics and their impact on our understanding of physics?"
    "How do vaccines work to protect the human body from diseases?"
    "What is the theory of relativity, and how does it change our perception of time and space?"
    "Why is the water cycle essential for sustaining life on Earth?"
    "How do genetic mutations lead to evolution and biodiversity?"
    "What is climate change, and what are its long-term effects on Earth?"
    "How do the human brain and nervous system process information?"
    "What is artificial intelligence, and how is it transforming industries?"
    "How does blockchain technology work, and what are its real-world applications?"
    "What are the key differences between functional programming and object-oriented programming?"
    "How does cloud computing function, and what are its benefits and drawbacks?"
    "What are algorithms, and how do they impact software development and efficiency?"
    "How does cybersecurity work to protect sensitive data from hackers?"
    "What is machine learning, and how is it different from traditional programming?"
    "How do search engines like Google rank websites and display search results?"
    "What are data structures, and why are they essential in programming?"
    "How do quantum computers work, and how do they differ from classical computers?"
    "What are the causes and consequences of geopolitical conflicts in modern history?"
    "How does international trade impact the economy of different nations?"
    "What role does the United Nations play in maintaining global peace and security?"
    "How do alliances like NATO and BRICS shape global power dynamics?"
    "What are the major causes of economic inequality between different countries?"
    "How do immigration policies impact both developed and developing nations?"
    "Why is the South China Sea a region of strategic importance and conflict?"
    "How do financial institutions like the IMF and World Bank influence global economies?"
    "What are the key factors that determine a country's military strength?"
    "How do climate change policies impact international relations and trade agreements?"
    "What are the long-term benefits of strength training for overall health?"
    "How does diet influence physical and mental performance?"
    "Why is sleep important for muscle recovery and overall well-being?"
    "What are the key differences between aerobic and anaerobic exercise?"
    "How does intermittent fasting affect metabolism and weight loss?"
    "What are the physiological effects of stress on the human body?"
    "How does cardiovascular exercise impact heart health and longevity?"
    "What are the dangers of a sedentary lifestyle, and how can one counteract them?"
    "How do different body types respond to various workout routines?"
    "What are the most effective methods to improve flexibility and mobility?"
    "What are the key responsibilities and challenges faced by an IAS officer?"
    "How does the IPS contribute to law enforcement and national security?"
    "What are the major reforms needed in the Indian judicial system?"
    "How does India's civil service examination ensure the selection of the best candidates?"
    "What are the differences between the Indian Penal Code (IPC) and the Criminal Procedure Code (CrPC)?"
    "How does bureaucracy impact governance and policy-making in India?"
    "What are the major challenges in maintaining law and order in a diverse country like India?"
    "How do IAS officers play a role in disaster management and crisis response?"
    "What are the key qualities required to become a successful civil servant?"
    "How does public administration ensure transparency and accountability in government?"

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
