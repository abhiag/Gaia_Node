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
