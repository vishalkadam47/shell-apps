#!/bin/bash

# Blender Operations Manager  
# Usage: app.sh {launch|remove|update}

APP_NAME="blender"
BIN_PATH="$HOME/.local/bin/blender"

case "$1" in        
    launch)
        exec "$BIN_PATH" "$@"
        ;;
        
    remove)
        echo "Removing Blender..."
        rm -rf "$HOME/.local/share/blender"
        rm -f "$HOME/.local/bin/blender"
        rm -f "$HOME/.local/share/applications/blender.desktop"
        rm -f "$HOME/Desktop/blender.desktop"
        echo "Blender removed successfully!"
        ;;
        
    update)
        echo "Updating Blender..."
        echo "Note: Update requires BLENDER_VERSION environment variable"
        echo "Usage: BLENDER_VERSION=4.2.3 manager.sh update blender"
        
        if [[ -z "${BLENDER_VERSION:-}" ]]; then
            echo "Error: BLENDER_VERSION not set. Cannot update."
            echo "Please set BLENDER_VERSION and try again."
            exit 1
        fi
        
        # Run the install script which handles updates
        bash "$(dirname "$0")/install.sh"
        echo "Blender updated successfully!"
        ;;
        
    *)
        echo "Usage: $0 {launch|remove|update}"
        exit 1
        ;;
esac