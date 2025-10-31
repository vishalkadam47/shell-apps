#!/bin/bash

# Chrome Operations Manager  
# Usage: app.sh {launch|remove|update}

APP_NAME="chrome"
BIN_PATH="/usr/bin/google-chrome"  # Chrome installs system-wide via .deb

case "$1" in        
    launch)
        exec "$BIN_PATH" "$@"
        ;;
        
    remove)
        echo "Removing Google Chrome..."
        if command -v apt-get >/dev/null 2>&1; then
            sudo apt-get remove -y google-chrome-stable
        elif command -v dpkg >/dev/null 2>&1; then
            sudo dpkg -r google-chrome-stable
        else
            echo "Error: Cannot remove Chrome. No package manager found."
            exit 1
        fi
        rm -f "$HOME/Desktop/google-chrome.desktop"
        echo "Google Chrome removed successfully!"
        ;;
        
    update)
        echo "Updating Google Chrome..."
        # Run the install script which handles updates
        bash "$(dirname "$0")/install.sh"
        echo "Google Chrome updated successfully!"
        ;;
        
    *)
        echo "Usage: $0 {launch|remove|update}"
        exit 1
        ;;
esac