#!/bin/bash

# Firefox Operations Manager  
# Usage: app.sh {launch|remove|update}

APP_NAME="firefox"
INSTALL_DIR="$HOME/.local/share/firefox"
BIN_PATH="$HOME/.local/bin/firefox"

case "$1" in        
    launch)
        "$BIN_PATH" "$@"
        ;;
        
    remove)
        echo "Removing Firefox..."
        rm -rf "$INSTALL_DIR"
        rm -f "$BIN_PATH"
        rm -f ~/.local/share/applications/firefox.desktop
        echo "Firefox removed successfully!"
        ;;
        
    update)
        echo "Updating Firefox..."
        # Remove old version
        $0 remove
        # Install new version using install.sh
        bash "$(dirname "$0")/install.sh"
        echo "Firefox updated successfully!"
        ;;
        
    *)
        echo "Usage: $0 {launch|remove|update}"
        echo "For installation, use install.sh"
        exit 1
        ;;
esac