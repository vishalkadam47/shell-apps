#!/bin/bash

echo "Installing Visual Studio Code..."

# Create directories
mkdir -p ~/.local/share/applications
mkdir -p ~/.local/share/icons/hicolor/scalable/apps
mkdir -p ~/Desktop
mkdir -p ~/.local/bin

# Download and install VSCode
VSCODE_URL="https://code.visualstudio.com/sha/download?build=stable&os=linux-x64"
INSTALL_DIR="$HOME/.local/share/vscode"

# Create install directory
mkdir -p "$INSTALL_DIR"

# Download VSCode
echo "Downloading Visual Studio Code..."
wget -O /tmp/vscode.tar.gz "$VSCODE_URL"

# Extract VSCode
echo "Extracting Visual Studio Code..."
tar -xzf /tmp/vscode.tar.gz -C "$HOME/.local/share/"
mv "$HOME/.local/share/VSCode-linux-x64" "$INSTALL_DIR"

# Create symlink
ln -sf "$INSTALL_DIR/bin/code" "$HOME/.local/bin/code"

# Create desktop entry
cat > ~/.local/share/applications/vscode.desktop << EOF
[Desktop Entry]
Name=Visual Studio Code
Comment=Code Editing. Redefined.
GenericName=Text Editor
Exec=$HOME/.local/bin/code --unity-launch %F
Icon=vscode
Type=Application
StartupNotify=false
StartupWMClass=Code
Categories=TextEditor;Development;IDE;
MimeType=text/plain;inode/directory;application/x-vscode-workspace;
Actions=new-empty-window;
Keywords=vscode;

[Desktop Action new-empty-window]
Name=New Empty Window
Exec=$HOME/.local/bin/code --new-window %F
Icon=vscode
EOF

# Copy to desktop
cp ~/.local/share/applications/vscode.desktop ~/Desktop/
chmod +x ~/Desktop/vscode.desktop

# Create icon (using a simple SVG)
cat > ~/.local/share/icons/hicolor/scalable/apps/vscode.svg << 'EOF'
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="#007ACC">
  <path d="M23.15 2.587L18.21.21a1.494 1.494 0 0 0-1.705.29l-9.46 8.63-4.12-3.128a.999.999 0 0 0-1.276.057L.327 7.261A1 1 0 0 0 .326 8.74L3.899 12 .326 15.26a1 1 0 0 0 .001 1.479L1.65 17.94a.999.999 0 0 0 1.276.057l4.12-3.128 9.46 8.63a1.492 1.492 0 0 0 1.704.29l4.942-2.377A1.5 1.5 0 0 0 24 20.06V3.939a1.5 1.5 0 0 0-.85-1.352zm-5.146 14.861L10.826 12l7.178-5.448v10.896z"/>
</svg>
EOF

# Clean up
rm -f /tmp/vscode.tar.gz

echo "Visual Studio Code installed successfully!"