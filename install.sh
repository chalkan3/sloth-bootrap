#!/bin/bash

# --- Style Variables and Emojis ---
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
BLUE="\033[0;34m"
RED="\033[0;31m"
NC="\033[0m" # No Color

SLOTH_EMOJI="🦥"
SUCCESS_EMOJI="✅"
FAIL_EMOJI="❌"
INFO_EMOJI="ℹ️"
WORKING_EMOJI="⚙️"
START_EMOJI="🚀"
DONE_EMOJI="🎉"

# --- Repository and Clone Configuration ---
REPO_URL="https://github.com/chalkan3/sloth-bootstrap.git"
CLONE_DIR="/tmp/sloth-bootstrap"

log_info() {
    echo -e "${BLUE}${INFO_EMOJI} INFO: $1${NC}"
}

log_success() {
    echo -e "${GREEN}${SUCCESS_EMOJI} SUCCESS: $1${NC}"
}

log_warning() {
    echo -e "${YELLOW}${SLOTH_EMOJI} WARNING: $1${NC}"
}

log_error() {
    echo -e "${RED}${FAIL_EMOJI} ERROR: $1${NC}"
    exit 1
}

log_working() {
    echo -e "${BLUE}${WORKING_EMOJI} WORKING: $1${NC}"
}

# --- Helper Functions for Salt State Management ---
copy_salt_states() {
    log_info "Copying Salt states from cloned repository to /srv/salt... ${SLOTH_EMOJI}"
    SALT_SOURCE_DIR="${CLONE_DIR}/salt"

    if [ ! -d "$SALT_SOURCE_DIR" ]; then
        log_error "Salt states directory not found at ${SALT_SOURCE_DIR}. Please ensure the 'salt' directory is present in the cloned repository. ${FAIL_EMOJI}"
    fi

    sudo cp -r "${SALT_SOURCE_DIR}"/* /srv/salt/ || log_error "Failed to copy Salt states. ${FAIL_EMOJI}"
    log_success "Salt states copied to /srv/salt! ${SUCCESS_EMOJI}"
}

apply_salt_states() {
    log_info "Applying Salt states locally... ${SLOTH_EMOJI}"
    sudo salt-call --local state.apply || log_error "Failed to apply Salt states. ${FAIL_EMOJI}"
    log_success "Salt states applied successfully! ${SUCCESS_EMOJI}"
}

echo -e "${BLUE}
  _   _      _ _
 | | | | ___| | | ___  ___
 | |_| |/ _ \ | |/ _ \/ __|
 |  _  |  __/ | |  __/
 |_| |_|\___|_|_|\___||___/

${NC}"
log_info "Starting Salt Minion bootstrap... ${START_EMOJI}"
log_info "Preparing to install Salt Minion. ${SLOTH_EMOJI}"

# --- OS Detection and Salt Minion Installation ---
if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$ID
else
    log_error "Could not detect operating system. ${FAIL_EMOJI}"
fi

log_working "Detecting operating system: ${OS} ${WORKING_EMOJI}"

if [[ "$OS" == "ubuntu" || "$OS" == "debian" ]]; then
    log_info "System detected: Ubuntu/Debian. Installing salt-minion. ${SLOTH_EMOJI}"
    log_working "Updating package indexes... ${WORKING_EMOJI}"
    sudo apt-get update || log_error "Failed to update apt. ${FAIL_EMOJI}"
    log_working "Installing salt-minion... ${WORKING_EMOJI}"
    sudo apt-get install -y salt-minion || log_error "Failed to install salt-minion. ${FAIL_EMOJI}"
else
    log_error "Operating system ${OS} not supported. This script only supports Ubuntu/Debian. ${FAIL_EMOJI}"
fi

log_success "Salt Minion installed successfully! ${SUCCESS_EMOJI}"

# --- Salt Minion Configuration for Masterless ---
log_info "Configuring Salt Minion for masterless mode (salt-local). ${SLOTH_EMOJI}"
log_working "Creating configuration directory for masterless... ${WORKING_EMOJI}"
sudo mkdir -p /etc/salt/minion.d || log_error "Failed to create /etc/salt/minion.d directory. ${FAIL_EMOJI}"

log_working "Configuring minion not to look for a master... ${WORKING_EMOJI}"
echo "master: localhost" | sudo tee /etc/salt/minion.d/masterless.conf || log_error "Failed to configure masterless. ${FAIL_EMOJI}"
echo "file_client: local" | sudo tee -a /etc/salt/minion.d/masterless.conf || log_error "Failed to configure file_client. ${FAIL_EMOJI}"

log_working "Restarting salt-minion service... ${WORKING_EMOJI}"
sudo systemctl enable salt-minion || log_warning "Could not enable salt-minion service. Continue manually if needed. ${SLOTH_EMOJI}"
sudo systemctl restart salt-minion || log_error "Failed to restart salt-minion service. ${FAIL_EMOJI}"

log_success "Salt Minion configured for masterless and service restarted! ${SUCCESS_EMOJI}"

# --- Git Installation and Repository Cloning ---
log_info "Ensuring git is installed... ${SLOTH_EMOJI}"
if ! command -v git &> /dev/null
then
    log_working "git not found, installing... ${WORKING_EMOJI}"
    if [[ "$OS" == "ubuntu" || "$OS" == "debian" ]]; then
        sudo apt-get update || log_error "Failed to update apt for git installation. ${FAIL_EMOJI}"
        sudo apt-get install -y git || log_error "Failed to install git. ${FAIL_EMOJI}"
    else
        log_error "Operating system ${OS} not supported for automatic git installation. Please install git manually. ${FAIL_EMOJI}"
    fi
    log_success "git installed successfully! ${SUCCESS_EMOJI}"
else
    log_success "git is already installed! ${SUCCESS_EMOJI}"
fi

log_info "Cloning repository ${REPO_URL} to ${CLONE_DIR}... ${SLOTH_EMOJI}"
if [ -d "$CLONE_DIR" ]; then
    log_warning "Directory ${CLONE_DIR} already exists. Removing it before cloning. ${SLOTH_EMOJI}"
    sudo rm -rf "$CLONE_DIR" || log_error "Failed to remove existing directory ${CLONE_DIR}. ${FAIL_EMOJI}"
fi
git clone "$REPO_URL" "$CLONE_DIR" || log_error "Failed to clone repository ${REPO_URL}. ${FAIL_EMOJI}"
log_success "Repository cloned successfully to ${CLONE_DIR}! ${SUCCESS_EMOJI}"

copy_salt_states
apply_salt_states

log_success "Bootstrap complete! Salt Minion installed, configured, and states applied. ${DONE_EMOJI}"
