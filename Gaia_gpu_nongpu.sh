#!/bin/bash

# Ensure pciutils is installed
echo "📦 Installing pciutils (required for GPU detection)..."
sudo apt update -y && sudo apt install -y pciutils

# Function to install GaiaNet without CUDA using config2.json
install_gaianet_without_cuda() {
    echo "📥 Installing GaiaNet node **without CUDA**..."
    curl -sSfL 'https://github.com/GaiaNet-AI/gaianet-node/releases/latest/download/install.sh' | bash
    status=$?

    if [ $status -eq 0 ]; then
        echo "✅ GaiaNet node installation successful (without CUDA)!"
    else
        echo "❌ Error: GaiaNet node installation failed!"
        exit 1
    fi

    echo "⚙️ Initializing GaiaNet node with config2.json..."
    gaianet init --config https://raw.githubusercontent.com/abhiag/Gaia_Node/main/config2.json
    exit 0
}

# Function to check for NVIDIA GPU
check_nvidia_gpu() {
    if lspci | grep -i nvidia &> /dev/null; then
        echo "✅ NVIDIA GPU detected."
        return 0
    else
        echo "⚠️ No NVIDIA GPU found. Installing GaiaNet **without CUDA**."
        install_gaianet_without_cuda
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

# Function to install GaiaNet with CUDA using config1.json
install_gaianet_with_cuda() {
    echo "📥 Installing GaiaNet node with CUDA $GGML_CUDA_VERSION support..."
    curl -sSfL 'https://github.com/GaiaNet-AI/gaianet-node/releases/latest/download/install.sh' | bash -s -- --ggmlcuda "$GGML_CUDA_VERSION"
    status=$?

    if [ $status -eq 0 ]; then
        echo "✅ GaiaNet node installation successful!"
    else
        echo "❌ Error: GaiaNet node installation failed!"
        exit 1
    fi

    echo "⚙️ Initializing GaiaNet node with config1.json..."
    gaianet init --config https://raw.githubusercontent.com/abhiag/Gaia_Node/main/config1.json
}

# Check for NVIDIA GPU before proceeding
check_nvidia_gpu

# If NVIDIA GPU is present, check if CUDA is installed
if ! get_cuda_version; then
    install_cuda
    get_cuda_version  # Recheck after installation
fi

# Determine CUDA version for GaiaNet installation
GGML_CUDA_VERSION="12"  # Default to CUDA 12 if unknown
if [[ "$CUDA_VERSION" == 11* ]]; then
    GGML_CUDA_VERSION="11"
elif [[ "$CUDA_VERSION" == 12* ]]; then
    GGML_CUDA_VERSION="12"
else
    echo "⚠️ Unsupported CUDA version detected: $CUDA_VERSION. Defaulting to CUDA 12."
fi

# Install GaiaNet with CUDA using config1.json
install_gaianet_with_cuda

# Start GaiaNet node
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
