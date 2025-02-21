#!/bin/bash

# Ensure required packages are installed
echo "📦 Installing dependencies..."
sudo apt update -y && sudo apt install -y pciutils libgomp1 curl wget
sudo apt update && sudo apt install -y build-essential libglvnd-dev pkg-config

# Detect if running inside WSL
IS_WSL=false
if grep -qi microsoft /proc/version; then
    IS_WSL=true
    echo "🖥️ Running inside WSL."
else
    echo "🖥️ Running on a native Ubuntu system."
fi

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
        CUDA_VERSION=$(nvcc --version | grep 'release' | awk '{print $6}' | cut -d',' -f1 | cut -d'.' -f1)
        echo "✅ CUDA version detected: $CUDA_VERSION"

        # Install GaiaNet with appropriate CUDA version
        if [[ "$CUDA_VERSION" == "11" ]]; then
            curl -sSfL 'https://github.com/GaiaNet-AI/gaianet-node/releases/latest/download/install.sh' | bash -s -- --ggmlcuda 11
        elif [[ "$CUDA_VERSION" == "12" ]]; then
            curl -sSfL 'https://github.com/GaiaNet-AI/gaianet-node/releases/latest/download/install.sh' | bash -s -- --ggmlcuda 12
        else
            echo "⚠️ Unsupported CUDA version detected. Exiting..."
            exit 1
        fi
        return 0
    else
        echo "⚠️ CUDA not found. Installing CUDA Toolkit 12.8..."
        install_cuda
    fi
}

# Function to install CUDA Toolkit 12.8 based on environment
install_cuda() {
    if $IS_WSL; then
        echo "🖥️ Running inside WSL. Installing CUDA for WSL..."
        wget https://developer.download.nvidia.com/compute/cuda/repos/wsl-ubuntu/x86_64/cuda-wsl-ubuntu.pin
        sudo mv cuda-wsl-ubuntu.pin /etc/apt/preferences.d/cuda-repository-pin-600
        wget https://developer.download.nvidia.com/compute/cuda/12.8.0/local_installers/cuda-repo-wsl-ubuntu-12-8-local_12.8.0-1_amd64.deb
        sudo dpkg -i cuda-repo-wsl-ubuntu-12-8-local_12.8.0-1_amd64.deb
        sudo cp /var/cuda-repo-wsl-ubuntu-12-8-local/cuda-*-keyring.gpg /usr/share/keyrings/
    else
        UBUNTU_VERSION=$(lsb_release -rs)

        if [[ "$UBUNTU_VERSION" == "22.04" ]]; then
            echo "🖥️ Installing CUDA for Ubuntu 22.04..."
            wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-ubuntu2204.pin
            sudo mv cuda-ubuntu2204.pin /etc/apt/preferences.d/cuda-repository-pin-600
            wget https://developer.download.nvidia.com/compute/cuda/12.8.0/local_installers/cuda-repo-ubuntu2204-12-8-local_12.8.0-570.86.10-1_amd64.deb
            sudo dpkg -i cuda-repo-ubuntu2204-12-8-local_12.8.0-570.86.10-1_amd64.deb
            sudo cp /var/cuda-repo-ubuntu2204-12-8-local/cuda-*-keyring.gpg /usr/share/keyrings/
        elif [[ "$UBUNTU_VERSION" == "24.04" ]]; then
            echo "🖥️ Installing CUDA for Ubuntu 24.04..."
            wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2404/x86_64/cuda-ubuntu2404.pin
            sudo mv cuda-ubuntu2404.pin /etc/apt/preferences.d/cuda-repository-pin-600
            wget https://developer.download.nvidia.com/compute/cuda/12.8.0/local_installers/cuda-re
