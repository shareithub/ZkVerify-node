#!/bin/bash

# Banner keren
echo "   ______ _____   ___  ____  __________  __ ____  _____ "
echo "  / __/ // / _ | / _ \/ __/ /  _/_  __/ / // / / / / _ )"
echo " _\ \/ _  / __ |/ , _/ _/  _/ /  / /   / _  / /_/ / _  |"
echo "/___/_//_/_/ |_/_/|_/___/ /___/ /_/   /_//_/\____/____/ "
echo "               ZkVerify NODE                            " 
sleep 3

# Update sistem
echo "Updating the system..."
sudo apt update && sudo apt upgrade -y

# Menghapus containerd jika ada konflik
echo "Removing existing containerd package..."
sudo apt-get remove -y containerd

# Membersihkan cache apt dan memperbarui daftar paket
echo "Cleaning apt cache and updating package list..."
sudo apt-get clean
sudo apt-get update

# Install dependensi dan paket tambahan
echo "Installing dependencies and packages..."
sudo apt install -y docker.io docker-compose jq sed

# Menambahkan user ke grup Docker
echo "Adding user to Docker group..."
sudo usermod -aG docker $USER
newgrp docker

# Verifikasi apakah Docker berjalan dengan baik
echo "Verifying Docker installation..."
docker ps

# Membuat user khusus untuk node
echo "Creating zkverify user..."
sudo useradd -m -s /bin/bash zkverify
sudo passwd zkverify
sudo usermod -aG docker zkverify

# Beralih ke user zkverify
echo "Switching to user zkverify..."
su - zkverify -c "
cd ~
echo 'Cloning repository...'
git clone https://github.com/zkVerify/compose-zkverify-simplified.git
cd compose-zkverify-simplified

# Inisialisasi skrip
echo 'Running initialization script...'
./scripts/init.sh
"

# Menyuruh memilih validator-node
echo "Please select the Validator-node during init.sh execution."

# Start node
echo "Starting node..."
su - zkverify -c "
cd ~/compose-zkverify-simplified
./scripts/start.sh
"

# Menjalankan docker-compose untuk validator node
echo "Running Docker Compose to start validator node..."
docker compose -f /home/zkverify/compose-zkverify-simplified/deployments/validator-node/testnet/docker-compose.yml up -d

# Mengupdate node (opsional)
echo "To update node, run the following commands:"
echo "cd ~/zkverify-repo"
echo "git pull"
echo "./scripts/update.sh"

# Selesai
echo "Setup completed successfully."
