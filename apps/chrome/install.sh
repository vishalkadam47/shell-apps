#!/bin/bash

echo "Installing Google Chrome..."

# Create directories
mkdir -p ~/.local/share/applications
mkdir -p ~/Desktop

# Install Chrome using package manager
echo "Installing Chrome via package manager..."

if command -v apt-get >/dev/null 2>&1; then
    # Ubuntu/Debian - use .deb package
    CHROME_URL="https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
    wget -O /tmp/google-chrome.deb "$CHROME_URL"
    sudo dpkg -i /tmp/google-chrome.deb
    sudo apt-get install -f -y
    rm -f /tmp/google-chrome.deb
elif command -v dnf >/dev/null 2>&1; then
    # Fedora - use RPM package
    CHROME_URL="https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm"
    wget -O /tmp/google-chrome.rpm "$CHROME_URL"
    sudo dnf install -y /tmp/google-chrome.rpm
    rm -f /tmp/google-chrome.rpm
elif command -v pacman >/dev/null 2>&1; then
    # Arch Linux - use AUR or manual install
    if command -v yay >/dev/null 2>&1; then
        yay -S --noconfirm google-chrome
    else
        echo "Installing Chrome manually on Arch..."
        CHROME_URL="https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm"
        wget -O /tmp/google-chrome.rpm "$CHROME_URL"
        # Convert RPM to tar and extract
        cd /tmp && rpm2cpio google-chrome.rpm | cpio -idmv
        sudo cp -r opt/google/chrome /opt/google/
        sudo ln -sf /opt/google/chrome/google-chrome /usr/bin/google-chrome
        rm -rf /tmp/google-chrome.rpm /tmp/opt
    fi
elif command -v zypper >/dev/null 2>&1; then
    # openSUSE - use RPM package
    CHROME_URL="https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm"
    wget -O /tmp/google-chrome.rpm "$CHROME_URL"
    sudo zypper install -y /tmp/google-chrome.rpm
    rm -f /tmp/google-chrome.rpm
else
    echo "Error: No supported package manager found."
    echo "Please install Google Chrome manually using your distribution's package manager."
    exit 1
fi

# Create desktop shortcut (Chrome creates its own .desktop file)
if [ -f "/usr/share/applications/google-chrome.desktop" ]; then
    cp /usr/share/applications/google-chrome.desktop ~/Desktop/
    chmod +x ~/Desktop/google-chrome.desktop
fi

echo "✅ Google Chrome installed successfully!"