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

# Print the advertisement in green
echo -e "${GREEN}"
echo "🚀 THIS SCRIPT IS PROUDLY CREATED BY **GA CRYPTO**! 🚀"
echo "Stay connected for updates:"
echo "   • Telegram: https://t.me/GaCryptOfficial"
echo "   • X (formerly Twitter): https://x.com/GACryptoO"
echo -e "${RESET}"

# Installation and configuration process starts here
echo "==========================================================="
echo "🚀 Starting installation and configuration of Multiple Node 🚀"
echo "==========================================================="

#!/bin/bash

# Download the Multiple client tarball
echo "📥 Downloading Multiple for Linux..."
wget https://cdn.app.multiple.cc/client/linux/x64/multipleforlinux.tar
echo "Status: $?"  # Shows the exit status of the wget command

# Extract the tarball
echo "📂 Extracting the installation package..."
if tar -xvf multipleforlinux.tar; then
  echo "Extraction successful!"
else
  echo "Error: Extraction failed!"
  exit 1
fi
echo "Status: $?"  # Shows the exit status of the tar command

# Grant permissions to the extracted folder
echo "🔑 Granting permissions to the extracted folder..."
chmod -R 777 multipleforlinux
echo "Status: $?"  # Shows the exit status of chmod command

# Navigate to the extracted directory
echo "📂 Navigating to the extracted directory..."
cd multipleforlinux
echo "Status: $?"  # Shows the exit status of cd command

# Grant executable permissions to CLI and Node binaries
echo "🔧 Setting executable permissions 1 ..."
chmod +x ./multiple-cli
echo "Status: $?"  # Shows the exit status of chmod command for multiple-cli

# Grant executable permissions to CLI and Node binaries
echo "🔧 Setting executable permissions 2 ..."
chmod +x ./multiple-node
echo "Status: $?"  # Shows the exit status of chmod command for multiple-node

# Add the directory to PATH
echo "🔗 Adding Multiple to system PATH..."
echo "PATH=\$PATH:/root/multipleforlinux" | sudo tee -a /etc/profile
echo "Status: $?"  # Shows the exit status of echo/tee command

# Apply the changes to the current session
echo "🔄 Sourcing /etc/profile to apply PATH changes..."
source /etc/profile
echo "Status: $?"  # Shows the exit status of source command

# Start the Multiple node in the background
echo "🚀 Starting the Multiple node..."
nohup ./multiple-node > output.log 2>&1 &
echo "Status: $?"  # Shows the exit status of nohup command

# Prompt the user for the identifier
read -p "Enter your identifier (XXXXXXXX): " identifier

# Prompt the user for the PIN
read -p "Enter your PIN (XXXXXX): " pin

# Print the values for debugging
echo "Identifier: $identifier"
echo "PIN: $pin"

# Execute the bind command with the provided inputs
echo "~/multipleforlinux/Executing: multiple-cli bind --bandwidth-download 100000 --identifier $identifier --pin $pin --storage 700000000 --bandwidth-upload 100000"
~/multipleforlinux/multiple-cli bind --bandwidth-download 100000 --identifier "$identifier" --pin "$pin" --storage 700000000 --bandwidth-upload 100000

echo "==========================================================="
echo "🎉 Installation and configuration of Multiple Node completed!"
echo "🌟 Powered by GA Crypto!"
echo ""
echo "📢 Stay connected for updates:"
echo "   • Telegram: https://t.me/GaCryptOfficial"
echo "   • X (formerly Twitter): https://x.com/GACryptoO"
echo ""
echo "==========================================================="
