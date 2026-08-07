# iPad Remote Development Guide: Google Cloud VMs + VS Code Tunnels

This guide details the step-by-step process for setting up a secure, cost-optimized, and full-featured remote development environment on Google Cloud specifically tailored for **iPad** users connecting via **Cloud Shell** and **VS Code Tunnels**.

---

## 📋 Table of Contents
1. [VM Configurations & Scripts](#1-vm-configurations--scripts)
2. [Step-by-Step Setup Workflow](#2-step-by-step-setup-workflow)
3. [Client Connection (Safari & iPadOS Settings)](#3-client-connection-safari--ipados-settings)
4. [Persist & Autostart (Running as a Service)](#4-persist--autostart-running-as-a-service)
5. [Cost Optimization & Cleanup](#5-cost-optimization--cleanup)
6. [Troubleshooting & FAQs](#6-troubleshooting--faqs)

---

## 1. VM Configurations & Scripts

Your workspace contains an interactive manager script at `workstation/manage_vms.sh`. You can upload this script to your Cloud Shell and run it:
```bash
chmod +x manage_vms.sh
./manage_vms.sh
```

### VM Specifications:
* **Test VM (`test-connection-vm`)**:
  * **Machine Type**: `e2-standard-2` (2 vCPUs, 8 GB RAM)
  * **Cost**: ~$0.06/hour
  * **Purpose**: Testing connections and verifying package installation scripts without crashing.
* **Work VM (`gemma-workshop-vm`)**:
  * **Machine Type**: `g2-standard-4` (4 vCPUs, 16 GB RAM, 1 NVIDIA L4 GPU)
  * **Cost**: ~$0.90/hour (US regions)
  * **Image**: Deep Learning Image (`common-cu121-debian-11-py310`) which has **CUDA 12.1 and PyTorch pre-installed**.

---

## 2. Step-by-Step Setup Workflow

Follow these instructions to spin up your machine and configure standard system permissions:

### Step 2.1: Create and Login to your VM
1. Open **Safari** on your iPad and go to the Google Cloud Console.
2. Open **Cloud Shell**.
3. Start your VM using the manager script, then SSH into the VM:
   ```bash
   gcloud compute ssh test-connection-vm --zone=us-central1-a
   ```

### Step 2.2: Apply the systemd & DBus Fix (Required for Background Services)
By default, standard Debian VMs on Google Cloud terminate user processes when the SSH session ends. Run these commands inside the VM terminal to allow background services:
```bash
# A. Install the required system user-session helper
sudo apt-get update && sudo apt-get install -y dbus-user-session

# B. Allow your user to run background services after logging out (lingering)
sudo loginctl enable-linger $USER

# C. Reboot the VM to apply changes
sudo reboot
```
*Wait 15–20 seconds, then reconnect via Cloud Shell SSH.*

### Step 2.3: (Optional) Run tmux for Session Persistence
Since Safari on iPad OS puts background tabs to sleep and drops SSH connections, always run your terminal tasks (like Neovim) inside **`tmux`** to protect your work from being killed:
1.  **Start tmux:** When you SSH into your VM, type:
    ```bash
    tmux
    ```
    *(This opens a managed session where you can safely run Neovim).*
2.  **Leave running (Detach):** Press **`Ctrl + b`**, release them, and then press **`d`**. Your editor remains running in the background.
3.  **Restore session (Attach):** When you reconnect to your VM via SSH, run:
    ```bash
    tmux attach
    ```

---

## 3. Client Connection (Safari & iPadOS Settings)

### Step 3.1: Install & Authenticate the Tunnel
Once logged back into the VM, run the following:
```bash
# 1. Download and extract the VS Code CLI tool
curl -Lk 'https://code.visualstudio.com/sha/download?build=stable&os=cli-alpine-x64' --output vscode_cli.tar.gz
tar -xf vscode_cli.tar.gz

# 2. Register the tunnel as a background service
./code tunnel service install
```
* Follow the instructions printed in the terminal.
* Open the authentication URL (e.g. `https://github.com/login/device`) in your browser.
* Enter the 8-character verification code and log in with your GitHub or Microsoft account.

### Step 3.2: Start the Tunnel Service
Start the daemon process on the VM:
```bash
./code tunnel service start
```
*You can now safely close the Cloud Shell tab.*

---

## 4. Client Connection (Safari & iPadOS Settings)

For the best experience, run VS Code in **Safari** and optimize the permissions for clipboard support.

### Step 4.1: Access the Editor
1. In Safari, go to: **[vscode.dev/tunnels](https://vscode.dev/tunnels)**
2. Log in with your authorized GitHub/Microsoft account.
3. Select your VM from the list (e.g. `test-connection-vm`) to launch the IDE.

### Step 4.2: Resolve Clipboard & Paste Warnings
Browsers restrict web apps from reading your iPad's clipboard without explicit authorization.

1. **In Safari**:
   * Tap the **`aA`** icon in the Safari search/address bar.
   * Tap **Website Settings**.
   * Change **Clipboard** permission to **Allow**.
   * Refresh the page.
2. **Keyboard Shortcut Workaround**:
   * Always use standard keyboard shortcuts **`Cmd + C`** (Copy) and **`Cmd + V`** (Paste).
   * Native keyboard actions bypass JavaScript API security prompts automatically.

> [!TIP]
> **To get a full app-like experience without toolbar clutter:**
> While viewing `vscode.dev` in Safari, tap the **`aA`** icon and select **Hide Toolbar**. This removes the browser tabs and address bar, giving you a full, immersive chromeless window.

---

## 5. Cost Optimization & Cleanup

Because you are the sole developer, you must manage your active VM hours to avoid unnecessary bills (particularly for GPU instances).

* **Compute vs. Storage Billing**:
  * **Running VM**: Billed for CPU/RAM + GPU + Disk Storage.
  * **Stopped VM**: Billed **$0.00** for CPU/RAM/GPU. You only pay a few cents per day for the persistent disk storage (e.g. ~$0.33/day for a 100 GB work disk).
  * **Deleted VM**: Billed **$0.00** for everything.
* **Best Practices**:
  * **After a session**: Stop the VM using option `4) Stop (Pause) a VM` in the script. The next time you start the VM, the VS Code tunnel will auto-start in the background automatically.
  * **Two weeks before/after a workshop**: Delete the VM entirely using option `5) Delete a VM` to prevent storage costs from accumulating over long idle periods.

---

## 6. Troubleshooting & FAQs

#### Q: I closed the tab, is my tunnel still alive?
**Yes.** Because we installed it as a `service`, the tunnel runs in the background on the Google Cloud VM. You can reopen it at any time by going to `vscode.dev/tunnels`.

#### Q: How do I shut down the tunnel and log out of my credentials?
If you want to clear credentials on a test VM:
```bash
# Stop the background service
./code tunnel service uninstall

# Log out your Github/Microsoft session
./code tunnel user logout
```
*(Optional)* Go to your GitHub account under **Settings > Applications > Authorized OAuth Apps** and revoke **Visual Studio Code**.

#### Q: How do I access a web server (localhost) running on the VM from my iPad?
1. In the bottom panel of `vscode.dev` (next to your Terminal tab), select the **Ports** tab.
2. Click **Add Port** and enter your port (e.g. `8000` or `8080`).
3. VS Code will generate a secure HTTPS forwarded address (e.g., `https://random-id-8000.devtunnels.ms`). Click it to open your local site in a new tab.
