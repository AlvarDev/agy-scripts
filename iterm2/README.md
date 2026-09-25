# iTerm2 Modern Aesthetic Setup

This directory contains native setup automation and documentation to style **iTerm2** to match the repository's **Catppuccin Mocha** Neovim theme.

## 📦 Directory Contents

* **`setup_iterm2.sh`**: Zero-dependency installer script that downloads the official Catppuccin Mocha palette and JetBrains Mono Nerd Font directly into native user directories (`~/Library/Fonts`).
* **`catppuccin-mocha.itermcolors`**: Downloaded iTerm2 color preset.

## 🚀 Installation

Run the script locally:
```bash
chmod +x setup_iterm2.sh
./setup_iterm2.sh
```

## ⚙️ Manual iTerm2 Preferences Configuration

After running the script, configure these 4 settings in iTerm2 (`Cmd + ,`):

1. **Colors**: `Profiles` > `Colors` > `Color Presets...` > choose **catppuccin-mocha**.
2. **Font**: `Profiles` > `Text` > `Font` > choose **JetBrainsMono Nerd Font** (13pt or 14pt).
3. **Frame Theme**: `Appearance` > `General` > `Theme` > select **Minimal** (title bar seamlessly matches `#1e1e2e`).
4. **Padding & Scrollbar**:
   * `Profiles` > `Window`: Set Horizontal Margin to `12` and Vertical Margin to `8`.
   * `Profiles` > `Terminal`: Uncheck `Show scrollbar`.
5. **Keybindings**: `Profiles` > `Keys` > `Key Mappings` > `Presets...` > select **Natural Text Editing**.
