# Base image: Ubuntu Latest
FROM ubuntu:latest

# Set non-interactive frontend to avoid prompts during installation
ENV DEBIAN_FRONTEND=noninteractive

# Set working directory
WORKDIR /root/dev

# Install base dependencies and add Docker's official GPG key
RUN apt-get update && apt-get install -y ca-certificates curl gnupg git wget
RUN install -m 0755 -d /etc/apt/keyrings
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
RUN chmod a+r /etc/apt/keyrings/docker.gpg

# Add Docker repository to Apt sources
RUN echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Node.js (LTS version)
RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash -

# Install Rust toolchain
ENV RUSTUP_HOME=/usr/local/rustup \
    CARGO_HOME=/usr/local/cargo \
    PATH=/usr/local/cargo/bin:$PATH
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

# Install Docker CLI, Kubectl, Node.js, and Gemini CLI
RUN apt-get update && apt-get install -y \
    docker-ce-cli \
    nodejs \
    && rm -rf /var/lib/apt/lists/*
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
    install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# Install code-server
RUN curl -fsSL https://code-server.dev/install.sh | sh

RUN npm install -g @google/gemini-cli

# Expose port 3000 for web applications and 8080 for code-server
EXPOSE 3000
EXPOSE 8080

# Set a default command to keep the container running
CMD ["code-server", "--bind-addr", "0.0.0.0:8080", "--auth", "none", "/root/dev"]
