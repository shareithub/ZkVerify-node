#!/bin/bash

# Banner keren
echo "   ______ _____   ___  ____  __________  __ ____  _____ "
echo "  / __/ // / _ | / _ \/ __/ /  _/_  __/ / // / / / / _ )"
echo " _\ \/ _  / __ |/ , _/ _/  _/ /  / /   / _  / /_/ / _  |"
echo "/___/_//_/_/ |_/_/|_/___/ /___/ /_/   /_//_/\____/____/ "
echo "               ZkVerify NODE                            " 
sleep 3

set -e  # Hentikan skrip jika terjadi error
set -o pipefail  # Hentikan jika ada error dalam pipe

# Pastikan skrip dijalankan dengan sudo
check_root() {
    if [ "$(id -u)" -ne 0 ]; then
        echo "🚨 Harap jalankan skrip ini dengan sudo atau sebagai root."
        exit 1
    fi
}

# Instal dependensi yang diperlukan
install_dependencies() {
    echo "🔄 Memperbarui daftar paket dan menginstal dependensi..."
    apt update && apt install -y docker.io docker-compose jq sed
}

# Tambahkan user saat ini ke grup Docker
setup_docker_user() {
    echo "👤 Menambahkan user ke grup docker..."
    usermod -aG docker "$SUDO_USER"
    newgrp docker
}

# Buat user zkverify
create_zkverify_user() {
    echo "👤 Membuat user 'zkverify'..."
    useradd -m -s /bin/bash zkverify
    echo "🔑 Silakan atur password untuk user 'zkverify':"
    passwd zkverify
    usermod -aG docker zkverify
}

# Clone dan jalankan zkVerify
setup_zkverify() {
    su - zkverify <<'EOF'
    echo "🛠️ Mengatur environment untuk zkVerify..."
    cd ~
    git clone https://github.com/zkVerify/compose-zkverify-simplified.git
    cd compose-zkverify-simplified
    ./scripts/init.sh
    ./scripts/start.sh
EOF
}

# Update repo zkVerify jika sudah ada
update_zkverify() {
    su - zkverify <<'EOF'
    echo "🔄 Memperbarui repository zkVerify..."
    cd ~/zkverify-repo
    git pull
    ./scripts/update.sh
EOF
}

# Menjalankan validator node di testnet
run_validator_node() {
    su - zkverify <<'EOF'
    echo "🚀 Menjalankan validator node di testnet..."
    docker compose -f /home/zkverify/compose-zkverify-simplified/deployments/validator-node/testnet/docker-compose.yml up -d
EOF
}

# Jalankan semua fungsi
check_root
install_dependencies
setup_docker_user
create_zkverify_user
setup_zkverify
update_zkverify
run_validator_node

echo "✅ Instalasi selesai! Silakan keluar dan masuk kembali untuk menerapkan perubahan."
