#!/bin/bash

# Prompt the user for the identifier
read -p "Enter your identifier: " identifier

# Prompt the user for the PIN
read -p "Enter your PIN: " pin

# Execute the bind command with the user inputs
./multiple-cli bind --bandwidth-download 100000 --identifier "$identifier" --pin "$pin" --storage 200000000 --bandwidth-upload 100000
