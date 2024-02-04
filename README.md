<p align="left">
  <a href="https://github.com/vdarkobar/Home-Cloud#self-hosted-cloud">Home</a>
</p>  
  
# Docker
Install Docker and Docker compose (v2)

### Add free space to cloned VM:  
> *VM Name > Hardware > Hard Disk > Disk Action > Resize*  
  
### *Run this command*:
```
clear
sudo apt -y install git && \
RED='\033[0;31m'; NC='\033[0m'; echo -ne "${RED}Enter directory name: ${NC}"; read NAME; mkdir -p "$NAME"; \
cd "$NAME" && git clone https://github.com/vdarkobar/Bastion.git . && \
chmod +x setup.sh && \
rm README.md && \
./setup.sh
```
