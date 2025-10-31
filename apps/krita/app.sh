#!/bin/bash

# Krita Operations Manager  
# Usage: app.sh {launch|remove|update}

APP_NAME="krita"
BIN_PATH="$HOME/.local/bin/krita"

case "$1" in        
    launch)
        exec "$BIN_PATH" "$@"
        ;;
        
    remove)
        echo "Removing Krita..."
        rm -rf "$HOME/.local/share/krita"
        rm -f "$HOME/.local/bin/krita"
        rm -f "$HOME/.local/share/applications/krita.desktop"
        rm -f "$HOME/Desktop/krita.desktop"
        echo "Krita removed successfully!"
        ;;
        
    update)
        echo "Updating Krita..."
        # Run the install script which handles updates
        bash "$(dirname "$0")/install.sh"
        echo "Krita updated successfully!"
        ;;
        
    *)
        echo "Usage: $0 {launch|remove|update}"
        exit 1
        ;;
esac