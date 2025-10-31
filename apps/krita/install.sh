#!/bin/bash

echo "Installing Krita..."

# Create directories
mkdir -p ~/.local/share/applications
mkdir -p ~/.local/share/icons/hicolor/scalable/apps
mkdir -p ~/Desktop

# Download and install Krita AppImage
KRITA_URL="https://download.kde.org/stable/krita/5.2.6/krita-5.2.6-x86_64.appimage"
INSTALL_DIR="$HOME/.local/share/krita"

# Create install directory
mkdir -p "$INSTALL_DIR"

# Download Krita
echo "Downloading Krita..."
wget -O "$INSTALL_DIR/krita.appimage" "$KRITA_URL"

if [ $? -ne 0 ]; then
    echo "Failed to download Krita"
    exit 1
fi

# Make AppImage executable
chmod +x "$INSTALL_DIR/krita.appimage"

# Create wrapper script
cat > "$HOME/.local/bin/krita" << EOF
#!/bin/bash
exec "$INSTALL_DIR/krita.appimage" "\$@"
EOF

chmod +x "$HOME/.local/bin/krita"

# Create desktop entry
cat > ~/.local/share/applications/krita.desktop << EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=Krita
Comment=Digital Painting, Creative Freedom
Exec=$HOME/.local/bin/krita
Icon=krita
Terminal=false
Categories=Graphics;2DGraphics;RasterGraphics;
MimeType=application/x-krita;image/openraster;
EOF

# Create desktop shortcut
cp ~/.local/share/applications/krita.desktop ~/Desktop/
chmod +x ~/Desktop/krita.desktop

echo "✅ Krita installed successfully!"