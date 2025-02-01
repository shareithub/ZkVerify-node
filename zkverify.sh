#!/bin/bash

# Banner keren
echo "   ______ _____   ___  ____  __________  __ ____  _____ "
echo "  / __/ // / _ | / _ \/ __/ /  _/_  __/ / // / / / / _ )"
echo " _\ \/ _  / __ |/ , _/ _/  _/ /  / /   / _  / /_/ / _  |"
echo "/___/_//_/_/ |_/_/|_/___/ /___/ /_/   /_//_/\____/____/ "
echo "               ZkVerify NODE                            " 
sleep 3

# Update the package index
echo "Updating package index..."
sudo apt update -y

# Install required dependencies
echo "Installing dependencies..."
sudo apt install apt-transport-https ca-certificates curl software-properties-common git -y

# Add Docker’s official GPG key
echo "Adding Docker's GPG key..."
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Add Docker repository
echo "Adding Docker repository..."
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker
echo "Installing Docker..."
sudo apt update -y
sudo apt install docker-ce docker-ce-cli containerd.io -y

# Verify Docker installation
echo "Verifying Docker installation..."
sudo docker --version

# Install Docker Compose
echo "Installing Docker Compose..."
sudo curl -L "https://github.com/docker/compose/releases/download/$(curl -s https://api.github.com/repos/docker/compose/releases/latest | jq -r .tag_name)/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

# Make Docker Compose executable
echo "Making Docker Compose executable..."
sudo chmod +x /usr/local/bin/docker-compose

# Verify Docker Compose installation
echo "Verifying Docker Compose installation..."
docker-compose --version

# Add user to Docker group and apply the group change
echo "Adding user to the Docker group..."
sudo usermod -aG docker $USER

# Apply new group membership immediately
echo "Applying new group membership..."
newgrp docker

# Create a new user named 'zkverify'
echo "Creating new user 'zkverify'..."
sudo useradd -m -s /bin/bash zkverify

# Set password for 'zkverify'
echo "Setting password for user 'zkverify'..."
sudo passwd zkverify

# Add 'zkverify' user to Docker group
echo "Adding 'zkverify' user to Docker group..."
sudo usermod -aG docker zkverify

# Switch to the 'zkverify' user and navigate to their home directory
echo "Switching to the 'zkverify' user and navigating to their home directory..."
su - zkverify -c "cd ~"

# Clone the repository for zkverify simplified
echo "Cloning the 'compose-zkverify-simplified' repository..."
su - zkverify -c "git clone https://github.com/zkVerify/compose-zkverify-simplified.git"

# Navigate into the cloned repository
echo "Navigating into the cloned repository..."
su - zkverify -c "cd compose-zkverify-simplified"

# Create a new directory for zkverify repo and pull the latest changes
echo "Creating a directory 'zkverify-repo' in the home directory and pulling the latest changes..."
su - zkverify -c "mkdir ~/zkverify-repo && cd ~/zkverify-repo && git pull"

# Run the update and initialization scripts
echo "Running the update and init scripts..."
su - zkverify -c "cd ~/zkverify-repo && ./scripts/update.sh && ./scripts/init.sh"

# Start the system using the start script
echo "Starting the system..."
su - zkverify -c "cd ~/zkverify-repo && ./scripts/start.sh"

# Start the validator node using Docker Compose
echo "Starting the validator node with Docker Compose..."
su - zkverify -c "docker compose -f /home/zkverify/compose-zkverify-simplified/deployments/validator-node/testnet/docker-compose.yml up -d"

echo "Docker and Docker Compose have been successfully installed and configured!"
echo "The user 'zkverify' has been created, added to the Docker group, and the repository has been cloned and initialized."
echo "The validator node has been started using Docker Compose."
