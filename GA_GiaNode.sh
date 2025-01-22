#!/bin/bash

printf "\n"
cat <<EOF

────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
─██████████████─██████████████────██████████████─████████████████───████████──████████─██████████████─██████████████─██████████████─
─██░░░░░░░░░░██─██░░░░░░░░░░██────██░░░░░░░░░░██─██░░░░░░░░░░░░██───██░░░░██──██░░░░██─██░░░░░░░░░░██─██░░░░░░░░░░██─██░░░░░░░░░░██─
─██░░██████████─██░░██████░░██────██░░██████████─██░░████████░░██───████░░██──██░░████─██░░██████░░██─██████░░██████─██░░██████░░██─
─██░░██─────────██░░██──██░░██────██░░██─────────██░░██────██░░██─────██░░░░██░░░░██───██░░██──██░░██─────██░░██─────██░░██──██░░██─
─██░░██─────────██░░██████░░██────██░░██─────────██░░████████░░██─────████░░░░░░████───██░░██████░░██─────██░░██─────██░░██──██░░██─
─██░░██──██████─██░░░░░░░░░░██────██░░██─────────██░░░░░░░░░░░░██───────████░░████─────██░░░░░░░░░░██─────██░░██─────██░░██──██░░██─
─██░░██──██░░██─██░░██████░░██────██░░██─────────██░░██████░░████─────────██░░██───────██░░██████████─────██░░██─────██░░██──██░░██─
─██░░██──██░░██─██░░██──██░░██────██░░██─────────██░░██──██░░██───────────██░░██───────██░░██─────────────██░░██─────██░░██──██░░██─
─██░░██████░░██─██░░██──██░░██────██░░██████████─██░░██──██░░██████───────██░░██───────██░░██─────────────██░░██─────██░░██████░░██─
─██░░░░░░░░░░██─██░░██──██░░██────██░░░░░░░░░░██─██░░██──██░░░░░░██───────██░░██───────██░░██─────────────██░░██─────██░░░░░░░░░░██─
─██████████████─██████──██████────██████████████─██████──██████████───────██████───────██████─────────────██████─────██████████████─
────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
EOF

printf "\n\n"

##########################################################################################
#                                                                                        
#                🚀 THIS SCRIPT IS PROUDLY CREATED BY **GA CRYPTO**! 🚀                 
#                                                                                        
#   🌐 Join our revolution in decentralized networks and crypto innovation!               
#                                                                                        
# 📢 Stay updated:                                                                      
#     • Follow us on Telegram: https://t.me/GaCryptOfficial                             
#     • Follow us on X: https://x.com/GACryptoO                                         

##########################################################################################

# Green color for advertisement
GREEN="\033[0;32m"
RESET="\033[0m"

# Print the advertisement using printf
printf "${GREEN}"
printf "🚀 THIS SCRIPT IS PROUDLY CREATED BY **GA CRYPTO**! 🚀\n"
printf "Stay connected for updates:\n"
printf "   • Telegram: https://t.me/GaCryptOfficial\n"
printf "   • X (formerly Twitter): https://x.com/GACryptoO\n"
printf "${RESET}"

# Installation and configuration process starts here
echo "==========================================================="
echo "🚀 Welcome to GA Crypto's Automated GaiaNet Node Installer 🚀"
echo "==========================================================="
echo ""
echo "🌟 Your journey to decentralized networks begins here!"
echo "✨ Follow the steps as the script runs automatically for you!"
echo ""

# Install GaiaNet node
echo "📥 Installing GaiaNet node..."
curl -sSfL 'https://github.com/GaiaNet-AI/gaianet-node/releases/latest/download/install.sh' | bash
status=$?
if [ $status -eq 0 ]; then
    echo "✅ GaiaNet node installation successful!"
else
    echo "❌ Error: GaiaNet node installation failed!"
    exit 1
fi
echo "Status: $status"

# Add GaiaNet to PATH
echo "🔗 Adding GaiaNet to system PATH..."
echo "export PATH=\$PATH:/usr/local/bin" >> ~/.bashrc
status=$?
if [ $status -eq 0 ]; then
    echo "✅ GaiaNet added to PATH successfully!"
else
    echo "❌ Error: Failed to add GaiaNet to PATH!"
    exit 1
fi
echo "Status: $status"

# Source the updated bashrc
echo "🔄 Sourcing .bashrc to apply environment variables..."
source ~/.bashrc
status=$?
if [ $status -eq 0 ]; then
    echo "✅ Successfully sourced .bashrc!"
else
    echo "❌ Error: Failed to source .bashrc!"
    exit 1
fi
echo "Status: $status"

# Initialize GaiaNet node with the specified configuration
echo "⚙️ Initializing GaiaNet node with the latest configuration..."
gaianet init --config https://raw.githubusercontent.com/GaiaNet-AI/node-configs/refs/heads/main/llama-3.2-3b-instruct/config.json
status=$?
if [ $status -eq 0 ]; then
    echo "✅ GaiaNet node initialized successfully!"
else
    echo "❌ Error: Failed to initialize GaiaNet node!"
    exit 1
fi
echo "Status: $status"

# Start the GaiaNet node
echo "🚀 Starting GaiaNet node..."
gaianet start
status=$?
if [ $status -eq 0 ]; then
    echo "✅ GaiaNet node started successfully!"
else
    echo "❌ Error: Failed to start GaiaNet node!"
    exit 1
fi
echo "Status: $status"

# Display GaiaNet node info
echo "🔍 Fetching GaiaNet node information..."
gaianet info
status=$?
if [ $status -eq 0 ]; then
    echo "✅ GaiaNet node information fetched successfully!"
else
    echo "❌ Error: Failed to fetch GaiaNet node information!"
    exit 1
fi
echo "Status: $status"

# Closing message
echo ""
echo "==========================================================="
echo "🎉 Congratulations! Your GaiaNet node is successfully set up!"
echo ""
echo "🌟 This script was brought to you by GA Crypto!"
echo "   • Stay connected for the latest updates:"
echo "     Telegram: https://t.me/GaCryptOfficial"
echo "     X (formerly Twitter): https://x.com/GACryptoO"
echo ""
echo "💪 Together, let's build the future of decentralized networks!"
echo "==========================================================="
