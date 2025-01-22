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

# Green color for advertisement
GREEN="\033[0;32m"
RESET="\033[0m"

# Advertisement in Green
echo -e "${GREEN}"
echo "🚀 THIS SCRIPT IS PROUDLY CREATED BY **GA CRYPTO**! 🚀"
echo "==============================================="
echo "🚀 Follow us for updates and more:"
echo "   • Telegram: https://t.me/GaCryptOfficial"
echo "   • X (formerly Twitter): https://x.com/GACryptoO"
echo "==============================================="
echo -e "${RESET}"

# Installation and configuration process starts here
echo "==========================================================="
echo "🚀 Starting installation and configuration of Multiple Node 🚀"
echo "==========================================================="

# Download the Multiple client tarball
echo "📥 Downloading Multiple for Linux..."
wget https://cdn.app.multiple.cc/client/linux/x64/multipleforlinux.tar

# Extract the tarball
echo "📂 Extracting the installation package..."
if tar -xvf multipleforlinux.tar; then
  echo "Extraction successful!"
else
  echo "Error: Extraction failed!"
  exit 1
fi

# Grant permissions to the extracted folder
echo "🔑 Granting permissions to the extracted folder..."
chmod -R 777 multipleforlinux

# Navigate to the extracted directory
echo "📂 Navigating to the extracted directory..."
cd multipleforlinux

# Grant executable permissions to CLI and Node binaries
echo "🔧 Setting executable permissions 1 ..."
chmod +x ./multiple-cli

# Navigate to the extracted directory
echo "📂 Navigating to the extracted directory..."
cd multipleforlinux

# Grant executable permissions to CLI and Node binaries
echo "🔧 Setting executable permissions 2 ..."
chmod +x ./multiple-node

# Add the directory to PATH
echo "🔗 Adding Multiple to system PATH..."
echo "PATH=\$PATH:/root/multipleforlinux" | sudo tee -a /etc/profile

# Apply the changes to the current session
echo "🔄 Sourcing /etc/profile to apply PATH changes..."
source /etc/profile

# Navigate to the extracted directory
echo "📂 Navigating to the extracted directory..."
cd multipleforlinux

# Start the Multiple node in the background
echo "🚀 Starting the Multiple node..."
nohup ./multiple-node > output.log 2>&1 &

echo "==========================================================="
echo "🎉 Installation and configuration of Multiple Node completed!"
echo "🌟 Powered by GA Crypto!"
echo ""
echo "📢 Stay connected for updates:"
echo "   • Telegram: https://t.me/GaCryptOfficial"
echo "   • X (formerly Twitter): https://x.com/GACryptoO"
echo ""
echo "==========================================================="
