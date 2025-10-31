#!/bin/bash

# Kiro Operations Manager  
# Usage: app.sh {launch|remove|update}

APP_NAME="kiro"
BIN_PATH="$HOME/.local/bin/kiro"  # Kiro installs to user directory via tar.gz

case "$1" in        
    launch)
        exec "$BIN_PATH" "$@"
        ;;
        
    remove)
        echo "Removing Kiro Desktop..."
        rm -rf "$HOME/.local/share/kiro"
        rm -f "$HOME/.local/bin/kiro"
        rm -f "$HOME/.local/share/applications/kiro.desktop"
        rm -f "$HOME/Desktop/kiro.desktop"
        echo "Kiro Desktop removed successfully!"
        ;;
        
    update)
        echo "Updating Kiro Desktop..."
        echo "Note: Update requires KIRO_VERSION environment variable"
        echo "Usage: KIRO_VERSION=YYYYMMDDHHMM manager.sh update kiro"
        
        if [[ -z "${KIRO_VERSION:-}" ]]; then
            echo "Error: KIRO_VERSION not set. Cannot update."
            echo "Please set KIRO_VERSION and try again."
            exit 1
        fi
        
        # Run the install script which handles updates
        bash "$(dirname "$0")/install.sh"
        echo "Kiro Desktop updated successfully!"
        ;;
        
    *)
        echo "Usage: $0 {launch|remove|update}"
        echo "For installation, use install.sh with KIRO_VERSION"
        exit 1
        ;;
esac