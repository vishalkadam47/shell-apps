#!/bin/bash

echo "Installing Firefox..."

# Create directories
mkdir -p ~/.local/share/applications
mkdir -p ~/.local/share/icons/hicolor/scalable/apps
mkdir -p ~/Desktop

# Download and install Firefox
FIREFOX_URL="https://download.mozilla.org/?product=firefox-latest&os=linux64&lang=en-US"
INSTALL_DIR="$HOME/.local/share/firefox"

# Create install directory
mkdir -p "$INSTALL_DIR"

# Download Firefox
echo "Downloading Firefox..."
wget -O /tmp/firefox.tar.bz2 "$FIREFOX_URL"

# Extract Firefox
echo "Extracting Firefox..."
tar -xjf /tmp/firefox.tar.bz2 -C "$HOME/.local/share/"

# Create symlink
ln -sf "$INSTALL_DIR/firefox" "$HOME/.local/bin/firefox"

# Create desktop entry
cat > ~/.local/share/applications/firefox.desktop << EOF
[Desktop Entry]
Version=1.0
Name=Firefox
Comment=Web Browser
Exec=$HOME/.local/bin/firefox %u
Icon=firefox
Terminal=false
Type=Application
Categories=Network;WebBrowser;
MimeType=text/html;text/xml;application/xhtml+xml;application/xml;application/vnd.mozilla.xul+xml;application/rss+xml;application/rdf+xml;image/gif;image/jpeg;image/png;x-scheme-handler/http;x-scheme-handler/https;x-scheme-handler/ftp;x-scheme-handler/chrome;video/webm;application/x-xpinstall;
StartupNotify=true
EOF

# Copy to desktop
cp ~/.local/share/applications/firefox.desktop ~/Desktop/
chmod +x ~/Desktop/firefox.desktop

# Create icon (using a simple SVG)
cat > ~/.local/share/icons/hicolor/scalable/apps/firefox.svg << 'EOF'
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="#FF7139">
  <circle cx="12" cy="12" r="10"/>
  <path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2z" fill="#FF7139"/>
</svg>
EOF

# Clean up
rm -f /tmp/firefox.tar.bz2

echo "Firefox installed successfully!"