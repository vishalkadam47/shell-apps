#!/bin/bash

# Shell Apps Manager Installer

echo "Installing Shell Apps Manager..."

# Create local bin directory if it doesn't exist
mkdir -p ~/.local/bin

# Download and install the manager script from GitHub
MANAGER_URL="https://raw.githubusercontent.com/vishalkadam47/shell-apps/main/manager.sh"

if command -v wget >/dev/null 2>&1; then
    wget -O ~/.local/bin/manager.sh "$MANAGER_URL"
elif command -v curl >/dev/null 2>&1; then
    curl -o ~/.local/bin/manager.sh "$MANAGER_URL"
else
    echo "Error: Neither wget nor curl found. Please install one of them."
    exit 1
fi

# Make it executable
chmod +x ~/.local/bin/manager.sh

# Add to PATH if not already there
if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
    echo "Added ~/.local/bin to PATH in ~/.bashrc"
    echo "Please run 'source ~/.bashrc' or restart your terminal"
fi

echo "Shell Apps Manager installed successfully!"
echo "Usage: manager.sh {install|launch|remove|update|list} [app_name]"