#!/bin/bash

# Shell Apps Manager
# A simple shell-based application manager

GITHUB_BASE_URL="https://raw.githubusercontent.com/vishalkadam47/shell-apps/main"
INSTALL_DIR="$HOME/.local/share/shell-apps"
APPS_DIR="$INSTALL_DIR/apps"
METADATA_URL="$GITHUB_BASE_URL/metadata/metadata.yml"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

# Function to get app metadata
get_app_metadata() {
    local app_name="$1"
    local temp_metadata="/tmp/shell-apps-metadata.yml"
    
    if command -v wget >/dev/null 2>&1; then
        wget -q -O "$temp_metadata" "$METADATA_URL" 2>/dev/null
    elif command -v curl >/dev/null 2>&1; then
        curl -s -o "$temp_metadata" "$METADATA_URL" 2>/dev/null
    else
        print_error "Neither wget nor curl found"
        return 1
    fi
    
    if [ -f "$temp_metadata" ] && [ -s "$temp_metadata" ]; then
        # Extract app metadata (simple approach)
        awk "/- name: $app_name$/,/^  - name:|^$/" "$temp_metadata" | grep -E "^\s+[a-z_]+:" | sed 's/^\s*//'
        rm -f "$temp_metadata"
        return 0
    else
        print_error "Failed to download metadata"
        return 1
    fi
}

# Function to download app scripts (install.sh and app.sh)
download_app_scripts() {
    local app_name="$1"
    local app_dir="$APPS_DIR/$app_name"
    
    mkdir -p "$app_dir"
    
    # Download install.sh and app.sh
    for script in install.sh app.sh; do
        local script_url="$GITHUB_BASE_URL/apps/$app_name/$script"
        local script_path="$app_dir/$script"
        
        if command -v wget >/dev/null 2>&1; then
            wget -q -O "$script_path" "$script_url" 2>/dev/null
        elif command -v curl >/dev/null 2>&1; then
            curl -s -o "$script_path" "$script_url" 2>/dev/null
        else
            print_error "Neither wget nor curl found"
            return 1
        fi
        
        # Make script executable if download succeeded
        if [ -f "$script_path" ] && [ -s "$script_path" ]; then
            chmod +x "$script_path"
        fi
    done
    
    return 0
}

# Function to get available apps from metadata
get_available_apps() {
    local temp_metadata="/tmp/shell-apps-metadata.yml"
    
    if command -v wget >/dev/null 2>&1; then
        wget -q -O "$temp_metadata" "$METADATA_URL" 2>/dev/null
    elif command -v curl >/dev/null 2>&1; then
        curl -s -o "$temp_metadata" "$METADATA_URL" 2>/dev/null
    else
        print_error "Neither wget nor curl found"
        return 1
    fi
    
    if [ -f "$temp_metadata" ] && [ -s "$temp_metadata" ]; then
        # Extract app names from YAML (simple grep approach)
        grep "^  - name:" "$temp_metadata" | sed 's/^  - name: //' | tr -d '"'
        rm -f "$temp_metadata"
        return 0
    else
        print_error "Failed to download metadata"
        return 1
    fi
}

# Function to check if app exists in metadata
app_exists() {
    local app_name="$1"
    local available_apps
    available_apps=$(get_available_apps)
    
    if echo "$available_apps" | grep -q "^$app_name$"; then
        return 0
    else
        return 1
    fi
}

# Function to install an app
install_app() {
    local app_name="$1"
    
    if ! app_exists "$app_name"; then
        print_error "App '$app_name' not found"
        return 1
    fi
    
    print_status "Downloading $app_name scripts..."
    if ! download_app_scripts "$app_name"; then
        print_error "Failed to download scripts for '$app_name'"
        return 1
    fi
    
    local install_script="$APPS_DIR/$app_name/install.sh"
    
    if [ ! -f "$install_script" ]; then
        print_error "Install script not found for '$app_name'"
        return 1
    fi
    
    print_status "Installing $app_name..."
    
    # Optional version handling - apps will use defaults if not specified
    if [ "$app_name" = "kiro" ] && [[ -n "${KIRO_VERSION:-}" ]]; then
        print_status "Installing Kiro with version: $KIRO_VERSION"
    elif [ "$app_name" = "kiro" ]; then
        print_status "Installing Kiro with default version"
    fi
    
    if [ "$app_name" = "blender" ] && [[ -n "${BLENDER_VERSION:-}" ]]; then
        print_status "Installing Blender with version: $BLENDER_VERSION"
    elif [ "$app_name" = "blender" ]; then
        print_status "Installing Blender with default version"
    fi
    
    bash "$install_script"
    
    if [ $? -eq 0 ]; then
        print_status "$app_name installed successfully!"
        return 0
    else
        print_error "Failed to install $app_name"
        return 1
    fi
}

