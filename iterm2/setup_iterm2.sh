#!/bin/bash

# setup_iterm2.sh - Native iTerm2 Material Ocean & AlvarDev Profile Setup
# Avoids third-party package managers (Homebrew); uses native macOS Monaco font and built-in tools.

set -euo pipefail

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
THEME_FILE="$SCRIPT_DIR/material-ocean.itermcolors"
PROFILE_FILE="$SCRIPT_DIR/AlvarDev.json"
BANNER_FILE="$SCRIPT_DIR/welcome_banner.txt"
ZSHRC_FILE="$HOME/.zshrc"
USER_BANNER="$HOME/.welcome_banner.txt"
DYNAMIC_PROFILES_DIR="$HOME/Library/Application Support/iTerm2/DynamicProfiles"

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

# Shell Check Reminder (Non-blocking, zero passwords requested)
if [[ "${SHELL:-}" != */zsh ]]; then
    echo -e "\n\033[1;33m⚠️  Important Notice:\033[0m Your login shell is currently set to \033[1m$SHELL\033[0m."
    echo -e "   For the Goku banner, Git prompt, and paths to load automatically on startup,"
    echo -e "   please switch to native macOS Zsh by running:"
    echo -e "   \033[1;32mchsh -s /bin/zsh\033[0m\n"
fi

# 2. Automated iTerm2 Profile Setup via Dynamic Profiles
mkdir -p "$DYNAMIC_PROFILES_DIR"
if [ -f "$PROFILE_FILE" ]; then
    print_status "Installing AlvarDev dynamic profile to iTerm2..."
    cp "$PROFILE_FILE" "$DYNAMIC_PROFILES_DIR/AlvarDev.json"
fi

# Set AlvarDev as default profile and activate Minimalist theme
print_status "Setting AlvarDev as the default iTerm2 profile..."
defaults write com.googlecode.iterm2 "Default Bookmark Guid" -string "1CFB15F1-56AA-42DD-8836-C429A2361322" 2>/dev/null || true
defaults write com.googlecode.iterm2 "TabStyleWithAutomaticOption" -int 5 2>/dev/null || true

# 3. Install Welcome Screen Banner
if [ -f "$BANNER_FILE" ]; then
    print_status "Installing welcome banner to $USER_BANNER..."
    cp "$BANNER_FILE" "$USER_BANNER"
fi

# 4. Configure Native Zero-Dependency Zsh Environment
touch "$ZSHRC_FILE"

# Ensure Antigravity CLI and essential paths (resolving $HOME dynamically)
if ! grep -q "Antigravity CLI" "$ZSHRC_FILE"; then
    print_status "Configuring Antigravity CLI path ($HOME/.local/bin) in $ZSHRC_FILE..."
    cat << 'PATH_EOF' | cat - "$ZSHRC_FILE" > "$ZSHRC_FILE.tmp" && mv "$ZSHRC_FILE.tmp" "$ZSHRC_FILE"
# Essential Paths: Antigravity CLI, Local binaries, Homebrew
export PATH="$HOME/.local/bin:$HOME/.antigravity/antigravity/bin:$HOME/.antigravity-ide/antigravity-ide/bin:/opt/homebrew/bin:/usr/local/bin:$PATH"

PATH_EOF
fi

if ! grep -q "Pure Native Zsh Git Prompt" "$ZSHRC_FILE"; then
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

if ! grep -q "up-line-or-beginning-search" "$ZSHRC_FILE"; then
    print_status "Configuring native prefix history search (Up/Down arrow) in $ZSHRC_FILE..."
    cat >> "$ZSHRC_FILE" << 'ZSH_EOF'

# --- Native Prefix History Search (Zero Dependencies) ---
HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_DUPS
setopt HIST_FIND_NO_DUPS
setopt SHARE_HISTORY

autoload -Uz up-line-or-beginning-search
autoload -Uz down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

bindkey '^[[A' up-line-or-beginning-search
bindkey '^[OA' up-line-or-beginning-search
bindkey '^[[B' down-line-or-beginning-search
bindkey '^[OB' down-line-or-beginning-search
[[ -n "${terminfo[kcuu1]:-}" ]] && bindkey "${terminfo[kcuu1]}" up-line-or-beginning-search
[[ -n "${terminfo[kcud1]:-}" ]] && bindkey "${terminfo[kcud1]}" down-line-or-beginning-search
ZSH_EOF
    print_status "Native prefix history search added successfully."
fi

cat << 'EOF'

===================================================================
✨ Setup complete! 100% Automated Profile Configured:
===================================================================
* Profile: "AlvarDev" installed and set as default
* Palette: Neutral Charcoal (#141414 background, #ffcc00 cursor)
* Font: Native Monaco 12pt with Retina anti-aliasing
* Window: 77 cols x 55 rows, 12px/8px margin padding
* Keybindings: Clean modern defaults (deprecated mappings purged)
* Paths: $HOME/.local/bin included (agy command available)
* History: Native prefix search enabled (type prefix + Up/Down arrow)
===================================================================
👉 If on Bash, remember to switch: chsh -s /bin/zsh
👉 Please restart iTerm2 or open a new window (Cmd + N) to activate!
===================================================================

EOF
