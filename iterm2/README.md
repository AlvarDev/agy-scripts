# iTerm2 AlvarDev Terminal Setup

This directory contains native setup automation and documentation to configure **iTerm2** with the **AlvarDev** profile (**Material Ocean** palette, native **Monaco** font, and pure zero-dependency **Zsh Git prompt**).

## 📦 Directory Contents

* **`setup_iterm2.sh`**: Zero-dependency installer script that imports the local `material-ocean.itermcolors` preset into iTerm2, copies the Goku welcome banner, and configures the native Zsh Git prompt in `~/.zshrc`.
* **`material-ocean.itermcolors`**: Native iTerm2 color preset with deep midnight background (`#0f111a`), slate text (`#8f93a2`), and signature gold cursor (`#ffcc00`).
* **`welcome_banner.txt`**: Goku ASCII art welcome screen displayed on terminal startup.

## 🚀 Installation

Run the script locally:
```bash
chmod +x setup_iterm2.sh
./setup_iterm2.sh
```

## ⚙️ Manual iTerm2 Preferences Configuration

After running the script, configure these 5 settings in iTerm2 (`Cmd + ,`):

1. **Colors**: `Profiles` > `Colors` > `Color Presets...` > choose **material-ocean**.
2. **Font**: `Profiles` > `Text` > `Font` > choose native **Monaco** (Size: 12pt).
3. **Frame Theme**: `Appearance` > `General` > `Theme` > select **Minimal** (title bar seamlessly matches `#0f111a`).
4. **Padding & Scrollback**:
   * `Profiles` > `Window`: Set Horizontal Margin to `12` and Vertical Margin to `8`.
   * `Profiles` > `Terminal`: Uncheck `Show scrollbar` and set **Scrollback lines** to `10000`.
5. **Keybindings**: `Profiles` > `Keys` > `Key Mappings` > `Presets...` > select **Natural Text Editing** (enables macOS `Option + ← / →` word hopping).

## 💻 MacBook Pro & Shell Performance Tips

* **Retina Anti-Aliasing**: Under `Profiles` > `Text`, set **Use thin strokes for anti-aliased text** to **Only on Retina Displays** to keep Monaco razor-sharp on Liquid Retina XDR displays.
* **120Hz ProMotion Rendering**: Under `General` > `Advanced`, search for `Metal` to ensure GPU-accelerated drawing is active for 120 FPS high-refresh rendering.
* **Zero-Dependency Zsh Prompt**: Uses native Zsh `vcs_info` with no external frameworks (Oh My Zsh), ensuring sub-millisecond shell startup while displaying dynamic Git branch and dirty indicators (`➜ folder git:(branch) ✗`).