# Function to launch an app
launch_app() {
    local app_name="$1"
    shift # Remove app_name from arguments, pass the rest to the app
    
    local app_script="$APPS_DIR/$app_name/app.sh"
    
    # Download scripts if not present locally
    if [ ! -f "$app_script" ]; then
        print_status "Downloading $app_name scripts..."
        if ! download_app_scripts "$app_name"; then
            print_error "Failed to download scripts for '$app_name'"
            return 1
        fi
    fi
    
    if [ ! -f "$app_script" ]; then
        print_error "App script not found for '$app_name'"
        return 1
    fi
    
    bash "$app_script" launch "$@"
}

# Function to remove an app
remove_app() {
    local app_name="$1"
    local app_script="$APPS_DIR/$app_name/app.sh"
    
    # Download scripts if not present locally
    if [ ! -f "$app_script" ]; then
        print_status "Downloading $app_name scripts..."
        if ! download_app_scripts "$app_name"; then
            print_error "Failed to download scripts for '$app_name'"
            return 1
        fi
    fi
    
    if [ ! -f "$app_script" ]; then
        print_error "App script not found for '$app_name'"
        return 1
    fi
    
    print_status "Removing $app_name..."
    bash "$app_script" remove
    
    if [ $? -eq 0 ]; then
        print_status "$app_name removed successfully!"
        # Clean up downloaded scripts
        rm -rf "$APPS_DIR/$app_name"
        return 0
    else
        print_error "Failed to remove $app_name"
        return 1
    fi
}

# Function to update an app
update_app() {
    local app_name="$1"
    
    if ! app_exists "$app_name"; then
        print_error "App '$app_name' not found"
        return 1
    fi
    
    # Always download fresh scripts for update
    print_status "Downloading latest $app_name scripts..."
    if ! download_app_scripts "$app_name"; then
        print_error "Failed to download scripts for '$app_name'"
        return 1
    fi
    
    local app_script="$APPS_DIR/$app_name/app.sh"
    
    if [ ! -f "$app_script" ]; then
        print_error "App script not found for '$app_name'"
        return 1
    fi
    
    print_status "Updating $app_name..."
    bash "$app_script" update
    
    if [ $? -eq 0 ]; then
        print_status "$app_name updated successfully!"
        return 0
    else
        print_error "Failed to update $app_name"
        return 1
    fi
}

# Function to list available apps
list_apps() {
    print_status "Available apps:"
    local available_apps
    available_apps=$(get_available_apps)
    
    if [ $? -eq 0 ] && [ -n "$available_apps" ]; then
        echo "$available_apps" | while read -r app; do
            echo "  - $app"
        done
    else
        print_error "Failed to get app list"
        return 1
    fi
}

# Main script logic
case "$1" in
    install)
        if [ -z "$2" ]; then
            print_error "Usage: $0 install <app_name>"
            exit 1
        fi
        install_app "$2"
        ;;
    launch)
        if [ -z "$2" ]; then
            print_error "Usage: $0 launch <app_name> [args...]"
            exit 1
        fi
        launch_app "$2" "${@:3}"
        ;;
    remove)
        if [ -z "$2" ]; then
            print_error "Usage: $0 remove <app_name>"
            exit 1
        fi
        remove_app "$2"
        ;;
    update)
        if [ -z "$2" ]; then
            print_error "Usage: $0 update <app_name>"
            exit 1
        fi
        update_app "$2"
        ;;
    list)
        list_apps
        ;;
    *)
        echo "Shell Apps Manager"
        echo "Usage: $0 {install|launch|remove|update|list} [app_name] [args...]"
        echo ""
        echo "Commands:"
        echo "  install <app_name>    Install an application"
        echo "  launch <app_name>     Launch an application"
        echo "  remove <app_name>     Remove an application"
        echo "  update <app_name>     Update an application"
        echo "  list                  List available applications"
        exit 1
        ;;
esac