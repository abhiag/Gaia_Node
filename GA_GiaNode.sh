#!/bin/bash

##########################################################################################
#                                                                                        
# 
# ░██████╗░░█████╗░  ░█████╗░██████╗░██╗░░░██╗██████╗░████████╗░█████╗░
# ██╔════╝░██╔══██╗  ██╔══██╗██╔══██╗╚██╗░██╔╝██╔══██╗╚══██╔══╝██╔══██╗
# ██║░░██╗░███████║  ██║░░╚═╝██████╔╝░╚████╔╝░██████╔╝░░░██║░░░██║░░██║
# ██║░░╚██╗██╔══██║  ██║░░██╗██╔══██╗░░╚██╔╝░░██╔═══╝░░░░██║░░░██║░░██║
# ╚██████╔╝██║░░██║  ╚█████╔╝██║░░██║░░░██║░░░██║░░░░░░░░██║░░░╚█████╔╝
# ░╚═════╝░╚═╝░░╚═╝  ░╚════╝░╚═╝░░╚═╝░░░╚═╝░░░╚═╝░░░░░░░░╚═╝░░░░╚════╝░
#                                                                                        
#                🚀 THIS SCRIPT IS PROUDLY CREATED BY **GA CRYPTO**! 🚀                 
#                                                                                        
#   🌐 Join our revolution in decentralized networks and crypto innovation!              
#                                                                                        
# 📢 Stay updated:                                                                      
#     • Follow us on Telegram: https://t.me/GaCryptOfficial                             
#     • Follow us on X: https://x.com/GACryptoO                                         
#                                                                                        
##########################################################################################

# Display the welcome message in a friendly, engaging way
echo "==========================================================="
echo "🚀 Welcome to GA Crypto's Automated GaiaNet Node Installer 🚀"
echo "==========================================================="
echo ""
echo "🌟 Your journey to the decentralized future begins now!"
echo "✨ Let the script handle everything as you sit back and relax!"
echo ""
echo "📡 Downloading and setting up GaiaNet node... 🚀"
echo ""

# Install GaiaNet node with status update
echo "📥 Installing GaiaNet node..."
curl -sSfL 'https://github.com/GaiaNet-AI/gaianet-node/releases/latest/download/install.sh' | bash
echo "Installation Status: $?"  # Shows the exit status of installation

# Source the updated bashrc to apply environment variables
echo "🔄 Applying environment variables..."
source ~/.bashrc
echo "Bash Configuration Status: $?"  # Shows the exit status of sourcing bashrc

# Initialize GaiaNet node with configuration
echo "⚙️ Initializing GaiaNet node with the latest configuration..."
gaianet init --config https://raw.githubusercontent.com/GaiaNet-AI/node-configs/refs/heads/main/llama-3.2-3b-instruct/config.json
echo "Initialization Status: $?"  # Shows the exit status of initialization

# Start the GaiaNet node
echo "🚀 Starting the GaiaNet node..."
gaianet start
echo "Start Status: $?"  # Shows the exit status of starting the node

# Fetch and display GaiaNet node info
echo "🔍 Fetching node status and information..."
gaianet info
echo "Info Status: $?"  # Shows the exit status of fetching node info

# Closing message with celebration
echo ""
echo "==========================================================="
echo "🎉 Congratulations! Your GaiaNet node is now up and running! 🎉"
echo ""
echo "🌟 This script was brought to you by GA Crypto! 🌟"
echo "   • Stay connected for the latest updates:"
echo "     - Telegram: https://t.me/GaCryptOfficial"
echo "     - X (formerly Twitter): https://x.com/GACryptoO"
echo ""
echo "💪 Together, we can build the future of decentralized networks!"
echo "==========================================================="
