## Gemini Added Memories
- [여기에 전역 지침을 입력하세요]
- My name is 규연.

## Development Environment Setup (Docker & Kubernetes on Windows)

This section summarizes key configurations and solutions for setting up a development environment using Docker and Kubernetes on Windows.

### 1. Unified Setup & Update Script (`develop-setup.bat`)
- **Purpose:** A single script to handle both the initial setup of the development environment and subsequent updates.
- **Key Features:**
  - **Prerequisite Checks:** On first run, it checks for essential tools like WSL and Docker Desktop and provides installation guidance.
  - **Dynamic Configuration via `.env`:** Reads `APP_NAME` and `DEV_HOST_PATH` from a `.env` file to dynamically configure the environment.
  - **Automated Build & Deploy:** Automates the Docker image build and Kubernetes deployment process.
  - **Idempotent:** The script can be run multiple times safely. It creates new resources if they don't exist and updates them if they do.

### 2. Dynamic Configuration (`k8s-deployment.yaml` & `.env`)
- **`k8s-deployment.yaml` as a Template:** The file uses placeholders like `##APP_NAME##` and `##DEV_HOST_PATH##`.
- **`.env` for Customization:** All environment-specific variables are stored in the `.env` file (which should be in `.gitignore`).
  - `APP_NAME`: Defines the base name for Docker images, Kubernetes deployments, services, and secrets (e.g., `dev-server`).
  - `DEV_HOST_PATH`: Specifies the absolute path to the project directory on the host machine (e.g., `C:\Users\lurain\dev`).

### 3. Kubernetes `hostPath` on Docker Desktop (Windows)
- **The Challenge:** Mounting a host directory into a Kubernetes pod requires a specific path format when using Docker Desktop on Windows.
- **The Solution:** The `develop-setup.bat` script automatically converts the standard Windows path from `.env` into the required format.
  - **Original Path:** `C:\Users\lurain\dev`
  - **Converted Path:** `/run/desktop/mnt/host/c/Users/lurain/dev`
- **Implementation:** This conversion is handled within the batch script before `kubectl apply` is executed.

### 4. Accessing the Kubernetes Pod
- **The Command:** Since the container is managed by Kubernetes, `docker exec` cannot be used directly.
- **Correct Method:** Use `kubectl exec` to get a shell inside the running pod.
  ```bash
  kubectl exec -it deployment/your-app-name -- /bin/bash
  ```
  (Replace `your-app-name` with the `APP_NAME` from your `.env` file).

---
*Previous notes on `docker run` and other topics have been superseded by the unified Kubernetes setup but are kept below for historical reference.*

### 5. Dockerfile Configuration
- **Purpose:** To create a development container image with necessary tools (Node.js, Rust, Docker CLI, Kubectl, Gemini CLI).
- **Key Features:**
  - `EXPOSE 3000`: Declares that the container listens on port 3000 (for web applications).
  - Installation of `docker-ce-cli` and `kubectl` within the container.

### 6. Gemini API Key Management
- **Security:** Never hardcode API keys in `Dockerfile` or commit them to Git.
- **Recommended Method:** Use a `.env` file (e.g., `GEMINI_API_KEY=YOUR_KEY`) in the project root, add `.env` to `.gitignore`, and the setup script will automatically create a Kubernetes secret from it.