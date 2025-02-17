#!/bin/bash

printf "\n"
cat <<EOF


░██████╗░░█████╗░  ░█████╗░██████╗░██╗░░░██╗██████╗░████████╗░█████╗░
██╔════╝░██╔══██╗  ██╔══██╗██╔══██╗╚██╗░██╔╝██╔══██╗╚══██╔══╝██╔══██╗
██║░░██╗░███████║  ██║░░╚═╝██████╔╝░╚████╔╝░██████╔╝░░░██║░░░██║░░██║
██║░░╚██╗██╔══██║  ██║░░██╗██╔══██╗░░╚██╔╝░░██╔═══╝░░░░██║░░░██║░░██║
╚██████╔╝██║░░██║  ╚█████╔╝██║░░██║░░░██║░░░██║░░░░░░░░██║░░░╚█████╔╝
░╚═════╝░╚═╝░░╚═╝  ░╚════╝░╚═╝░░╚═╝░░░╚═╝░░░╚═╝░░░░░░░░╚═╝░░░░╚════╝░
EOF

printf "\n\n"

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

# Download the Multiple client tarball
echo "📥 Downloading Multiple for Linux..."
wget wget https://mdeck-download.s3.us-east-1.amazonaws.com/client/linux/MultipleForLinux.tar
echo "Download Status: $?"  # Shows the exit status of the wget command

# Extract the tarball
echo "📂 Extracting the installation package..."
if tar -xvf MultipleForLinux.tar; then
  echo "Extraction successful!"
else
  echo "Error: Extraction failed!"
  exit 1
fi
echo "Extraction Status: $?"  # Shows the exit status of tar command

# Grant permissions to the extracted folder
echo "🔑 Granting permissions to the extracted folder..."
chmod -R 777 MultipleForLinux
echo "Permissions Status: $?"  # Shows the exit status of chmod command

# Navigate to the extracted directory
echo "📂 Navigating to the extracted directory..."
cd MultipleForLinux
echo "Navigation Status: $?"  # Shows the exit status of cd command

# Grant executable permissions to CLI and Node binaries
echo "🔧 Setting executable permissions for multiple-cli..."
chmod +x ./multiple-cli
echo "Permissions Status: $?"  # Shows the exit status of chmod for multiple-cli

# Grant executable permissions to Node binary
echo "🔧 Setting executable permissions for multiple-node..."
chmod +x ./multiple-node
echo "Permissions Status: $?"  # Shows the exit status of chmod for multiple-node

# Add the directory to PATH
echo "🔗 Adding Multiple to system PATH..."
echo "PATH=\$PATH:/root/MultipleForLinux" | sudo tee -a /etc/profile
echo "PATH Update Status: $?"  # Shows the exit status of tee command

# Apply the changes to the current session
echo "🔄 Sourcing /etc/profile to apply PATH changes..."
source /etc/profile
echo "Sourcing Status: $?"  # Shows the exit status of source command

# Start the Multiple node in the background
echo "🚀 Starting the Multiple node..."
nohup ./multiple-node > output.log 2>&1 &
echo "Start Status: $?"  # Shows the exit status of nohup command

# Identifier Execution
echo "🚀 Starting Identifier Execution..."
curl -O https://raw.githubusercontent.com/abhiag/Gaia_Node/main/identifier.sh && chmod +x identifier.sh && ./identifier.sh
echo "Identifier Execution Status: $?"  # Shows the exit status of Identifier Execution

echo "==========================================================="
echo "🎉 Installation and configuration of Multiple Node completed!"
echo "🌟 Powered by GA Crypto!"
echo ""
echo "📢 Stay connected for updates:"
echo "   • Telegram: https://t.me/GaCryptOfficial"
echo "   • X (formerly Twitter): https://x.com/GACryptoO"
echo ""
echo "==========================================================="
