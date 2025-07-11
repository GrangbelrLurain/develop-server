#!/bin/bash
set -e

echo "========================================"
echo "WSL2 Ubuntu Development Environment Setup"
echo "========================================"

echo "Step 1: Updating and upgrading system packages..."
sudo apt update && sudo apt upgrade -y
echo "System update and upgrade complete."

echo "Step 2: Installing essential utilities (build-essential, curl, wget, git)..."
sudo apt install -y build-essential curl wget git
echo "Essential utilities installed."

echo "Step 3: Installing Zsh and Oh My Zsh..."
sudo apt install -y zsh
echo "Zsh installed. Installing Oh My Zsh..."
# Install Oh My Zsh non-interactively
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended || true
# The above command might fail if .zshrc already exists and is not empty, but Oh My Zsh might still be installed.
# We'll proceed with modifications assuming it's there or will be created.

echo "Configuring Oh My Zsh plugins and theme..."
# Clone zsh-syntax-highlighting and zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting || true
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions || true
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k || true

# Modify ~/.zshrc for plugins and theme
if [ -f ~/.zshrc ]; then
    # Update plugins line
    sed -i 's/^plugins=(git)/plugins=(git z fzf docker docker-compose nvm zsh-syntax-highlighting zsh-autosuggestions)/' ~/.zshrc || true
    # Set ZSH_THEME
    sed -i 's/^ZSH_THEME="[^"]*"/ZSH_THEME="powerlevel10k/powerlevel10k"/' ~/.zshrc || true
else
    echo "Warning: ~/.zshrc not found. Oh My Zsh might not have installed correctly or this is a fresh install."
    echo "Attempting to create a basic .zshrc with plugins and theme."
    cat << EOF > ~/.zshrc
export ZSH="$HOME/.oh-my-zsh"

plugins=(git z fzf docker docker-compose nvm zsh-syntax-highlighting zsh-autosuggestions)
source \$ZSH/oh-my-zsh.sh
EOF
fi

# use zsh for default shell
sudo chsh -s "$(which zsh)" "$USER"
echo "Zsh set as default shell for $USER."

echo "Oh My Zsh plugins and theme configured."

echo "Step 4: Installing productivity CLI tools (tmux, fzf, zoxide, direnv)..."
sudo apt install -y tmux
echo "tmux installed."

echo "Installing fzf..."
sudo apt install -y fzf
echo "fzf installed."

echo "Installing zoxide..."
sudo apt install -y zoxide
echo "zoxide installed."

echo "Installing direnv..."
sudo apt install -y direnv
# Add direnv hook to .zshrc if not already present
grep -q 'eval "$(direnv hook zsh)"' ~/.zshrc || echo 'eval "$(direnv hook zsh)"' >> ~/.zshrc
echo "direnv installed."

echo "Step 5: Git user information setup (TODO)..."
echo "TODO: Please configure your Git user name and email after the script finishes:"
echo "git config --global user.name \"Your Name\""
echo "git config --global user.email \"your.email@example.com\""

echo "Step 6: Installing Docker..."
# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl gnupg -y
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# Add the repository to Apt sources:
echo 
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu 
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | 
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

# Install Docker Engine, containerd, and Docker Compose
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

# Add current user to the docker group
sudo usermod -aG docker $USER
echo "Docker installed and user added to docker group. You may need to log out and back in for group changes to take effect."

echo "Step 7: Installing Node.js ecosystem (nvm, Node.js LTS, npm, Yarn, TypeScript)..."
echo "Installing nvm..."
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash || true

# Source nvm immediately for use in this script
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

if command -v nvm &> /dev/null; then
    echo "nvm installed. Installing latest LTS Node.js..."
    nvm install --lts
    nvm use --lts
    nvm alias default lts/*
    echo "Node.js LTS installed and set as default."

    echo "Updating npm to the latest version..."
    npm install -g npm@latest
    echo "npm updated."

    echo "Installing Yarn..."
    npm install -g yarn
    echo "Yarn installed."

    echo "Installing TypeScript..."
    npm install -g typescript
    echo "TypeScript installed."
else
    echo "Warning: nvm could not be installed or sourced. Skipping Node.js, npm, Yarn, and TypeScript installation."
fi

echo "Step 8: Installing Rust..."
echo "Installing rustup..."
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y || true

# Source cargo environment variables immediately
if [ -f "$HOME/.cargo/env" ]; then
    source "$HOME/.cargo/env"
    echo "Rust environment variables loaded."
    echo "Verifying Rust installation..."
    cargo --version
    rustc --version
else
    echo "Warning: Rust environment file not found. Rust might not have installed correctly."
fi

echo "========================================"
echo "Setup Complete!"
echo "========================================"
echo "Please open a new terminal or run 'source ~/.zshrc' to apply all changes."
echo ""
echo "Manual Post-Installation Steps & Recommendations:"
echo "1. Git User Info: Remember to set your Git user name and email:"
echo "   git config --global user.name \"Your Name\""
echo "   git config --global user.email \"your.email@example.com\""
echo "2. Powerlevel10k: If you wish to use Powerlevel10k, you will need to install and configure it manually."
echo "   (Refer to its official GitHub page for instructions: https://github.com/romkatv/powerlevel10k#oh-my-zsh)"
echo "3. direnv: For direnv to work, you need to 'direnv allow' in directories where you use it."
echo "4. VS Code Remote - WSL: If you use VS Code, ensure the 'Remote - WSL' extension is installed for seamless integration."
echo "5. Docker: Docker is now installed within your WSL2 distribution. You can manage Docker services directly from WSL."
echo ""
echo "Enjoy your new WSL2 development environment!"
