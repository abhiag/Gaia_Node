#!/bin/bash

#!/bin/bash

# Function to check if NVIDIA CUDA or GPU is present
check_cuda() {
    if command -v nvcc &> /dev/null || command -v nvidia-smi &> /dev/null; then
        echo "❌ NVIDIA GPU Detected! This script is for non-GPU users only."
        echo "Press Enter to go back and Run Non-GPU or VPS Supported BOT..." 
        read -r  # Waits for user input

        # Remove old script, download and execute new one
        rm -rf GaiaNodeInstallet.sh 
        curl -O https://raw.githubusercontent.com/abhiag/Gaianet_installer/main/GaiaNodeInstallet.sh
        chmod +x GaiaNodeInstallet.sh
        ./GaiaNodeInstallet.sh

        exit 1
    fi
}

# Run the check
check_cuda

echo "✅ No NVIDIA CUDA detected. Proceeding with the script..."

# Hidden API domain
API_URL="https://hyper.gaia.domains/v1/chat/completions"

# Function to generate a random math question
generate_random_math_question() {
    local num1=$((RANDOM % 100))
    local num2=$((RANDOM % 100))
    local operators=("+" "-" "*" "÷")
    local operator=${operators[RANDOM % ${#operators[@]}]}
    echo "What is $num1 $operator $num2?"
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
        "What color is the sky?"
    "How many legs does a dog have?"
    "What sound does a cat make?"
    "Which number comes after 4?"
    "What is the opposite of 'hot'?"
    "What do you use to brush your teeth?"
    "What is the first letter of the alphabet?"
    "What shape is a football?"
    "How many fingers do humans have?"
    "What is 1 + 1?"
    "What do you wear on your feet?"
    "What animal says 'moo'?"
    "How many eyes does a person have?"
    "What do you call a baby dog?"
    "Which fruit is yellow and curved?"
    "What do you drink when you're thirsty?"
    "What do bees make?"
    "What is the name of our planet?"
    "What do you do with a book?"
    "What color is grass?"
    "What is the opposite of 'up'?"
    "How many wheels does a bicycle have?"
    "Where do fish live?"
    "What do you use to write on a blackboard?"
    "What shape is a pizza?"
    "What do you call a baby cat?"
    "What is 5 minus 2?"
    "What do you use to cut paper?"
    "What is the color of a banana?"
    "What do birds use to fly?"
    "What do you wear on your head to keep warm?"
    "How many days are in a week?"
    "What do you use an umbrella for?"
    "What does ice turn into when it melts?"
    "How many ears does a rabbit have?"
    "Which season comes after summer?"
    "What color is the sun?"
    "What do cows give us to drink?"
    "Which fruit is red and has seeds inside?"
    "What do you do with a bed?"
    "What sound does a duck make?"
    "How many toes do you have?"
    "What do you call a baby chicken?"
    "What do you put on your cereal?"
    "Which is bigger, an elephant or a mouse?"
    "What do you do with a spoon?"
    "How many arms does an octopus have?"
    "What is the color of a strawberry?"
    "Which day comes after Monday?"
    "What do you use to open a door?"
    "What sound does a cow make?"
    "Where do penguins live?"
    "What do you call a baby horse?"
    "What do you use to write on paper?"
    "Which is faster, a car or a bicycle?"
    "How many ears does a human have?"
    "What do you wear on your hands when it’s cold?"
    "What do you use to see things?"
    "What do you do with a pillow?"
    "How many arms does a starfish have?"
    "What is the color of a lemon?"
    "What do you call a house for birds?"
    "Where do chickens live?"
    "Which is taller, a giraffe or a cat?"
    "What do you use to comb your hair?"
    "What do you call a baby sheep?"
    "How many hands does a clock have?"
    "What do you call a place with lots of books?"
    "Which animal has a long trunk?"
    "What is the color of a watermelon?"
    "What do you do with a TV?"
    "What is the opposite of small?"
    "How many sides does a triangle have?"
    "What do you call a group of stars in the sky?"
    "What do you use to eat soup?"
    "What do you use to clean your hands?"
    "What do monkeys love to eat?"
    "Where do polar bears live?"
    "What do you call a baby cow?"
    "What does a clock show?"
    "What do you wear when it’s raining?"
    "What is something that barks?"
    "What do you use to make a phone call?"
    "What do you use to wash your hair?"
    "What do you do with a blanket?"
    "Which animal can hop and has a pouch?"
    "What do you call a baby duck?"
    "What do you use to tie your shoes?"
    "How many wings does a butterfly have?"
    "What do you wear to protect your eyes from the sun?"
    "What do you do with a birthday cake?"
    "What do you wear on your wrist to tell time?"
    "What do you call a baby frog?"
    "What do you eat for breakfast?"
    "What do you do when you’re sleepy?"
    "What is the color of the moon?"
    "How many legs does a spider have?"
    "Where do turtles live?"
    "What do you do with a soccer ball?"
    "What do you call a baby fish?"
    "What do you wear on your head when riding a bike?"
    "What do you do when you hear music?"
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
    echo "❌ Error: API Key is required!"
        echo "🔄 Restarting the installer..."

        # Restart installer
        rm -rf GaiaNodeInstallet.sh
        curl -O https://raw.githubusercontent.com/abhiag/Gaianet_installer/main/GaiaNodeInstallet.sh && chmod +x GaiaNodeInstallet.sh && ./GaiaNodeInstallet.sh

        exit 1
    else
        break  # Exit loop if API key is provided
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
        sleep 10
    done
}

start_thread &

wait

trap "echo -e '\n🛑 Process terminated. Exiting gracefully...'; exit 0" SIGINT SIGTERM
