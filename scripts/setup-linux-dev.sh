#!/bin/bash

# =============================================================================
#           Development Environment Setup Script for Linux/WSL
# =============================================================================
# This script performs the following actions:
# 1. Updates package lists and upgrades the system.
# 2. Installs essential development tools (git, curl).
# 3. Installs Node.js using Node Version Manager (nvm).
# 4. Installs Yarn package manager.
# 5. Installs Docker Engine (Docker CE) directly in WSL2.
# 6. Increases the inotify watcher limit for hot-reloading.
# =============================================================================

# --- Configuration ---
# The Node.js version is passed as the first argument to the script.
NODE_VERSION=${1:-18.17.0} # Default to 18.17.0 if no version is provided

# Function to print messages
print_message() {
    echo ""
    echo "--- $1 ---"
}

# Exit script on any error
set -e

# 1. Initial Setup & Essential Tools
# -----------------------------------------------------------------------------
print_message "Changing APT mirror to a Korean server for better stability"
sudo sed -i 's/archive.ubuntu.com/kr.archive.ubuntu.com/g' /etc/apt/sources.list

print_message "Cleaning and updating system packages"
sudo rm -rf /var/lib/apt/lists/*
sudo apt-get clean
sudo apt-get update
sudo apt-get upgrade -y

print_message "Installing essential tools (git, curl, ca-certificates, gnupg, lsb-release)"
sudo apt-get install -y git curl ca-certificates gnupg lsb-release

git config --global credential.helper /mnt/c/Program\ Files/Git/mingw64/bin/git-credential-manager.exe

# 2. Install Node.js via nvm
# -----------------------------------------------------------------------------
print_message "Installing Node.js v$NODE_VERSION via nvm"

# Install nvm
export NVM_DIR="$HOME/.nvm"
if [ ! -d "$NVM_DIR" ]; then
    echo "nvm is not installed. Installing now..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
    # nvm이 ~/.bashrc에 추가하는 기본 설정 라인을 여기에 직접 추가
    # `install.sh` 스크립트가 이미 이 작업을 수행하지만, 확실성을 위해 다시 추가
    grep -q 'export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"' ~/.bashrc || \
        echo 'export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"' >> ~/.bashrc
    grep -q '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm' ~/.bashrc || \
        echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm' >> ~/.bashrc
    # 현재 세션에 nvm 로드
    source ~/.bashrc
else
    echo "nvm is already installed. Ensuring it's loaded..."
    # nvm이 이미 설치되어 있다면 현재 세션에 로드
    source ~/.bashrc
fi

# Load nvm (ensure it's loaded for the rest of the script)
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" || { echo "ERROR: nvm failed to load."; exit 1; }


# Install and set the desired Node.js version
if nvm list "$NODE_VERSION" | grep -q "$NODE_VERSION"; then
    echo "Node.js v$NODE_VERSION is already installed."
else
    nvm install "$NODE_VERSION"
fi

nvm use "$NODE_VERSION"
nvm alias default "$NODE_VERSION"

echo "Node.js version: $(node -v)"
echo "npm version: $(npm -v)"

# 3. Install Yarn
# -----------------------------------------------------------------------------
print_message "Installing Yarn globally"
if ! command -v yarn &> /dev/null
then
    npm install -g yarn
    echo "Yarn installed successfully."
else
    echo "Yarn is already installed."
fi
echo "Yarn version: $(yarn --version)"

# 4. Install Docker Engine (Docker CE) in WSL2
# -----------------------------------------------------------------------------
print_message "Installing Docker Engine (Docker CE) in WSL2"

# Remove any old Docker versions
sudo apt-get remove docker docker-engine docker.io containerd runc 2>/dev/null || true

# Add Docker's official GPG key
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# Add the Docker repository to Apt sources
echo \
  "deb [arch=\"$(dpkg --print-architecture)\" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  \"$(. /etc/os-release && echo \"$VERSION_CODENAME\")\" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update apt package index
sudo apt-get update

# Install Docker Engine, CLI, Containerd, and Docker Compose plugin
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Add current user to the 'docker' group to run Docker commands without sudo
print_message "Adding current user to 'docker' group"
sudo usermod -aG docker "$USER"

echo "Docker Engine installed. Please restart your WSL terminal for group changes to take effect."
echo "You can test Docker by running 'docker run hello-world' in a NEW terminal."

# 5. Increase inotify watcher limit for Hot Reload
# -----------------------------------------------------------------------------
print_message "Increasing inotify watcher limit for file watching"
WATCHER_LIMIT=524288
if ! grep -q "fs.inotify.max_user_watches" /etc/sysctl.conf; then
    echo "fs.inotify.max_user_watches=$WATCHER_LIMIT" | sudo tee -a /etc/sysctl.conf
    sudo sysctl -p
    echo "Inotify watcher limit has been set to $WATCHER_LIMIT."
else
    echo "Inotify watcher limit is already configured."
fi

# 6. Final Instructions
# -----------------------------------------------------------------------------
print_message "Linux setup is complete!"
echo "All essential development tools have been installed and configured."
echo ""
echo "Next steps:"
echo "1. Close this terminal and open a new WSL terminal to apply 'docker' group changes."
echo "2. In the new terminal, verify Docker is working: 'docker run hello-world'"
echo "3. Clone your project repository into your WSL home directory (e.g., /home/your_user/)."
echo "4. Navigate into the project directory."
echo "5. Run 'docker-compose up -d' to start your development environment."
echo ""
echo "Setup finished. Happy coding!"

set +e