#!/bin/bash

# setup_iterm2.sh - Native iTerm2 Catppuccin Mocha & JetBrains Mono Nerd Font setup
# Avoids third-party package managers (Homebrew); uses native macOS paths and standard tools.

set -euo pipefail

# Configuration
FONT_VERSION="v3.3.0"
FONT_URL="https://github.com/ryanoasis/nerd-fonts/releases/download/${FONT_VERSION}/JetBrainsMono.tar.xz"
THEME_URL="https://raw.githubusercontent.com/catppuccin/iterm/main/colors/catppuccin-mocha.itermcolors"
FONT_DIR="$HOME/Library/Fonts"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
THEME_FILE="$SCRIPT_DIR/catppuccin-mocha.itermcolors"

# Output formatting
print_status() {
    echo -e "\033[1;32m==>\033[0m $1"
}

print_error() {
    echo -e "\033[1;31mError:\033[0m $1"
}

# 1. OS Verification
if [[ "$(uname -s)" != "Darwin" ]]; then
    print_error "This script is designed specifically for macOS."
    exit 1
fi

print_status "Starting native iTerm2 configuration setup..."

# 2. Download Color Preset
print_status "Fetching Catppuccin Mocha color preset..."
curl -sSL "$THEME_URL" -o "$THEME_FILE"

# 3. Native Font Installation (JetBrains Mono Nerd Font)
print_status "Installing JetBrains Mono Nerd Font to $FONT_DIR..."
mkdir -p "$FONT_DIR"
TEMP_FONT_DIR=$(mktemp -d)

curl -sSL "$FONT_URL" -o "$TEMP_FONT_DIR/JetBrainsMono.tar.xz"
tar -xf "$TEMP_FONT_DIR/JetBrainsMono.tar.xz" -C "$TEMP_FONT_DIR"

# Copy only TTF fonts into the user Font library
cp "$TEMP_FONT_DIR"/*.ttf "$FONT_DIR/" 2>/dev/null || true
rm -rf "$TEMP_FONT_DIR"
print_status "Fonts installed successfully."

# 4. Trigger Color Preset Import
if [ -f "$THEME_FILE" ]; then
    print_status "Opening color preset with iTerm2 to trigger import..."
    open -a iTerm "$THEME_FILE" 2>/dev/null || open "$THEME_FILE"
fi

cat << 'EOF'

===================================================================
✨ Assets Installed! Complete the 4 GUI steps in iTerm2:
===================================================================
1. Set Colors:
   iTerm2 > Settings (Cmd + ,) > Profiles > Colors
   Select "Color Presets..." (bottom-right) > "catppuccin-mocha"

2. Set Font:
   iTerm2 > Settings > Profiles > Text
   Set Font to: "JetBrainsMono Nerd Font" (Size: 13pt or 14pt)

3. Set Minimalist Theme:
   iTerm2 > Settings > Appearance > General
   Set "Theme" to: "Minimal"

4. Window Padding & Clean Screen:
   - Settings > Profiles > Window > Columns/Rows Margins:
     Set Horizontal to 12, Vertical to 8
   - Settings > Profiles > Terminal:
     Uncheck "Show scrollbar"
===================================================================

EOF
