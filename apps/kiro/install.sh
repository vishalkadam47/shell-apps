#!/usr/bin/env bash
set -euo pipefail

# ----------------------------
# Kiro Desktop Universal Installer
# Usage:
#   KIRO_VERSION=YYYYMMDDHHMM ./install-kiro.sh
# ----------------------------

# Default version - change this to update the default
VERSION="202510142329"

echo "Installing Kiro Desktop..."

BASE_URL="https://prod.download.desktop.kiro.dev"
RELEASES_PATH="releases"
BUILD_DIR_SUFFIX="--distro-linux-x64-tar-gz"
FILE_SUFFIX="-distro-linux-x64.tar.gz"

# Set default version if not provided
if [[ -z "${VERSION:-}" ]]; then
  echo "Using default version: ${VERSION}"
  echo "To install a different version: VERSION=YYYYMMDDHHMM ./install.sh"
fi

KIRO_VERSION="$VERSION"

# Validate format (must be 12 digits)
if ! [[ "$KIRO_VERSION" =~ ^[0-9]{12}$ ]]; then
  echo "Error: KIRO_VERSION must be a 12-digit timestamp (e.g. 202508150626)."
  exit 1
fi

# Create directories
mkdir -p ~/.local/share/applications
mkdir -p ~/.local/share/icons/hicolor/scalable/apps
mkdir -p ~/Desktop
mkdir -p ~/.local/bin

LATEST_BUILD_DIR="${KIRO_VERSION}${BUILD_DIR_SUFFIX}"
TAR_NAME="${KIRO_VERSION}${FILE_SUFFIX}"
TAR_URL="${BASE_URL}/${RELEASES_PATH}/${LATEST_BUILD_DIR}/${TAR_NAME}"
INSTALL_DIR="$HOME/.local/share/kiro"

# Create install directory
mkdir -p "$INSTALL_DIR"

echo "Downloading Kiro Desktop version ${KIRO_VERSION}..."
curl -fL --progress-bar -o "/tmp/${TAR_NAME}" "${TAR_URL}"

if [ $? -ne 0 ]; then
    echo "Failed to download Kiro Desktop"
    exit 1
fi

echo "Extracting Kiro Desktop..."
tar -xzf "/tmp/${TAR_NAME}" -C "$INSTALL_DIR" --strip-components=1

if [ $? -ne 0 ]; then
    echo "Failed to extract Kiro Desktop"
    exit 1
fi

# Create symlink
ln -sf "$INSTALL_DIR/kiro" "$HOME/.local/bin/kiro"

# Create desktop entry
cat > ~/.local/share/applications/kiro.desktop << EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=Kiro.dev
Comment=Kiro is an agentic IDE that helps you do your best work
Exec=$HOME/.local/bin/kiro
Icon=kiro
Terminal=false
Categories=Development;IDE;TextEditor;
MimeType=text/plain;inode/directory;
EOF

# Create desktop shortcut
cp ~/.local/share/applications/kiro.desktop ~/Desktop/
chmod +x ~/Desktop/kiro.desktop

# Clean up
rm -f "/tmp/${TAR_NAME}"

echo "✅ Kiro Desktop version ${KIRO_VERSION} installed successfully!"

