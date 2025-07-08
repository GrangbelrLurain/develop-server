#!/bin/bash

# =============================================================================
#            Development Environment Reset Script for Linux/WSL
# =============================================================================
# This script performs the following actions:
# 1. Removes nvm, Node.js, and globally installed npm packages.
# 2. Reverts the inotify watcher limit configuration.
# 3. Restores the default Ubuntu APT mirror.
# =============================================================================

# Function to print messages
print_message() {
    echo ""
    echo "--- $1 ---"
}

# Exit script on any error
set -e

# 1. Remove nvm, Node.js, and Yarn
# -----------------------------------------------------------------------------
print_message "Removing nvm, Node.js, and Yarn"

# Uninstall Yarn if it exists
if command -v yarn &> /dev/null; then
    npm uninstall -g yarn
    echo "Yarn has been uninstalled."
else
    echo "Yarn not found, skipping."
fi

# Remove nvm directory and clean up .bashrc
if [ -d "$HOME/.nvm" ]; then
    rm -rf "$HOME/.nvm"
    sed -i '/NVM_DIR/d' ~/.bashrc
    sed -i '/nvm.sh/d' ~/.bashrc
    echo "nvm has been removed."
else
    echo "nvm not found, skipping."
fi

echo "Please run 'source ~/.bashrc' or restart your shell to apply changes."

# 2. Revert inotify watcher limit
# -----------------------------------------------------------------------------
print_message "Reverting inotify watcher limit"
if grep -q "fs.inotify.max_user_watches" /etc/sysctl.conf; then
    sudo sed -i '/fs.inotify.max_user_watches/d' /etc/sysctl.conf
    sudo sysctl -p
    echo "Inotify watcher limit has been reverted."
else
    echo "Inotify watcher limit configuration not found, skipping."
fi

# 3. Restore APT mirror
# -----------------------------------------------------------------------------
print_message "Restoring default APT mirror"
if grep -q "kr.archive.ubuntu.com" /etc/apt/sources.list; then
    sudo sed -i 's/kr.archive.ubuntu.com/archive.ubuntu.com/g' /etc/apt/sources.list
    sudo apt-get update
    echo "APT mirror has been restored to the default."
else
    echo "Korean APT mirror not found, skipping."
fi

# 4. Final Instructions
# -----------------------------------------------------------------------------
print_message "Linux environment reset is complete!"
echo "Development tools and configurations have been removed or reverted."

set +e
