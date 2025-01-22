#!/bin/bash

# Prompt the user for the identifier
read -p "Enter your identifier (XXXXXXXX): " identifier

# Prompt the user for the PIN
read -p "Enter your PIN (XXXXXX): " pin

# Print the values for debugging
echo "Identifier: $identifier"
echo "PIN: $pin"

# Debug: Check if the multiple-cli command exists
if ! command -v multiple-cli &> /dev/null; then
    echo "Error: multiple-cli command not found!"
    exit 1
fi

# Execute the bind command with the provided inputs
echo "Executing: multiple-cli bind --bandwidth-download 100000 --identifier $identifier --pin $pin --storage 100000000 --bandwidth-upload 100000"
multiple-cli bind --bandwidth-download 100000 --identifier "$identifier" --pin "$pin" --storage 100000000 --bandwidth-upload 100000
