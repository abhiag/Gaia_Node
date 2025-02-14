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
    "Llama-3-8B-Lexi-Uncensored-GGUF"
    "Llama-3-8b_Rust_8k_PT_RPL"
    "codegemma-7b-it"
    "codestral-0.1-22b"
    "deepseek-2.5-236b"
    "deepseek-r1-distill-llama-70b"
    "deepseek-r1-distill-llama-8b"
    "gemma-1.1-7b-it"
    "gemma-2-27b-it"
    "gemma-2-9b-it"
    "llama-2-7b"
    "llama-3-70b-instruct"
    "llama-3-8b-instruct-262k"
    "llama-3-8b-instruct"
    "llama-3-8b-instruct_london"
    "llama-3-8b-instruct_paris"
    "llama-3-Korean-Bllossom-8B"
    "llama-3-groq-8b-tool"
    "llama-3.1-70b-instruct"
    "llama-3.1-8b-instruct"
    "llama-3.1-8b-instruct_basechain"
    "llama-3.1-8b-instruct_chemistry"
    "llama-3.1-8b-instruct_pastor"
    "llama-3.1-8b-instruct_rustlang"
    "llama-3.1-8b-instruct_samsung-s24"
    "llama-3.1-nemotron-70b-instruct"
    "llama-3.2-1b-instruct"
    "llama-3.2-1b-instruct_paris"
    "llama-3.2-3b-instruct"
    "llama-3.2-3b-instruct_paris"
    "llama-3.3-70b-instruct"
    "mathstral-7b"
    "mistral-0.3-7b-instruct-tool-call"
    "Llama-3.2-7B-Instruct-Q5_K_M"
    "Mistral-7B-Instruct"
    "Falcon-40B-Instruct"
    "Qwen2.5-7B-Instruct-Q5_K_M"
    "T5-Large"
    "BERT-Base-Uncased"
    "YOLOv8"
    "ResNet50"
    "Vision-Transformer-Base"
    "CLIP-ViT-B-32"
    "SAM (Segment Anything Model)"
    "Stable-Diffusion-v1-5"
    "MidJourney"
    "Whisper-Large-v2"
    "DeepSpeech-0.9.3"
    "CodeLlama-13B"
    "StarCoder-Base"
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
