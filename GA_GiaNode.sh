#!/bin/bash

##########################################################################################
#                                                                                        
# ██████╗  █████╗      ██████╗██████╗ ██╗   ██╗██████╗ ████████╗███████╗██████╗ ██████╗  
# ██╔══██╗██╔══██╗    ██╔════╝██╔══██╗██║   ██║██╔══██╗╚══██╔══╝██╔════╝██╔══██╗██╔══██╗ 
# ██████╔╝███████║    ██║     ██████╔╝██║   ██║██████╔╝   ██║   █████╗  ██████╔╝██║  ██║ 
# ██╔═══╝ ██╔══██║    ██║     ██╔═══╝ ██║   ██║██╔═══╝    ██║   ██╔══╝  ██╔═══╝ ██║  ██║ 
# ██║     ██║  ██║    ╚██████╗██║     ╚██████╔╝██║        ██║   ███████╗██║     ██████╔╝ 
# ╚═╝     ╚═╝  ╚═╝     ╚═════╝╚═╝      ╚═════╝ ╚═╝        ╚═╝   ╚══════╝╚═╝     ╚═════╝  
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

# Source the updated bashrc
echo "🔄 Sourcing .bashrc to apply environment variables..."
source ~/.bashrc

# Initialize GaiaNet node with the specified configuration
echo "⚙️  Initializing GaiaNet node with the latest configuration..."
gaianet init --config https://raw.githubusercontent.com/GaiaNet-AI/node-configs/refs/heads/main/llama-3.2-3b-instruct/config.json

# Start the GaiaNet node
echo "🚀 Starting GaiaNet node..."
gaianet start

# Display GaiaNet node info
echo "🔍 Fetching GaiaNet node information..."
gaianet info

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
