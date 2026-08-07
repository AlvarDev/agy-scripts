#!/bin/bash

# setup_nvim.sh - Automates installation & cleanup of Neovim + Catppuccin + Terraform config.
# Supports both macOS and Linux.

set -e

# Configuration variables
INSTALL_DIR="$HOME/.local/neovim"
CONFIG_DIR="$HOME/.config/nvim"
PACK_THEME_DIR="$HOME/.local/share/nvim/site/pack/themes/start"
PACK_PLUGIN_DIR="$HOME/.local/share/nvim/site/pack/plugins/start"
RAW_CONFIG_URL="https://raw.githubusercontent.com/AlvarDev/agy-scripts/main/neovim/nvim/init.lua"

# Determine OS and Architecture
OS="$(uname -s)"
ARCH="$(uname -m)"

# Helper function for printing in color
print_status() {
    echo -e "\033[1;32m==>\033[0m $1"
}

print_error() {
    echo -e "\033[1;31mError:\033[0m $1"
}

# --- INSTALLATION LOGIC ---
install_neovim() {
    print_status "Starting Neovim installation..."
    
    # 1. Download Neovim pre-compiled binary depending on OS
    if [ "$OS" = "Darwin" ]; then
        if [ "$ARCH" = "x86_64" ]; then
            URL="https://github.com/neovim/neovim/releases/download/v0.10.4/nvim-macos-x86_64.tar.gz"
        else
            # Apple Silicon M1/M2/M3
            URL="https://github.com/neovim/neovim/releases/download/v0.10.4/nvim-macos-arm64.tar.gz"
        fi
    elif [ "$OS" = "Linux" ]; then
        if [ "$ARCH" = "x86_64" ]; then
            URL="https://github.com/neovim/neovim/releases/download/v0.10.4/nvim-linux-x86_64.tar.gz"
        else
            print_error "Unsupported Linux architecture: $ARCH (Only x86_64 is supported for pre-compiled binaries)"
            exit 1
        fi
    else
        print_error "Unsupported OS: $OS"
        exit 1
    fi

    # Create destination directories
    mkdir -p "$HOME/.local/bin"
    mkdir -p "$INSTALL_DIR"

    # Download and extract Neovim if not already present
    if [ -f "$INSTALL_DIR/bin/nvim" ]; then
        print_status "Neovim binary already exists at $INSTALL_DIR. Skipping download."
    else
        print_status "Downloading pre-compiled Neovim from GitHub..."
        TEMP_TAR="/tmp/nvim-download.tar.gz"
        curl -L "$URL" -o "$TEMP_TAR"

        print_status "Extracting Neovim..."
        rm -rf "$INSTALL_DIR"
        mkdir -p "$INSTALL_DIR"
        tar -xzf "$TEMP_TAR" -C "$INSTALL_DIR" --strip-components=1
        rm -f "$TEMP_TAR"
    fi

    # Create symlink
    print_status "Creating symlink..."
    if [ "$OS" = "Darwin" ] && [ -w "/usr/local/bin" ]; then
        ln -sf "$INSTALL_DIR/bin/nvim" "/usr/local/bin/nvim"
        print_status "Symlink created at /usr/local/bin/nvim"
    else
        # Fallback for Linux or non-writable /usr/local/bin
        ln -sf "$INSTALL_DIR/bin/nvim" "$HOME/.local/bin/nvim"
        print_status "Symlink created at $HOME/.local/bin/nvim"
        
        # Check if ~/.local/bin is in PATH
        if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
            echo -e "\033[1;33mWarning:\033[0m $HOME/.local/bin is not in your PATH."
            echo "You may need to add this to your ~/.bashrc or ~/.zshrc file:"
            echo "export PATH=\$PATH:\$HOME/.local/bin"
        fi
    fi

    # 2. Set up Configuration directory
    print_status "Setting up configuration directory..."
    mkdir -p "$CONFIG_DIR"

    # 3. Download Catppuccin Theme Natively
    print_status "Downloading Catppuccin theme..."
    rm -rf "$PACK_THEME_DIR/catppuccin"
    mkdir -p "$PACK_THEME_DIR"
    git clone --depth 1 https://github.com/catppuccin/nvim.git "$PACK_THEME_DIR/catppuccin"

    # 4. Download Terraform syntax plugin Natively
    print_status "Downloading Terraform syntax plugin..."
    rm -rf "$PACK_PLUGIN_DIR/vim-terraform"
    mkdir -p "$PACK_PLUGIN_DIR"
    git clone --depth 1 https://github.com/hashivim/vim-terraform.git "$PACK_PLUGIN_DIR/vim-terraform"

    # 5. Write init.lua (Copy local file if present, otherwise download from GitHub)
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    if [ -f "$SCRIPT_DIR/nvim/init.lua" ]; then
        print_status "Copying local init.lua configuration..."
        cp "$SCRIPT_DIR/nvim/init.lua" "$CONFIG_DIR/init.lua"
    else
        print_status "Downloading init.lua configuration from GitHub..."
        curl -sfL "$RAW_CONFIG_URL" -o "$CONFIG_DIR/init.lua"
    fi

    print_status "Neovim installation and setup complete!"
}

# --- UNINSTALLATION LOGIC ---
uninstall_neovim() {
    print_status "Uninstalling Neovim and all configurations..."
    
    # Remove files and directories
    rm -rf "$CONFIG_DIR"
    rm -rf "$HOME/.local/share/nvim"
    rm -rf "$HOME/.local/state/nvim"
    rm -rf "$HOME/.cache/nvim"
    rm -rf "$INSTALL_DIR"
    
    # Remove symlinks
    rm -f "/usr/local/bin/nvim"
    rm -f "$HOME/.local/bin/nvim"

    print_status "Cleanup complete! Neovim has been completely removed from the system."
}

# --- MAIN MENU INTERFACE ---
show_menu() {
    clear
    echo "=========================================="
    echo "      NEOVIM SETUP AUTOMATION SCRIPT     "
    echo "=========================================="
    echo "1) Install Neovim & Config"
    echo "2) Uninstall & Clean Neovim Completely"
    echo "3) Exit"
    echo "=========================================="
    read -p "Choose an option [1-3]: " opt
    
    case $opt in
        1)
            install_neovim
            ;;
        2)
            uninstall_neovim
            ;;
        3)
            print_status "Exiting."
            exit 0
            ;;
        *)
            print_error "Invalid option."
            sleep 1
            show_menu
            ;;
    esac
}

show_menu
