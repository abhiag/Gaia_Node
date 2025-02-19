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

##########################################################################################
#                                                                                        
#                🚀 THIS SCRIPT IS PROUDLY CREATED BY **GA CRYPTO**! 🚀                 
#                                                                                        
#   🌐 Join our revolution in decentralized networks and crypto innovation!               
#                                                                                        
# 📢 Stay updated:                                                                      
#     • Follow us on Telegram: https://t.me/GaCryptOfficial                             
#     • Follow us on X: https://x.com/GACryptoO                                         
##########################################################################################

# Green color for advertisement
GREEN="\033[0;32m"
RESET="\033[0m"

set -e  # Exit on error

# Ensure required packages are installed
echo "📦 Installing dependencies..."
sudo apt update -y && sudo apt install -y pciutils libgomp1

# Function to check if an NVIDIA GPU is present
check_nvidia_gpu() {
    if command -v nvidia-smi &> /dev/null; then
        echo "✅ NVIDIA GPU detected."
        return 0
    else
        echo "⚠️ No NVIDIA GPU found."
        return 1
    fi
}

# Function to get CUDA version
get_cuda_version() {
    if ! command -v nvidia-smi &> /dev/null; then
        echo "❌ CUDA is not installed. Installing CUDA 12..."
        install_cuda
        return
    fi

    CUDA_VERSION=$(nvidia-smi | grep -oP 'CUDA Version: \K[0-9]+\.[0-9]+')
    
    if [[ -z "$CUDA_VERSION" ]]; then
        echo "⚠️ CUDA version detection failed. Checking manually..."
        CUDA_VERSION=$(ls /usr/local/ | grep -oP 'cuda-\K[0-9]+')
    fi

    if [[ "$CUDA_VERSION" =~ ^11 ]]; then
        echo "🔄 CUDA 11 detected ($CUDA_VERSION). Upgrading to CUDA 12..."
        upgrade_cuda
    else
        echo "✅ CUDA $CUDA_VERSION detected. No upgrade needed."
    fi
}

# Function to install CUDA 12
install_cuda() {
    echo "📥 Installing CUDA 12..."
    wget -q https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/cuda-keyring_1.0-1_all.deb
    sudo dpkg -i cuda-keyring_1.0-1_all.deb
    sudo apt update -y
    sudo apt install -y cuda
    
    if command -v nvcc &> /dev/null; then
        CUDA_VERSION=$(nvcc --version | grep -oP 'release \K[0-9]+\.[0-9]+')
        echo "✅ CUDA installation successful! Installed version: $CUDA_VERSION"
    else
        echo "❌ Error: CUDA installation failed!"
        exit 1
    fi
}

# Function to upgrade CUDA 11 to CUDA 12
upgrade_cuda() {
    echo "❌ Removing CUDA 11..."
    sudo apt remove --purge -y nvidia-cuda-toolkit cuda-toolkit-11-*
    sudo apt autoremove -y
    echo "✅ CUDA 11 removed."
    install_cuda
}

# Function to set up CUDA environment variables
setup_cuda_env() {
    echo "🔧 Configuring CUDA environment variables..."
    CUDA_PATH="/usr/local/cuda"
    BASHRC="$HOME/.bashrc"
    echo "export LD_LIBRARY_PATH=${CUDA_PATH}/lib64:\$LD_LIBRARY_PATH" >> "$BASHRC"
    echo "export PATH=${CUDA_PATH}/bin:\$PATH" >> "$BASHRC"
    source "$BASHRC"
    echo "✅ CUDA environment configured!"
}

# Function to install GaiaNet
install_gaianet() {
    echo "📥 Installing GaiaNet node..."
    curl -sSfL 'https://github.com/GaiaNet-AI/gaianet-node/releases/latest/download/install.sh' | bash
    echo "✅ GaiaNet node installation successful!"
}

# Function to add GaiaNet binary to PATH
add_gaianet_to_path() {
    echo "🔗 Adding GaiaNet binary to PATH..."
    echo 'export PATH=$PATH:/opt/gaianet/' >> "$HOME/.bashrc"
    source "$HOME/.bashrc"
}

# Run checks and installations
if check_nvidia_gpu; then
    get_cuda_version
    setup_cuda_env
    install_gaianet
    add_gaianet_to_path
    echo "⚙️ Initializing GaiaNet node with CUDA..."
    gaianet init --config https://raw.githubusercontent.com/abhiag/Gaia_Node/main/config1.json
else
    install_gaianet
    add_gaianet_to_path
    echo "⚙️ Initializing GaiaNet node without CUDA..."
    gaianet init --config https://raw.githubusercontent.com/abhiag/Gaia_Node/main/config2.json
fi

# Start GaiaNet node
echo "🚀 Starting GaiaNet node..."
gaianet config --domain gaia.domains
gaianet start || { echo "❌ Error: Failed to start GaiaNet node!"; exit 1; }

echo "🔍 Fetching GaiaNet node information..."
gaianet info || { echo "❌ Error: Failed to fetch GaiaNet node information!"; exit 1; }

# Closing message
echo "==========================================================="
echo "🎉 Congratulations! Your GaiaNet node is successfully set up!"
echo "🌟 Stay connected: Telegram: https://t.me/GaCryptOfficial | Twitter: https://x.com/GACryptoO"
echo "💪 Together, let's build the future of decentralized networks!"
echo "==========================================================="
