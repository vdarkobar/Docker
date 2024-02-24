#!/bin/bash

clear

######################################################
# Define ANSI escape sequences for colors and reset  #
######################################################
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

###########################################
# Function for displaying status messages #
###########################################
status_message() {
  local status="$1"  # "success", "error", or "warning"
  local message="$2"
  local color="${GREEN}" # Default to success (green)

  if [[ $status == "error" ]]; then
    color="${RED}"
  elif [[ $status == "warning" ]]; then
    color="${YELLOW}"
  fi

  echo -e "${color}${message}${NC}"
}

###########################
# Main installation logic #
###########################
echo -e "${GREEN}Do you want to install Docker and Docker Compose(v2) or Podman and Podman compose?${NC} (Enter 'docker', 'podman', or 'n' to skip):"
read -r choice
echo

case $choice in
  docker)
    # Docker installation logic
    echo -e "${GREEN}Installing Docker and Docker Compose (v2)...${NC}"
    sudo apt-get update || status_message "warning" "Failed to update apt package index; attempting to continue."
    sudo apt-get install -y ca-certificates curl gnupg lsb-release || status_message "warning" "Failed to install prerequisites; attempting to continue."
    sudo mkdir -p /etc/apt/keyrings && curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg || status_message "warning" "Failed to add Docker GPG key; attempting to continue."
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null || status_message "warning" "Failed to set up the Docker repository; attempting to continue."
    sudo apt-get update || status_message "warning" "Failed to update package index after setting up the repository; attempting to continue."
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin || status_message "warning" "Failed to install Docker; attempting to continue."
    sudo docker --version && docker compose version || status_message "warning" "Docker installation might have issues."
    ;;
  podman)
    # Podman and podman-compose installation logic
    echo -e "${GREEN}Installing Podman and podman-compose (if available)...${NC}"
    echo
    sudo apt-get update || status_message "warning" "Failed to update apt package index; attempting to continue."
    # Attempt to install podman and podman-compose together
    sudo apt-get install -y podman podman-compose || status_message "warning" "Failed to install Podman or podman-compose; attempting to continue."
    podman --version || status_message "warning" "Podman installation might have issues."
    # If podman-compose is installed via apt, this check is unnecessary. If not, consider alternative installation methods.
    ;;
  *)
    # Skip installation
    status_message "warning" "Skipping installation."
    ;;
esac
