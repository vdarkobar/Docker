#!/bin/bash

######################################################
# Define ANSI escape sequences for colors and reset  #
######################################################
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m' 
NC='\033[0m'

###########################################
# Function for displaying status messages #
###########################################
status_message() {
  local status="$1"  # "success" or "error" or "warning"
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

# Prompt user for confirmation (with input validation loop)
while true; do 
    echo -e "${GREEN}Do you want to install Docker and Docker Compose (v2)? (y/n)${NC}"
    read -r choice
    echo

    if [[ "$choice" == "y" || "$choice" == "Y" ]]; then
        # Update package index
        if sudo apt-get update; then
            echo
            status_message "success" "Updated apt package index."
        else
            status_message "error" "Failed to update apt package index. Aborting."
            exit 1
        fi
        echo

        # Install prerequisites
        if sudo apt-get install -y \
            ca-certificates \
            curl \
            gnupg \
            lsb-release; then
            echo
            status_message "success" "Installed prerequisites."
        else
            status_message "error" "Failed to install prerequisites. Aborting."
            exit 1
        fi
        echo

        # Add Docker GPG key
        if sudo mkdir -p /etc/apt/keyrings && \
            curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg; then
            status_message "success" "Added Docker's official GPG key."
        else
            status_message "error" "Failed to add Docker GPG key. Aborting."
            exit 1 
        fi
        echo

        # Set up Docker repository
        if echo \
            "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
            $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null; then
            status_message "success" "Set up the Docker repository."
        else
            status_message "error" "Failed to set up the Docker repository. Aborting."
            exit 1
        fi
        echo

        # Update package index (again after adding the repository)
        sudo apt-get update
        echo

        # Install Docker and components
        if sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin; then
            echo
            status_message "success" "Installed Docker and Docker Compose."
        else
            status_message "error" "Failed to install Docker. Aborting."
            exit 1
        fi
        echo

        # Verification and test
        status_message "success" "Verifying installation:"
        echo
        sudo docker --version && docker compose version
        sudo systemctl is-enabled docker && sudo systemctl is-enabled containerd
        sudo docker run hello-world

        break # Exit installation logic if successful 

    elif [[ "$choice" == "n" || "$choice" == "N" ]]; then
        status_message "error" "Aborted by user."
        exit 0
    else
        status_message "warning" "Invalid input. Please enter 'y' or 'n'."
    fi
done
