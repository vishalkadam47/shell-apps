#!/bin/bash

# Default version - change this to update the default
VERSION="4.2.3"

echo "Installing Blender..."

# Set default version if not provided
if [[ -z "${VERSION:-}" ]]; then
  echo "Using default version: ${VERSION}"
  echo "To install a different version: VERSION=X.Y.Z ./install.sh"
fi

BLENDER_VERSION="$VERSION"

# Validate version format (e.g., 4.2.3, 3.6.13)
if ! [[ "$BLENDER_VERSION" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  echo "Error: VERSION must be in format X.Y.Z (e.g., 4.2.3)"
  exit 1
fi

# Create directories
mkdir -p ~/.local/share/applications
mkdir -p ~/.local/share/icons/hicolor/scalable/apps
mkdir -p ~/Desktop
mkdir -p ~/.local/bin

# Extract major.minor version for URL (e.g., 4.2.3 -> 4.2)
MAJOR_MINOR=$(echo "$BLENDER_VERSION" | cut -d. -f1,2)

# Construct download URL
BLENDER_URL="https://download.blender.org/release/Blender${MAJOR_MINOR}/blender-${BLENDER_VERSION}-linux-x64.tar.xz"
INSTALL_DIR="$HOME/.local/share/blender"

# Create install directory
mkdir -p "$INSTALL_DIR"

# Download Blender
echo "Downloading Blender ${BLENDER_VERSION}..."
wget -O /tmp/blender.tar.xz "$BLENDER_URL"

if [ $? -ne 0 ]; then
    echo "Failed to download Blender ${BLENDER_VERSION}"
    echo "Please check if the version exists at: https://download.blender.org/release/Blender${MAJOR_MINOR}/"
    exit 1
fi

# Extract Blender
echo "Extracting Blender..."
tar -xf /tmp/blender.tar.xz -C "$INSTALL_DIR" --strip-components=1

if [ $? -ne 0 ]; then
    echo "Failed to extract Blender"
    exit 1
fi

# Create symlink
ln -sf "$INSTALL_DIR/blender" "$HOME/.local/bin/blender"

# Create desktop entry
cat > ~/.local/share/applications/blender.desktop << EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=Blender ${BLENDER_VERSION}
Comment=3D modeling, animation, rendering and post-production
Exec=$HOME/.local/bin/blender
Icon=blender
Terminal=false
Categories=Graphics;3DGraphics;
MimeType=application/x-blender;
EOF

# Create desktop shortcut
cp ~/.local/share/applications/blender.desktop ~/Desktop/
chmod +x ~/Desktop/blender.desktop

# Clean up
rm -f /tmp/blender.tar.xz

echo "✅ Blender ${BLENDER_VERSION} installed successfully!"