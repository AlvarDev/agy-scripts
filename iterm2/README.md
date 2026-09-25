# iTerm2 AlvarDev Terminal Setup

This directory contains native setup automation and documentation to configure **iTerm2** with the **AlvarDev** profile (**Material Ocean** palette, native **Monaco** font, and pure zero-dependency **Zsh Git prompt**).

## 📦 Directory Contents

* **`setup_iterm2.sh`**: Zero-dependency installer script that automatically provisions the `AlvarDev` default profile in iTerm2, sets essential Antigravity paths (`$HOME/.local/bin`), and configures the native Zsh prompt.
* **`AlvarDev.json`**: Pre-configured iTerm2 Dynamic Profile with Monaco 12, Material Ocean colors, 77x55 geometry, 10,000 scrollback lines, and Natural Text Editing key mappings.
* **`material-ocean.itermcolors`**: Native iTerm2 color preset with neutral dark charcoal background (`#141414`), slate text (`#8f93a2`), and signature gold cursor (`#ffcc00`).
* **`welcome_banner.txt`**: Goku ASCII art welcome screen displayed on terminal startup.

## 🚀 Installation

### 1. Prerequisite: Ensure Native Zsh Shell
Before running the installer, ensure your default login shell is `/bin/zsh`:
```bash
echo "SHELL is: $SHELL"
```
If it returns `/bin/bash`, switch to native macOS Zsh:
```bash
chsh -s /bin/zsh
```

### 2. Run Setup Script (Zero Passwords Required)
```bash
chmod +x setup_iterm2.sh
./setup_iterm2.sh
```

The script automatically:
1. Installs the `AlvarDev` Dynamic Profile directly into iTerm2 with `material-ocean` colors, native `Monaco 12`, 12/8 margin padding, 10,000 scrollback lines, and Natural Text Editing key mappings.
2. Sets `AlvarDev` as the **default profile** and activates the **Minimalist seamless theme**.
3. Guarantees `$HOME/.local/bin` (`agy` binary), Homebrew, and user paths in `~/.zshrc`.
4. Installs the Goku welcome banner and zero-dependency Zsh Git prompt.
5. Configures native prefix history search (`up-line-or-beginning-search`), allowing you to type a command prefix (e.g. `git`) and press Up Arrow to search only matching commands.

## 💻 MacBook Pro & Shell Performance Tips

* **Retina Anti-Aliasing**: Under `Profiles` > `Text`, set **Use thin strokes for anti-aliased text** to **Only on Retina Displays** to keep Monaco razor-sharp on Liquid Retina XDR displays.
* **120Hz ProMotion Rendering**: Under `General` > `Advanced`, search for `Metal` to ensure GPU-accelerated drawing is active for 120 FPS high-refresh rendering.
* **Zero-Dependency Zsh Prompt**: Uses native Zsh `vcs_info` with no external frameworks (Oh My Zsh), ensuring sub-millisecond shell startup while displaying dynamic Git branch and dirty indicators (`➜ folder git:(branch) ✗`).
