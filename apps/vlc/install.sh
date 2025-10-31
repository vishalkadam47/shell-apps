#!/bin/bash

echo "Installing VLC Media Player..."

# Create directories
mkdir -p ~/.local/share/applications
mkdir -p ~/Desktop

# Install VLC using package manager
echo "Installing VLC via package manager..."

if command -v apt-get >/dev/null 2>&1; then
    # Ubuntu/Debian
    sudo apt-get update
    sudo apt-get install -y vlc
elif command -v dnf >/dev/null 2>&1; then
    # Fedora
    sudo dnf install -y vlc
elif command -v pacman >/dev/null 2>&1; then
    # Arch Linux
    sudo pacman -S --noconfirm vlc
elif command -v zypper >/dev/null 2>&1; then
    # openSUSE
    sudo zypper install -y vlc
else
    echo "Error: No supported package manager found."
    echo "Please install VLC manually using your distribution's package manager."
    exit 1
fi

if [ $? -ne 0 ]; then
    echo "Failed to install VLC"
    exit 1
fi

# Create desktop shortcut (VLC creates its own .desktop file)
if [ -f "/usr/share/applications/vlc.desktop" ]; then
    cp /usr/share/applications/vlc.desktop ~/Desktop/
    chmod +x ~/Desktop/vlc.desktop
fi

echo "✅ VLC Media Player installed successfully!"