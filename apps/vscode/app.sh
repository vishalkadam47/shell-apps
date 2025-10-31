#!/bin/bash

# VSCode Operations Manager
# Usage: app.sh {launch|remove|update}

APP_NAME="vscode"
INSTALL_DIR="$HOME/.local/share/vscode"
BIN_PATH="$HOME/.local/bin/code"

case "$1" in        
    launch)
        "$BIN_PATH" "$@"
        ;;
        
    remove)
        echo "Removing Visual Studio Code..."
        rm -rf "$INSTALL_DIR"
        rm -f "$BIN_PATH"
        rm -f ~/.local/share/applications/vscode.desktop
        echo "Visual Studio Code removed successfully!"
        ;;
        
    update)
        echo "Updating Visual Studio Code..."
        # Remove old version
        $0 remove
        # Install new version using install.sh
        bash "$(dirname "$0")/install.sh"
        echo "Visual Studio Code updated successfully!"
        ;;
        
    *)
        echo "Usage: $0 {launch|remove|update}"
        echo "For installation, use install.sh"
        exit 1
        ;;
esac