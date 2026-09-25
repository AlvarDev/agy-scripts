#!/bin/bash

# setup_iterm2.sh - Native iTerm2 Material Ocean & AlvarDev Profile Setup
# Avoids third-party package managers (Homebrew); uses native macOS Monaco font and built-in tools.

set -euo pipefail

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
THEME_FILE="$SCRIPT_DIR/material-ocean.itermcolors"
BANNER_FILE="$SCRIPT_DIR/welcome_banner.txt"
ZSHRC_FILE="$HOME/.zshrc"
USER_BANNER="$HOME/.welcome_banner.txt"

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

print_status "Starting native iTerm2 AlvarDev configuration setup..."

# 2. Trigger Color Preset Import
if [ -f "$THEME_FILE" ]; then
    print_status "Importing Material Ocean color preset into iTerm2..."
    open -a iTerm "$THEME_FILE" 2>/dev/null || open "$THEME_FILE"
else
    print_error "Preset file not found at $THEME_FILE"
    exit 1
fi

# 3. Install Welcome Screen Banner
if [ -f "$BANNER_FILE" ]; then
    print_status "Installing welcome banner to $USER_BANNER..."
    cp "$BANNER_FILE" "$USER_BANNER"
fi

# 4. Configure Native Zero-Dependency Zsh Environment (if not already set)
if [ -f "$ZSHRC_FILE" ]; then
    if grep -q "Pure Native Zsh Git Prompt" "$ZSHRC_FILE"; then
        print_status "Native Zsh Git prompt is already configured in $ZSHRC_FILE."
    else
        print_status "Adding zero-dependency native Zsh Git prompt to $ZSHRC_FILE..."
        cat >> "$ZSHRC_FILE" << 'ZSH_EOF'

# --- Pure Native Zsh Git Prompt (Zero Dependencies) ---
autoload -Uz compinit && compinit
autoload -Uz vcs_info

zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' unstagedstr ' %F{yellow}✗%f'
zstyle ':vcs_info:git:*' stagedstr ' %F{green}+%f'
zstyle ':vcs_info:git:*' formats '%F{blue}git:(%F{red}%b%F{blue})%f%u%c '
zstyle ':vcs_info:git:*' actionformats '%F{blue}git:(%F{red}%b%F{blue}|%F{yellow}%a%F{blue})%f%u%c '

# Detect untracked files in git dirty check
+vi-git-untracked() {
    if [[ $(git rev-parse --is-inside-work-tree 2>/dev/null) == "true" ]] && \
       git status --porcelain 2>/dev/null | grep -q "^??"; then
        hook_com[unstaged]+=" %F{yellow}✗%f"
    fi
}
zstyle ':vcs_info:git*+set-message:*' hooks git-untracked

precmd() {
    vcs_info
}

setopt PROMPT_SUBST
PROMPT='%(?.%B%F{green}➜%f%b.%B%F{red}➜%f%b)  %B%F{cyan}%c%f%b ${vcs_info_msg_0_}'

# Native git aliases
alias gst="git status"
alias gco="git checkout"
alias gp="git push"
alias gaa="git add --all"

# Welcome Screen
echo "Welcome AlvarDev"
if [ -f "$HOME/.welcome_banner.txt" ]; then
    cat "$HOME/.welcome_banner.txt"
fi
ZSH_EOF
        print_status "Native Zsh Git prompt added successfully."
    fi
fi

cat << 'EOF'

===================================================================
✨ Assets Configured! Complete the 5 GUI steps in iTerm2:
===================================================================
1. Set Colors:
   iTerm2 > Settings (Cmd + ,) > Profiles > Colors
   Select "Color Presets..." (bottom-right) > "material-ocean"

2. Set Font:
   iTerm2 > Settings > Profiles > Text
   Set Font to native: "Monaco" (Size: 12pt)
   Check "Use thin strokes for anti-aliased text: Only on Retina Displays"

3. Set Minimalist Theme:
   iTerm2 > Settings > Appearance > General
   Set "Theme" to: "Minimal"

4. Window Padding & Scrollback Buffer:
   - Settings > Profiles > Window > Columns/Rows Margins:
     Set Horizontal to 12, Vertical to 8
   - Settings > Profiles > Terminal:
     Uncheck "Show scrollbar", set Scrollback lines to 10000

5. Natural Word Navigation:
   - Settings > Profiles > Keys > Key Mappings > Presets...
     Select "Natural Text Editing" (enables Option+Left/Right word hops)
===================================================================

EOF
