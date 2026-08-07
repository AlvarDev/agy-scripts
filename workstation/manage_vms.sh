#!/bin/bash

# Configuration Variables
ZONE="us-central1-a"
TEST_VM="test-connection-vm"
WORK_VM="gemma-workshop-vm"

# Colors for menu
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Helper function to check if a VM exists
vm_exists() {
    gcloud compute instances describe "$1" --zone="$ZONE" >/dev/null 2>&1
    return $?
}

show_status() {
    echo -e "${YELLOW}=== Current VM Status ===${NC}"
    gcloud compute instances list --filter="name:($TEST_VM OR $WORK_VM)" --format="table(name, status, zone)"
    echo ""
}

create_test_vm() {
    if vm_exists "$TEST_VM"; then
        echo -e "${RED}Test VM '$TEST_VM' already exists.${NC}"
        return
    fi
    echo -e "${GREEN}Creating Test VM ($TEST_VM)...${NC}"
    gcloud compute instances create "$TEST_VM" \
        --zone="$ZONE" \
        --machine-type="e2-standard-2" \
        --image-project="debian-cloud" \
        --image-family="debian-11" \
        --boot-disk-size="50GB" \
        --boot-disk-type="pd-standard"
}

create_work_vm() {
    if vm_exists "$WORK_VM"; then
        echo -e "${RED}Work VM '$WORK_VM' already exists.${NC}"
        return
    fi
    echo -e "${GREEN}Creating Work VM ($WORK_VM) with NVIDIA L4 GPU...${NC}"
    echo -e "${YELLOW}This uses Google's Deep Learning image with CUDA 12.1 & PyTorch pre-installed.${NC}"
    gcloud compute instances create "$WORK_VM" \
        --zone="$ZONE" \
        --machine-type="g2-standard-4" \
        --image-project="deeplearning-platform-release" \
        --image-family="common-cu121-debian-11-py310" \
        --maintenance-policy="TERMINATE" \
        --accelerator="type=nvidia-l4,count=1" \
        --boot-disk-size="100GB" \
        --boot-disk-type="pd-balanced"
}

select_vm() {
    echo "Select VM:"
    echo "1) $TEST_VM (Test VM)"
    echo "2) $WORK_VM (Work VM)"
    read -p "Choose option [1-2]: " vm_choice
    case $vm_choice in
        1) SELECTED_VM="$TEST_VM" ;;
        2) SELECTED_VM="$WORK_VM" ;;
        *) echo -e "${RED}Invalid selection.${NC}"; return 1 ;;
    esac
    return 0
}

start_vm() {
    select_vm || return
    echo -e "${GREEN}Starting VM '$SELECTED_VM'...${NC}"
    gcloud compute instances start "$SELECTED_VM" --zone="$ZONE"
}

stop_vm() {
    select_vm || return
    echo -e "${YELLOW}Stopping (Pausing) VM '$SELECTED_VM' (this stops hourly billing)...${NC}"
    gcloud compute instances stop "$SELECTED_VM" --zone="$ZONE"
}

delete_vm() {
    select_vm || return
    echo -e "${RED}WARNING: This will permanently delete VM '$SELECTED_VM' and its disks.${NC}"
    read -p "Are you sure you want to delete this VM? [y/N]: " confirm
    if [[ "$confirm" =~ ^[Yy]$ ]]; then
        gcloud compute instances delete "$SELECTED_VM" --zone="$ZONE" --quiet
    else
        echo "Deletion cancelled."
    fi
}

# Main loop
while true; do
    clear
    echo -e "${GREEN}=============================================${NC}"
    echo -e "${GREEN}    Google Cloud VM Manager (Gemma Workshop)   ${NC}"
    echo -e "${GREEN}=============================================${NC}"
    show_status
    echo "Choose an action:"
    echo "1) Create TEST VM (e2-standard-2 - Connection Test)"
    echo "2) Create WORK VM (g2-standard-4 - Gemma L4 GPU & pre-installed PyTorch/CUDA)"
    echo "3) Start (Run) a VM"
    echo "4) Stop (Pause) a VM"
    echo "5) Delete a VM"
    echo "6) Exit"
    echo ""
    read -p "Select option [1-6]: " choice
    echo ""

    case $choice in
        1) create_test_vm ;;
        2) create_work_vm ;;
        3) start_vm ;;
        4) stop_vm ;;
        5) delete_vm ;;
        6) echo "Exiting. Goodbye!"; exit 0 ;;
        *) echo -e "${RED}Invalid option.${NC}" ;;
    esac
    
    echo ""
    read -p "Press [Enter] to return to the menu..."
done
