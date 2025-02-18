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

# Function to check if an NVIDIA GPU is present
check_nvidia_gpu() {
    if lspci | grep -i nvidia &> /dev/null; then
        echo "✅ NVIDIA GPU detected."
        return 0
    else
        echo "❌ No NVIDIA GPU found. CUDA installation is not required."
        exit 1
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

# Check for NVIDIA GPU before proceeding
check_nvidia_gpu

# If NVIDIA GPU is present, check if CUDA is installed
if ! get_cuda_version; then
    install_cuda
    get_cuda_version  # Recheck after installation
fi

# Determine which --ggmlcuda version to use
GGML_CUDA_VERSION=""
if [[ "$CUDA_VERSION" == 11* ]]; then
    GGML_CUDA_VERSION="11"
elif [[ "$CUDA_VERSION" == 12* ]]; then
    GGML_CUDA_VERSION="12"
else
    echo "⚠️ Unsupported CUDA version detected: $CUDA_VERSION. Defaulting to CUDA 12."
    GGML_CUDA_VERSION="12"
fi

echo "🔧 Using --ggmlcuda $GGML_CUDA_VERSION for GaiaNet installation."

# Set up CUDA environment variables
echo "🔧 Configuring CUDA environment variables..."

CUDA_PATH="/usr/local/cuda"
BASHRC="$HOME/.bashrc"
BASH_PROFILE="$HOME/.bash_profile"
ZSHRC="$HOME/.zshrc"
PROFILE="$HOME/.profile"

EXPORT_LD_LIBRARY_PATH="export LD_LIBRARY_PATH=${CUDA_PATH}/lib64:\$LD_LIBRARY_PATH"
EXPORT_PATH="export PATH=${CUDA_PATH}/bin:\$PATH"

# Function to add environment variables if not already set
add_to_shell_config() {
    local file="$1"
    if [ -f "$file" ]; then
        if ! grep -qxF "$EXPORT_LD_LIBRARY_PATH" "$file"; then
            echo "$EXPORT_LD_LIBRARY_PATH" >> "$file"
        fi
        if ! grep -qxF "$EXPORT_PATH" "$file"; then
            echo "$EXPORT_PATH" >> "$file"
        fi
    fi
}

# Add environment variables to common shell configuration files
add_to_shell_config "$BASHRC"
add_to_shell_config "$BASH_PROFILE"
add_to_shell_config "$ZSHRC"
add_to_shell_config "$PROFILE"

# Apply changes immediately without restart
export LD_LIBRARY_PATH=${CUDA_PATH}/lib64:$LD_LIBRARY_PATH
export PATH=${CUDA_PATH}/bin:$PATH
source ~/.bashrc

echo "✅ CUDA environment variables configured successfully and applied immediately!"

# Install required system packages
echo "📦 Installing Common Required Packages..."
sudo apt update -y && sudo apt-get install libgomp1 -y

# Install GaiaNet node with the correct CUDA version
echo "📥 Installing GaiaNet node with CUDA $GGML_CUDA_VERSION support..."
curl -sSfL 'https://github.com/GaiaNet-AI/gaianet-node/releases/latest/download/install.sh' | bash -s -- --ggmlcuda "$GGML_CUDA_VERSION"
status=$?

if [ $status -eq 0 ]; then
    echo "✅ GaiaNet node installation successful!"
else
    echo "❌ Error: GaiaNet node installation failed!"
    exit 1
fi

echo "Status: $status"

# Add GaiaNet to PATH
echo "🔗 Adding GaiaNet to system PATH..."
echo 'export PATH=$PATH:/opt/gaianet/' >> ~/.bashrc && source ~/.bashrc
status=$?
if [ $status -eq 0 ]; then
    echo "✅ GaiaNet added to PATH successfully!"
else
    echo "❌ Error: Failed to add GaiaNet to PATH!"
    exit 1
fi
echo "Status: $status"

# Add GaiaNet to PATH
echo "🔗 Adding GaiaNet to system PATH..."
echo 'export PATH=$PATH:/opt/gaianet/' >> ~/.bashrc && source ~/.bashrc
status=$?
if [ $status -eq 0 ]; then
    echo "✅ GaiaNet added to PATH successfully!"
else
    echo "❌ Error: Failed to add GaiaNet to PATH!"
    exit 1
fi
echo "Status: $status"

# Add GaiaNet to PATH
echo "🔗 Adding GaiaNet to system PATH..."
echo 'export PATH=$PATH:/opt/gaianet/' >> ~/.bashrc && source ~/.bashrc
status=$?
if [ $status -eq 0 ]; then
    echo "✅ GaiaNet added to PATH successfully!"
else
    echo "❌ Error: Failed to add GaiaNet to PATH!"
    exit 1
fi
echo "Status: $status"

# Add GaiaNet to PATH
echo "🔗 Adding GaiaNet to system PATH..."
echo 'export PATH=$PATH:/opt/gaianet/' >> ~/.bashrc && source ~/.bashrc
status=$?
if [ $status -eq 0 ]; then
    echo "✅ GaiaNet added to PATH successfully!"
else
    echo "❌ Error: Failed to add GaiaNet to PATH!"
    exit 1
fi
echo "Status: $status"

# Add GaiaNet to PATH
echo "🔗 Adding GaiaNet to system PATH..."
echo 'export PATH=$PATH:/opt/gaianet/' >> ~/.bashrc && source ~/.bashrc
status=$?
if [ $status -eq 0 ]; then
    echo "✅ GaiaNet added to PATH successfully!"
else
    echo "❌ Error: Failed to add GaiaNet to PATH!"
    exit 1
fi
echo "Status: $status"

# Initialize GaiaNet node with the specified configuration
echo "⚙️ Initializing GaiaNet node with the latest configuration..."
gaianet init --config https://raw.githubusercontent.com/abhiag/Gaia_Node/main/config1.json
status=$?

if [ $status -eq 0 ]; then
    echo "✅ GaiaNet node initialized successfully!"
else
    echo "❌ Error: Failed to initialize GaiaNet node!"
    echo "🔍 Checking if GaiaNet is in the PATH..."

    # Check if GaiaNet binary exists in /opt/gaianet/
    if [ -f "/opt/gaianet/gaianet" ]; then
        echo "✅ GaiaNet binary found in /opt/gaianet/. Adding it to PATH..."
        echo 'export PATH=$PATH:/opt/gaianet/' >> ~/.bashrc
        source ~/.bashrc

        echo "🔄 Retrying initialization..."
        gaianet init --config https://raw.githubusercontent.com/abhiag/Gaia_Node/main/config1.json
        retry_status=$?

        if [ $retry_status -eq 0 ]; then
            echo "✅ GaiaNet node initialized successfully on retry!"
        else
            echo "❌ Error: Initialization failed even after fixing PATH!"
            exit 1
        fi
    else
        echo "❌ GaiaNet binary not found in /opt/gaianet/!"
        echo "🚨 Please ensure GaiaNet is installed and accessible."
        exit 1
    fi
fi

echo "Status: $status"


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
