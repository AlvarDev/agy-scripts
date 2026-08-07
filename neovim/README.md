# Neovim Setup Automation

This directory contains a self-contained installation and configuration bundle for Neovim (v0.10.4). It is designed to quickly set up a modern, high-performance, and beautiful development workspace on both macOS and Google Cloud VMs.

## 📦 Directory Contents

*   **`setup_nvim.sh`**: The installer and cleanup script.
*   **`nvim/init.lua`**: Your custom native Neovim configuration file.

## 📋 Prerequisites
Before running the installation script, make sure your system has `git` and `curl` installed. 
*   **On Debian/Ubuntu VMs:**
    ```bash
    sudo apt update && sudo apt install -y git curl
    ```

## 🚀 Installation

### Option A: Installing on a Remote VM (One-liner)
To install on a remote VM without cloning the repository, SSH into the VM and run this command (it will download and run the script interactively):
```bash
bash <(curl -sSL https://raw.githubusercontent.com/AlvarDev/agy-scripts/main/neovim/setup_nvim.sh)
```
*(Select Option `1` in the menu).*

### Option B: Installing Locally (Offline)
If you have cloned this repository onto your machine, navigate to this folder and run:
```bash
./setup_nvim.sh
```
*(Select Option `1` in the menu. It will copy the local `nvim/init.lua` config directly).*

---

## 🧼 Cleanup / Uninstallation
To completely remove Neovim and all of its configurations, cache, and plugins from the system, run the script and choose Option `2` (Uninstall & Clean). It will wipe the machine completely clean.

---

## ⌨️ Custom Shortcuts Included

*   **File Tree:** Press `Space + e` to toggle the file tree panel on the left.
*   **File Preview:** Inside the file tree, press **`P` (capital P)** to open the file under the cursor on the right side while keeping your keyboard focus inside the tree for fast scanning.
*   **Window Navigation:** Press `Ctrl + h` to jump to the left panel (the tree), and `Ctrl + l` to jump to the right panel (the editor).
*   **Fuzzy Searching:** Press `:find *filename*` followed by `Tab` to search for files recursively in all subdirectories.
*   **Autocomplete:** Autocomplete dropdowns pop up automatically as you type. Use `Tab` to go down and `Shift + Tab` to go up.
*   **Git Diff:** Press `Space + g + d` to open your active git diff in a terminal split tab.

---

## ⚠️ Troubleshooting: Command not found / PATH Warning
If you install Neovim on a VM and get a warning that `~/.local/bin` is not in your `PATH`, or if typing `nvim` says "command not found", run these two commands in your VM terminal to add it to your terminal profile:
```bash
echo 'export PATH="$PATH:$HOME/.local/bin"' >> ~/.bashrc
source ~/.bashrc
```
