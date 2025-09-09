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

log_error() {
    echo -e "${RED}${FAIL_EMOJI} ERROR: $1${NC}"
    exit 1
}

log_working() {
    echo -e "${BLUE}${WORKING_EMOJI} WORKING: $1${NC}"
}

apply_uninstall_state() {
    log_info "Applying uninstall Salt state... ${SLOTH_EMOJI}"
    if ! sudo salt-call --local state.apply uninstall; then
        log_error "Failed to apply uninstall Salt state. Please check the logs. ${FAIL_EMOJI}"
    fi
    log_success "Uninstall Salt state applied successfully! ${SUCCESS_EMOJI}"
}

remove_salt_minion() {
    log_info "Removing salt-minion package... ${SLOTH_EMOJI}"
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        OS=$ID
    else
        log_error "Could not detect operating system. ${FAIL_EMOJI}"
    fi

    if [[ "$OS" == "ubuntu" || "$OS" == "debian" ]]; then
        sudo apt-get purge -y salt-minion || log_error "Failed to remove salt-minion. ${FAIL_EMOJI}"
    else
        log_error "Operating system ${OS} not supported for automatic salt-minion removal. ${FAIL_EMOJI}"
    fi
    log_success "salt-minion package removed successfully! ${SUCCESS_EMOJI}"
}

cleanup_salt_files() {
    log_info "Cleaning up remaining Salt files... ${SLOTH_EMOJI}"
    log_working "Removing /srv/salt... ${WORKING_EMOJI}"
    sudo rm -rf /srv/salt || log_error "Failed to remove /srv/salt. ${FAIL_EMOJI}"
    log_success "/srv/salt removed! ${SUCCESS_EMOJI}"

    log_working "Removing /etc/salt... ${WORKING_EMOJI}"
    sudo rm -rf /etc/salt || log_error "Failed to remove /etc/salt. ${FAIL_EMOJI}"
    log_success "/etc/salt removed! ${SUCCESS_EMOJI}"
}

main() {
    log_info "Starting uninstallation process... ${START_EMOJI}"

    apply_uninstall_state
    remove_salt_minion
    cleanup_salt_files

    log_success "Uninstallation complete! Your system is clean. ${DONE_EMOJI}"
}

main