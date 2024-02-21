#!/bin/bash

######################################################
# Define ANSI escape sequence for green and red font #
######################################################
GREEN='\033[0;32m'
RED='\033[0;31m'

########################################################
# Define ANSI escape sequence to reset font to default #
########################################################
NC='\033[0m'

# Prompt user for confirmation in green font
echo -e "${GREEN}Do you want to install Docker and Docker compose (v2)? (y/n)${NC}"
read choice
echo

# Check if user entered "y" or "Y"
if [[ "$choice" == [yY] ]]; then

  # Execute first command and echo -e message when done
  echo -e "${GREEN}Update the apt package index and install packages to allow apt to use a repository over HTTPS${NC}"
  sudo apt-get update
  sudo apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
  echo -e "${GREEN}Done.${NC}"
  echo
  sleep 0.5 # delay for 0.5 seconds

  # Execute second and echo -e message when done
  echo -e "${GREEN}Add Docker’s official GPG key${NC}"
  sudo mkdir -p /etc/apt/keyrings
  curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
  echo -e "${GREEN}Done.${NC}"
  echo
  sleep 0.5 # delay for 0.5 seconds

  # Execute third command and echo -e message when done
  echo -e "${GREEN}Using the following command to set up the repository${NC}"
  echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
    $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  echo -e "${GREEN}Done.${NC}"
  echo
  sleep 0.5 # delay for 0.5 seconds

  # Execute fourth command and echo -e message when done
  echo -e "${GREEN}Updating the apt package index${NC}"
  sudo apt-get update
  echo -e "${GREEN}Done.${NC}"
  echo
  sleep 0.5 # delay for 0.5 seconds

  # Execute fifth command and echo -e message when done
  echo -e "${GREEN}Installing the latest version${NC}"
  sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
  echo -e "${GREEN}Done.${NC}"
  echo
  sleep 0.5 # delay for 0.5 seconds

  # Execute sixth command and echo -e message when done
  echo -e "${GREEN}Verify that the Docker Engine installation is successful${NC}"
  sudo docker --version && docker compose version
  sleep 0.5 # delay for 0.5 seconds
  sudo systemctl is-enabled docker && \
  sudo systemctl is-enabled containerd
  sleep 0.5 # delay for 0.5 seconds
  sudo docker run hello-world
  sleep 0.5 # delay for 0.5 seconds
  echo -e "${GREEN}Done.${NC}"
  echo

else
  # User did not confirm, exit with message
  echo -e "${RED}Aborted by user.${NC}"
  echo
  exit 0
fi
