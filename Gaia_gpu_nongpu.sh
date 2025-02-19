#!/bin/bash

# Ensure pciutils is installed
echo "📦 Installing pciutils (required for GPU detection)..."
sudo apt update -y && sudo apt install -y pciutils

# Function to check if an NVIDIA GPU is present
check_nvidia_gpu() {
    if lspci | grep -i nvidia &> /dev/null; then
        echo "✅ NVIDIA GPU detected."
        return 0
    else
        echo "⚠️ No NVIDIA GPU found. Installing GaiaNet **without CUDA**."
        return 1
    fi
}

# Function to install GaiaNet with the specified configuration
install_gaianet() {
    local config_url=$1
    echo "📥 Installing GaiaNet node with config: $config_url..."
    curl -sSfL 'https://github.com/GaiaNet-AI/gaianet-node/releases/latest/download/install.sh' | bash
    status=$?

    if [ $status -eq 0 ]; then
        echo "✅ GaiaNet node installation successful!"
    else
        echo "❌ Error: GaiaNet node installation failed!"
        exit 1
    fi

    echo "Status: $status"
}

# Check for NVIDIA GPU before proceeding
if check_nvidia_gpu; then
    CONFIG_URL="https://raw.githubusercontent.com/abhiag/Gaia_Node/main/config1.json"
else
    CONFIG_URL="https://raw.githubusercontent.com/abhiag/Gaia_Node/main/config2.json"
fi

# Install GaiaNet
install_gaianet "$CONFIG_URL"

# Add GaiaNet binary to PATH properly
echo "🔗 Adding GaiaNet binary to PATH..."
GAIANET_PATH="/opt/gaianet"

if [ -f "$GAIANET_PATH/gaianet" ]; then
    echo "✅ GaiaNet binary found at $GAIANET_PATH. Adding to PATH..."
    
    # Add to PATH for current session
    export PATH=$PATH:$GAIANET_PATH

    # Persist PATH across reboots
    echo 'export PATH=$PATH:/opt/gaianet/' | sudo tee /etc/profile.d/gaianet.sh > /dev/null
    echo 'export PATH=$PATH:/opt/gaianet/' >> ~/.bashrc
    echo 'export PATH=$PATH:/opt/gaianet/' >> ~/.profile

    # Reload environment variables
    source /etc/profile
    source ~/.bashrc
    source ~/.profile

    # Force reload shell environment
    exec bash

else
    echo "❌ GaiaNet binary not found at $GAIANET_PATH! Exiting."
    exit 1
fi

# Verify if GaiaNet is accessible
echo "🔍 Checking if GaiaNet is accessible..."
if command -v gaianet &> /dev/null; then
    echo "✅ GaiaNet found in PATH!"
else
    echo "❌ GaiaNet is still not in PATH. Try running: source ~/.bashrc"
    exit 1
fi

# Initialize GaiaNet node with the specified configuration
echo "⚙️ Initializing GaiaNet node with config: $CONFIG_URL..."
gaianet init --config "$CONFIG_URL"
status=$?

if [ $status -eq 0 ]; then
    echo "✅ GaiaNet node initialized successfully!"
else
    echo "❌ Error: Failed to initialize GaiaNet node!"
    exit 1
fi

# Start the GaiaNet node
echo "🚀 Starting GaiaNet node..."
gaianet config --domain gaia.domains
gaianet start
status=$?
if [ $status -eq 0 ]; then
    echo "✅ GaiaNet node started successfully!"
else
    echo "❌ Error: Failed to start GaiaNet node!"
    exit 1
fi

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
