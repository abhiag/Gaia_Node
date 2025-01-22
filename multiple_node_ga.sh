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
##########################################################################################

echo "==========================================================="
echo "🚀 Starting installation and configuration of Multiple Node 🚀"
echo "==========================================================="

# Download the Multiple client tarball
echo "📥 Downloading Multiple for Linux..."
wget https://cdn.app.multiple.cc/client/linux/x64/multipleforlinux.tar

# Extract the tarball
echo "📂 Extracting the installation package..."
tar -xvf multipleforlinux.tar

# Grant permissions to the extracted folder
echo "🔑 Granting permissions to the extracted folder..."
chmod -R 777 multipleforlinux

# Navigate to the extracted directory
echo "📂 Navigating to the extracted directory..."
cd multipleforlinux

# Grant executable permissions to CLI and Node binaries
echo "🔧 Setting executable permissions..."
chmod +x ./multiple-cli
chmod +x ./multiple-node

# Add the directory to PATH
echo "🔗 Adding Multiple to system PATH..."
echo "PATH=\$PATH:/root/multipleforlinux" | sudo tee -a /etc/profile

# Apply the changes to the current session
echo "🔄 Sourcing /etc/profile to apply PATH changes..."
source /etc/profile

# Start the Multiple node in the background
echo "🚀 Starting the Multiple node..."
nohup ~/multipleforlinux/multiple-node > output.log 2>&1 &

# Prompt the user for the identifier
read -p "Enter your identifier (XXXXXXXX): " identifier

# Prompt the user for the PIN
read -p "Enter your PIN (XXXXXX): " pin

# Execute the bind command with the provided inputs
multiple-cli bind --bandwidth-download 100000 --identifier "$identifier" --pin "$pin" --storage 100000000 --bandwidth-upload 100000

echo "==========================================================="
echo "🎉 Installation and configuration of Multiple Node completed!"
echo "🌟 Powered by GA Crypto!"
echo ""
echo "📢 Stay connected for updates:"
echo "   • Telegram: https://t.me/GaCryptOfficial"
echo "   • X (formerly Twitter): https://x.com/GACryptoO"
echo ""
echo "==========================================================="
