#!/bin/bash

# Ensure required packages are installed
echo "📦 Installing dependencies..."
sudo apt update -y && sudo apt install -y pciutils libgomp1 curl wget
sudo apt update && sudo apt install -y build-essential libglvnd-dev pkg-config

# Function to check if an NVIDIA GPU is present
check_nvidia_gpu() {
    if command -v nvidia-smi &> /dev/null; then
        echo "✅ NVIDIA GPU detected."
        return 0
    elif lspci | grep -i nvidia &> /dev/null; then
        echo "✅ NVIDIA GPU detected (via lspci)."
        return 0
    else
        echo "⚠️ No NVIDIA GPU found."
        return 1
    fi
}

# Function to check CUDA version
get_cuda_version() {
    if command -v nvcc &> /dev/null; then
        CUDA_VERSION=$(nvcc --version | grep 'release' | awk '{print $6}' | cut -d',' -f1)
        echo "✅ CUDA version detected: $CUDA_VERSION"
        if [[ "$CUDA_VERSION" == 11* ]]; then
            GGMLCUDA_VERSION=11
        else
            GGMLCUDA_VERSION=12
        fi
        return 0
    else
        echo "⚠️ CUDA not found. Installing CUDA Toolkit 12.8..."
        install_cuda
    fi
}

# Function to install CUDA Toolkit
install_cuda() {
    if grep -qi microsoft /proc/version; then
        echo "🖥️ Running inside WSL. Installing CUDA Toolkit for WSL..."
        wget https://developer.download.nvidia.com/compute/cuda/repos/wsl-ubuntu/x86_64/cuda-wsl-ubuntu.pin
        sudo mv cuda-wsl-ubuntu.pin /etc/apt/preferences.d/cuda-repository-pin-600
        wget https://developer.download.nvidia.com/compute/cuda/12.8.0/local_installers/cuda-repo-wsl-ubuntu-12-8-local_12.8.0-1_amd64.deb
        sudo dpkg -i cuda-repo-wsl-ubuntu-12-8-local_12.8.0-1_amd64.deb
        sudo cp /var/cuda-repo-wsl-ubuntu-12-8-local/cuda-*-keyring.gpg /usr/share/keyrings/
        sudo apt-get update
        sudo apt-get -y install cuda-toolkit-12-8
    elif grep -q 'Ubuntu 22' /etc/os-release; then
        echo "🖥️ Installing CUDA Toolkit for Ubuntu 22.04..."
        wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-ubuntu2204.pin
        sudo mv cuda-ubuntu2204.pin /etc/apt/preferences.d/cuda-repository-pin-600
        wget https://developer.download.nvidia.com/compute/cuda/12.8.0/local_installers/cuda-repo-ubuntu2204-12-8-local_12.8.0-570.86.10-1_amd64.deb
        sudo dpkg -i cuda-repo-ubuntu2204-12-8-local_12.8.0-570.86.10-1_amd64.deb
        sudo cp /var/cuda-repo-ubuntu2204-12-8-local/cuda-*-keyring.gpg /usr/share/keyrings/
        sudo apt-get update
        sudo apt-get -y install cuda-toolkit-12-8
    elif grep -q 'Ubuntu 24' /etc/os-release; then
        echo "🖥️ Installing CUDA Toolkit for Ubuntu 24.04..."
        wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2404/x86_64/cuda-ubuntu2404.pin
        sudo mv cuda-ubuntu2404.pin /etc/apt/preferences.d/cuda-repository-pin-600
        wget https://developer.download.nvidia.com/compute/cuda/12.8.0/local_installers/cuda-repo-ubuntu2404-12-8-local_12.8.0-570.86.10-1_amd64.deb
        sudo dpkg -i cuda-repo-ubuntu2404-12-8-local_12.8.0-570.86.10-1_amd64.deb
        sudo cp /var/cuda-repo-ubuntu2404-12-8-local/cuda-*-keyring.gpg /usr/share/keyrings/
        sudo apt-get update
        sudo apt-get -y install cuda-toolkit-12-8
    fi
    setup_cuda_env
}

# Function to set up environment variables
setup_cuda_env() {
    echo "🔧 Setting up CUDA environment variables..."
    echo 'export PATH=/usr/local/cuda-12.8/bin${PATH:+:${PATH}}' >> ~/.bashrc
    echo 'export LD_LIBRARY_PATH=/usr/local/cuda-12.8/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}' >> ~/.bashrc
    source ~/.bashrc
}

# Run checks and installations
if check_nvidia_gpu; then
    get_cuda_version
    setup_cuda_env
    install_gaianet
    add_gaianet_to_path
    echo "⚙️ Initializing GaiaNet node with CUDA..."
    gaianet init --config https://raw.githubusercontent.com/abhiag/Gaia_Node/main/config1.json || { echo "❌ GaiaNet initialization failed!"; exit 1; }
else
    install_gaianet
    add_gaianet_to_path
    echo "⚙️ Initializing GaiaNet node without CUDA..."
    gaianet init --config https://raw.githubusercontent.com/abhiag/Gaia_Node/main/config2.json || { echo "❌ GaiaNet initialization failed!"; exit 1; }
fi

# Start GaiaNet node
echo "🚀 Starting GaiaNet node..."
gaianet config --domain gaia.domains
gaianet start || { echo "❌ Error: Failed to start GaiaNet node!"; exit 1; }

echo "🔍 Fetching GaiaNet node information..."
gaianet info || { echo "❌ Error: Failed to fetch GaiaNet node information!"; exit 1; }

echo "==========================================================="
echo "🎉 Congratulations! Your GaiaNet node is successfully set up!"
echo "🌟 Stay connected: Telegram: https://t.me/GaCryptOfficial | Twitter: https://x.com/GACryptoO"
echo "💪 Together, let's build the future of decentralized networks!"
echo "==========================================================="
