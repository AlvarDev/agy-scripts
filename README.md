# agy-scripts

> This is a repository of scripts that the Antigravity CLI (agy) helps me write for common configurations and tasks I need on a daily basis.

A collection of helper scripts and configurations for setting up, managing, and optimizing remote development environments, tailored for iPad (Safari) and terminal-based coding workflows.

## 📂 Repository Structure

*   **`workstation/`**
    *   Contains the Google Cloud VM manager script (`manage_vms.sh`) for spinning up CUDA/GPU workshops.
    *   Includes the guide for setting up background user services and secure web tunnels.
*   **`neovim/`**
    *   Contains the automated installer script (`setup_nvim.sh`) and the clean, native-only Neovim configuration (`init.lua`).
    *   Pre-configured for a modern dark look (Catppuccin Mocha), custom YAML/Terraform keys, and fast terminal navigation.

## 🚀 Getting Started

1.  To manage your Google Cloud VMs, check out the documentation and manager script in the [workstation](workstation/README.md) directory.
2.  To install or clean up Neovim on your Mac or any remote Linux VM via SSH, check out the script in the [neovim](neovim/README.md) directory.
