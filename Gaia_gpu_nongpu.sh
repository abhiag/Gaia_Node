#!/bin/bash

# Ensure pciutils is installed
echo "📦 Installing pciutils (required for GPU detection)..."
sudo apt update -y && sudo apt install -y pciutils
sudo apt update -y && sudo apt-get install -y libgomp1

# Function to check if an NVIDIA GPU is present
check_nvidia_gpu() {
    if lspci | grep -i nvidia &> /dev/null; then
        echo "✅ NVIDIA GPU detected."
        return 0
    else
        echo "⚠️ No NVIDIA GPU found."
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

# Set up CUDA environment variables
setup_cuda_env() {
    echo "🔧 Configuring CUDA environment variables..."
    CUDA_PATH="/usr/local/cuda"
    EXPORT_LD_LIBRARY_PATH="export LD_LIBRARY_PATH=${CUDA_PATH}/lib64:\$LD_LIBRARY_PATH"
    EXPORT_PATH="export PATH=${CUDA_PATH}/bin:\$PATH"
    BASHRC="$HOME/.bashrc"
    
    # Add to shell config
    if ! grep -qxF "$EXPORT_LD_LIBRARY_PATH" "$BASHRC"; then
        echo "$EXPORT_LD_LIBRARY_PATH" >> "$BASHRC"
    fi
    if ! grep -qxF "$EXPORT_PATH" "$BASHRC"; then
        echo "$EXPORT_PATH" >> "$BASHRC"
    fi

    # Apply changes immediately
    export LD_LIBRARY_PATH=${CUDA_PATH}/lib64:$LD_LIBRARY_PATH
    export PATH=${CUDA_PATH}/bin:$PATH
    source ~/.bashrc
    echo "✅ CUDA environment configured!"
}

# Function to install GaiaNet
install_gaianet() {
    echo "📥 Installing GaiaNet node..."
    curl -sSfL 'https://github.com/GaiaNet-AI/gaianet-node/releases/latest/download/install.sh' | bash
    if [ $? -eq 0 ]; then
        echo "✅ GaiaNet node installation successful!"
    else
        echo "❌ Error: GaiaNet node installation failed!"
        exit 1
    fi
}

# Function to add GaiaNet binary to PATH
add_gaianet_to_path() {
    echo "🔗 Adding GaiaNet binary to PATH..."
    echo 'export PATH=$PATH:/opt/gaianet/' >> ~/.bashrc && source ~/.bashrc
}

# Detect GPU
if check_nvidia_gpu; then
    echo "🔍 Checking CUDA installation..."
    if ! get_cuda_version; then
        install_cuda
        setup_cuda_env
    fi

    # Determine CUDA version for GaiaNet installation
    GGML_CUDA_VERSION="12"
    if [[ "$CUDA_VERSION" == 11* ]]; then
        GGML_CUDA_VERSION="11"
    elif [[ "$CUDA_VERSION" == 12* ]]; then
        GGML_CUDA_VERSION="12"
    fi
    echo "🔧 Using --ggmlcuda $GGML_CUDA_VERSION for GaiaNet installation."

    # Install GaiaNet with CUDA support
    install_gaianet
    add_gaianet_to_path
    echo "⚙️ Initializing GaiaNet node with CUDA..."
    gaianet init --config https://raw.githubusercontent.com/abhiag/Gaia_Node/main/config1.json
else
    # Install GaiaNet without CUDA
    install_gaianet
    add_gaianet_to_path
    echo "⚙️ Initializing GaiaNet node without CUDA..."
    gaianet init --config https://raw.githubusercontent.com/abhiag/Gaia_Node/main/config2.json
fi

# Start the GaiaNet node
echo "🚀 Starting GaiaNet node..."
gaianet config --domain gaia.domains
gaianet start
if [ $? -eq 0 ]; then
    echo "✅ GaiaNet node started successfully!"
else
    echo "❌ Error: Failed to start GaiaNet node!"
    exit 1
fi

# Display GaiaNet node info
echo "🔍 Fetching GaiaNet node information..."
gaianet info
if [ $? -eq 0 ]; then
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
