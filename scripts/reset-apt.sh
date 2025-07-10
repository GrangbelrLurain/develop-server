#!/bin/bash

# =============================================================================
#           APT Reset and Clean Script for Ubuntu/WSL
# =============================================================================
# This script performs the following actions:
# 1. Cleans the APT cache.
# 2. Removes existing package lists to force a fresh download.
# 3. Updates package lists from repositories.
# 4. (Optional) Upgrades installed packages.
# =============================================================================

# Exit script on any error
set -e

# Function to print messages
print_message() {
    echo ""
    echo "--- $1 ---"
}

# --- Main Script ---

print_message "Starting APT reset and clean process..."
# Step 1: apt 캐시를 완전히 비웁니다.
sudo apt clean

# Step 2: /var/lib/apt/lists/ 내용을 삭제하여 패키지 리스트를 강제로 다시 다운로드하게 합니다.
sudo rm -rf /var/lib/apt/lists/*

# Step 3: apt 업데이트를 다시 시도합니다.
# `--allow-releaseinfo-change`는 이미 사용하고 계시니 그대로 사용합니다.
sudo apt update

# 4. (Optional) Upgrade installed packages
# 이 단계는 필수는 아니지만, 문제가 해결된 후 시스템을 최신 상태로 만들 때 유용합니다.
read -p "Do you want to upgrade installed packages now? (y/N): " confirm_upgrade
if [[ "$confirm_upgrade" =~ ^[Yy]$ ]]; then
    print_message "4. Upgrading installed packages..."
    sudo apt-get upgrade -y
    echo "   -> All installed packages upgraded."
else
    echo "   -> Skipping package upgrade."
fi

print_message "APT reset and clean process complete!"
echo "Your APT package management system has been refreshed."

set +e
