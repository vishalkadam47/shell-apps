# Shell Apps

A simple shell-based application manager that allows you to install, launch, update, and remove applications using shell scripts.

## Features

- **Direct Installation**: Apps install directly to your system
- **Fast Startup**: No overhead from virtualization
- **Simple Management**: Easy-to-understand shell scripts
- **Web Interface**: Compatible with dashboard interfaces
- **Customizable**: Easy to add new applications

## Quick Start

### Installation

Download and run the installation script:

```bash
# Download the install script
curl -O https://raw.githubusercontent.com/vishalkadam47/shell-apps/main/install-manager.sh
# Or 
wget -O install-manager.sh https://raw.githubusercontent.com/vishalkadam47/shell-apps/main/install-manager.sh

# Run the installer
bash install-manager.sh
```

This downloads and installs the manager to `~/.local/bin/manager.sh`

### Usage

After installation, you can use the manager from anywhere:

```bash
# List available apps
manager.sh list

# Install an app
manager.sh install firefox

# Launch an app (with optional arguments)
manager.sh launch firefox
manager.sh launch firefox --private-window

# Update an app
manager.sh update firefox

# Remove an app
manager.sh remove firefox
```

**Note**: Make sure `~/.local/bin` is in your PATH, or restart your terminal after installation.

## Repository Structure

```
shell-apps/
├── metadata/
│   └── metadata.yml          # App definitions for web interface
├── apps/
│   └── {app-name}/
│       ├── install.sh        # Installation script
│       ├── app.sh           # Launch/management script
│       └── icon.svg         # App icon
├── scripts/
│   ├── local-server.js      # Development server
│   └── README.md            # Scripts documentation
├── manager.sh               # Main management script
├── install-manager.sh       # Bootstrap installer
└── README.md               # This file
```

## How It Works

1. **Bootstrap**: `install-manager.sh` downloads `manager.sh` to `~/.local/bin/`
2. **Metadata Check**: Manager fetches app list from `metadata/metadata.yml` on GitHub
3. **Script Download**: When installing/launching apps, manager downloads `install.sh` and `app.sh` from GitHub
4. **Local Cache**: Downloaded scripts are cached in `~/.local/share/shell-apps/apps/{app-name}/`
5. **Direct Execution**: Apps install and run directly on your system using the downloaded scripts

## Web Interface Integration

This system works with dashboard interfaces via `postMessage`:

```javascript
// Install an app from web interface
window.postMessage({ 
    type: 'command', 
    value: 'bash ~/.local/bin/manager.sh install firefox' 
}, window.location.origin);
```

The React component fetches app metadata from:
- **Metadata**: `https://raw.githubusercontent.com/vishalkadam47/shell-apps/main/metadata/metadata.yml`
- **Icons**: `https://raw.githubusercontent.com/vishalkadam47/shell-apps/main/apps/{app-name}/icon.svg`

## Available Apps

- **Blender** - 3D creation suite
- **Chrome** - Google Chrome web browser
- **Firefox** - Mozilla Firefox web browser
- **Kiro** - AI-powered IDE and development environment
- **Krita** - Digital painting application
- **VLC** - Media player
- **Visual Studio Code** - Code editor from Microsoft

## Adding New Apps

1. Create app directory: `apps/myapp/`
2. Create required files:
   - `install.sh` - Downloads and installs the app
   - `app.sh` - Handles launch, remove, and update operations
   - `icon.svg` (or `icon.png`) - App icon
3. Add app to `metadata/metadata.yml`
4. Commit and push to the repository

### Example App Scripts

```bash
# apps/myapp/install.sh
#!/bin/bash
echo "Installing MyApp..."
mkdir -p ~/.local/bin
wget -O ~/.local/bin/myapp "https://example.com/myapp"
chmod +x ~/.local/bin/myapp
echo "MyApp installed successfully!"

# apps/myapp/app.sh
#!/bin/bash
case "$1" in
    launch)
        if [ -f "$HOME/.local/bin/myapp" ]; then
            "$HOME/.local/bin/myapp" "${@:2}"
        else
            echo "MyApp not found. Please install it first."
            exit 1
        fi
        ;;
    remove)
        echo "Removing MyApp..."
        rm -f ~/.local/bin/myapp
        echo "MyApp removed successfully!"
        ;;
    update)
        echo "Updating MyApp..."
        # Re-run install script or custom update logic
        bash "$(dirname "$0")/install.sh"
        ;;
    *)
        echo "Usage: $0 {launch|remove|update}"
        exit 1
        ;;
esac
```

## Deployment

This repository serves files directly from GitHub:

- **Source**: GitHub repository
- **Access**: Direct file access via GitHub raw URLs
- **Updates**: Automatic when pushing to main branch

## Requirements

- **System**: Linux/macOS with Bash
- **Tools**: curl or wget, tar, standard Unix utilities
- **Network**: Internet connection for downloads

## Benefits

- ✅ **Fast startup** - Direct system execution
- ✅ **Low resource usage** - Native system installation
- ✅ **Native integration** - Apps work like system installs
- ✅ **Simple management** - Standard shell scripts
- ✅ **Easy distribution** - Direct GitHub hosting

## License

This project is open source and available under the MIT License.