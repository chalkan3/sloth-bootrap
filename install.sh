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
    log_info "Copying Salt states to /srv/salt... ${SLOTH_EMOJI}"
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
    SALT_SOURCE_DIR="${SCRIPT_DIR}/salt"

    if [ ! -d "$SALT_SOURCE_DIR" ]; then
        log_error "Salt states directory not found at ${SALT_SOURCE_DIR}. Please ensure the 'salt' directory is present alongside 'install.sh'. ${FAIL_EMOJI}"
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
 |  _  |  __/ | |  __/\__ \
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

case "$OS" in
    ubuntu|debian) 
        log_info "System detected: Ubuntu/Debian. Adding SaltStack repository. ${SLOTH_EMOJI}"
        log_working "Updating package indexes... ${WORKING_EMOJI}"
        sudo apt-get update || log_error "Failed to update apt. ${FAIL_EMOJI}"
        log_working "Installing dependencies... ${WORKING_EMOJI}"
        sudo apt-get install -y wget gnupg || log_error "Failed to install dependencies. ${FAIL_EMOJI}"

        log_working "Adding SaltStack GPG key... ${WORKING_EMOJI}"
        wget -O - https://repo.saltproject.io/py3/ubuntu/22.04/amd64/archive/2023.3.1/SALTSTACK-GPG-KEY.pub | sudo gpg --dearmor -o /usr/share/keyrings/salt-archive-keyring.gpg || log_error "Failed to add GPG key. ${FAIL_EMOJI}"

        log_working "Adding SaltStack repository... ${WORKING_EMOJI}"
        echo "deb [signed-by=/usr/share/keyrings/salt-archive-keyring.gpg] https://repo.saltproject.io/py3/ubuntu/22.04/amd64/archive/2023.3.1 jammy main" | sudo tee /etc/apt/sources.list.d/salt.list || log_error "Failed to add repository. ${FAIL_EMOJI}"

        log_working "Updating package indexes again... ${WORKING_EMOJI}"
        sudo apt-get update || log_error "Failed to update apt after adding repo. ${FAIL_EMOJI}"
        log_working "Installing salt-minion... ${WORKING_EMOJI}"
        sudo apt-get install -y salt-minion || log_error "Failed to install salt-minion. ${FAIL_EMOJI}"
        ;; 
    centos|rhel|fedora) 
        log_info "System detected: CentOS/RHEL/Fedora. Adding SaltStack repository. ${SLOTH_EMOJI}"
        log_working "Installing EPEL repository... ${WORKING_EMOJI}"
        sudo yum install -y epel-release || log_error "Failed to install epel-release. ${FAIL_EMOJI}"
        log_working "Installing SaltStack repository... ${WORKING_EMOJI}"
        sudo yum install -y https://repo.saltproject.io/py3/redhat/salt-py3-repo-latest.el8.noarch.rpm || log_error "Failed to install SaltStack repo. ${FAIL_EMOJI}"
        log_working "Installing salt-minion... ${WORKING_EMOJI}"
        sudo yum install -y salt-minion || log_error "Failed to install salt-minion. ${FAIL_EMOJI}"
        ;; 
    *)
        log_error "Operating system ${OS} not supported for automatic Salt Minion installation. ${FAIL_EMOJI}"
        ;; 
esac

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

copy_salt_states
apply_salt_states

log_success "Bootstrap complete! Salt Minion installed, configured, and states applied. ${DONE_EMOJI}"