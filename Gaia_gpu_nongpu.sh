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

#!/bin/bash

# Ensure required packages are installed
echo "📦 Installing dependencies..."
sudo apt update -y && sudo apt install -y pciutils libgomp1

# Function to check if an NVIDIA GPU is present
check_nvidia_gpu() {
    if ! command -v nvidia-smi &> /dev/null; then
        echo "⚠️ nvidia-smi not found. Installing nvidia-utils..."
        sudo apt install -y nvidia-utils-535
    fi

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
        CUDA_VERSION=$(nvcc --version | grep -oP 'release \K[0-9]+\.[0-9]+')
        echo "✅ CUDA version $CUDA_VERSION is installed."
        return 0
    else
        echo "⚠️ CUDA is not installed."
        return 1
    fi
}

# Function to install CUDA toolkit
install_cuda_toolkit() {
    OS_VERSION=$(lsb_release -sr)
    if [[ "$OS_VERSION" != "20.04" && "$OS_VERSION" != "22.04" ]]; then
        echo "⚠️ Ubuntu $OS_VERSION is not officially supported by NVIDIA CUDA."
        echo "Please use Ubuntu 20.04 or 22.04, or install CUDA manually."
        exit 1
    fi

    echo "📥 Installing CUDA toolkit..."
    wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu${OS_VERSION}/x86_64/cuda-ubuntu${OS_VERSION}.pin
    sudo mv cuda-ubuntu${OS_VERSION}.pin /etc/apt/preferences.d/cuda-repository-pin-600
    sudo apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu${OS_VERSION}/x86_64/7fa2af80.pub
    sudo add-apt-repository "deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu${OS_VERSION}/x86_64/ /"
    sudo apt-get update
    sudo apt install -y cuda-toolkit
    echo "✅ CUDA toolkit installation successful!"

    # Set up CUDA environment variables
    echo "🔧 Setting up CUDA environment variables..."
    echo 'export PATH=/usr/local/cuda/bin:$PATH' >> ~/.bashrc
    echo 'export LD_LIBRARY_PATH=/usr/local/cuda/lib64:$LD_LIBRARY_PATH' >> ~/.bashrc
    source ~/.bashrc
    echo "✅ CUDA environment variables configured."
}

# Function to install GaiaNet
install_gaianet() {
    echo "📥 Installing GaiaNet node..."
    curl -sSfL 'https://github.com/GaiaNet-AI/gaianet-node/releases/latest/download/install.sh' | bash || { echo "❌ GaiaNet installation failed!"; exit 1; }
    echo "✅ GaiaNet node installation successful!"
}

# Function to add GaiaNet binary to PATH
add_gaianet_to_path() {
    if [[ -d "/opt/gaianet/" ]]; then
        echo "🔗 Adding GaiaNet binary to PATH..."
        if [[ ":$PATH:" != *":/opt/gaianet/:"* ]]; then
            echo 'export PATH=$PATH:/opt/gaianet/' >> "$HOME/.bashrc"
            source "$HOME/.bashrc"
        fi
    else
        echo "⚠️ GaiaNet binary directory not found!"
    fi
}

# Run checks and installations
if check_nvidia_gpu; then
    if ! get_cuda_version; then
        install_cuda_toolkit
    fi
    install_gaianet
    add_gaianet_to_path
    echo "⚙️ Initializing GaiaNet node with CUDA..."
    if curl --output /dev/null --silent --head --fail "https://raw.githubusercontent.com/abhiag/Gaia_Node/main/config1.json"; then
        gaianet init --config https://raw.githubusercontent.com/abhiag/Gaia_Node/main/config1.json || { echo "❌ GaiaNet initialization failed!"; exit 1; }
    else
        echo "❌ Configuration file not found!"
        exit 1
    fi
else
    install_gaianet
    add_gaianet_to_path
    echo "⚙️ Initializing GaiaNet node without CUDA..."
    if curl --output /dev/null --silent --head --fail "https://raw.githubusercontent.com/abhiag/Gaia_Node/main/config2.json"; then
        gaianet init --config https://raw.githubusercontent.com/abhiag/Gaia_Node/main/config2.json || { echo "❌ GaiaNet initialization failed!"; exit 1; }
    else
        echo "❌ Configuration file not found!"
        exit 1
    fi
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
