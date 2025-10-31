#!/bin/bash

# VLC Operations Manager  
# Usage: app.sh {launch|remove|update}

APP_NAME="vlc"
BIN_PATH="/usr/bin/vlc"  # VLC installs system-wide via package manager

case "$1" in        
    launch)
        exec "$BIN_PATH" "$@"
        ;;
        
    remove)
        echo "Removing VLC Media Player..."
        if command -v apt-get >/dev/null 2>&1; then
            sudo apt-get remove -y vlc
        elif command -v dnf >/dev/null 2>&1; then
            sudo dnf remove -y vlc
        elif command -v pacman >/dev/null 2>&1; then
            sudo pacman -R --noconfirm vlc
        elif command -v zypper >/dev/null 2>&1; then
            sudo zypper remove -y vlc
        else
            echo "Error: Cannot remove VLC. No supported package manager found."
            exit 1
        fi
        rm -f "$HOME/Desktop/vlc.desktop"
        echo "VLC Media Player removed successfully!"
        ;;
        
    update)
        echo "Updating VLC Media Player..."
        if command -v apt-get >/dev/null 2>&1; then
            sudo apt-get update && sudo apt-get upgrade -y vlc
        elif command -v dnf >/dev/null 2>&1; then
            sudo dnf upgrade -y vlc
        elif command -v pacman >/dev/null 2>&1; then
            sudo pacman -Syu --noconfirm vlc
        elif command -v zypper >/dev/null 2>&1; then
            sudo zypper update -y vlc
        else
            echo "Error: Cannot update VLC. No supported package manager found."
            exit 1
        fi
        echo "VLC Media Player updated successfully!"
        ;;
        
    *)
        echo "Usage: $0 {launch|remove|update}"
        exit 1
        ;;
esac