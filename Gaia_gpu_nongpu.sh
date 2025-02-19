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

# Function to check if CUDA is installed and return its version
get_cuda_version() {
    if command -v nvcc &> /dev/null; then
        CUDA_VERSION=$(nvcc --version | grep "release" | awk '{print $6}' | cut -d',' -f1)
        echo "✅ Detected CUDA version: $CUDA_VERSION"
        return 0
    else
        echo "❌ CUDA is not installed."
        return 1
    fi
}

# Function to install CUDA
install_cuda() {
    echo "📥 Installing CUDA..."
    sudo apt update -y
    sudo apt install -y nvidia-cuda-toolkit
    if command -v nvcc &> /dev/null; then
        CUDA_VERSION=$(nvcc --version | grep "release" | awk '{print $6}' | cut -d',' -f1)
        echo "✅ CUDA installation successful! Installed version: $CUDA_VERSION"
    else
        echo "❌ Error: CUDA installation failed!"
        exit 1
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
    # If NVIDIA GPU is present, check if CUDA is installed
    if ! get_cuda_version; then
        install_cuda
        get_cuda_version  # Recheck after installation
    fi
    CONFIG_URL="https://raw.githubusercontent.com/abhiag/Gaia_Node/main/config1.json"
else
    CONFIG_URL="https://raw.githubusercontent.com/abhiag/Gaia_Node/main/config2.json"
fi

# Install GaiaNet with the determined configuration
install_gaianet "$CONFIG_URL"

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

# Add GaiaNet binary to PATH
echo "🔗 Adding GaiaNet binary to PATH..."
if [ -f "/opt/gaianet/gaianet" ]; then
    echo "✅ GaiaNet binary found in /opt/gaianet/. Adding to PATH..."
    export PATH=$PATH:/opt/gaianet/
    echo 'export PATH=$PATH:/opt/gaianet/' | sudo tee -a /etc/profile.d/gaianet.sh > /dev/null
    echo 'export PATH=$PATH:/opt/gaianet/' >> ~/.bashrc
    echo 'export PATH=$PATH:/opt/gaianet/' >> ~/.profile
    source ~/.bashrc
    source ~/.profile
else
    echo "❌ GaiaNet binary not found in /opt/gaianet/! Proceeding with installation..."
fi

# Verify if GaiaNet is accessible
echo "🔍 Checking if GaiaNet is accessible..."
if command -v gaianet &> /dev/null; then
    echo "✅ GaiaNet found in PATH!"
else
    echo "❌ GaiaNet is still not in PATH. Try running: source ~/.bashrc"
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
