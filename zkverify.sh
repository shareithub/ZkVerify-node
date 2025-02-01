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
    apt update && apt install -y docker.io docker-compose-plugin jq sed git
}

# Periksa dan pasang Docker Compose v2 jika belum ada
install_docker_compose() {
    echo "🔄 Memastikan Docker Compose v2 terinstal..."
    if ! docker compose version &>/dev/null; then
        echo "🚨 Docker Compose tidak ditemukan. Menginstal Docker Compose v2..."
        curl -SL https://github.com/docker/compose/releases/latest/download/docker-compose-linux-x86_64 -o ~/.docker/cli-plugins/docker-compose
        chmod +x ~/.docker/cli-plugins/docker-compose
        echo "✅ Docker Compose v2 berhasil diinstal."
    else
        echo "✅ Docker Compose v2 sudah terinstal."
    fi
}

# Tambahkan user yang menjalankan skrip ke grup Docker
setup_docker_user() {
    local user
    user=${SUDO_USER:-$(logname)}  # Gunakan SUDO_USER atau logname jika kosong
    if [ -n "$user" ]; then
        echo "👤 Menambahkan user '$user' ke grup docker..."
        usermod -aG docker "$user"
    else
        echo "⚠️ Tidak dapat menentukan user yang menjalankan skrip."
    fi
}

# Buat user zkverify jika belum ada
create_zkverify_user() {
    if id "zkverify" &>/dev/null; then
        echo "✅ User 'zkverify' sudah ada, lewati pembuatan."
    else
        echo "👤 Membuat user 'zkverify'..."
        useradd -m -s /bin/bash zkverify
        echo "🔑 Silakan atur password untuk user 'zkverify':"
        passwd zkverify
        usermod -aG docker zkverify
    fi
}

# Clone dan jalankan zkVerify jika belum ada
setup_zkverify() {
    sudo -u zkverify bash -c '
        echo "🛠️ Mengatur environment untuk zkVerify..."
        cd ~
        if [ ! -d "compose-zkverify-simplified" ]; then
            git clone https://github.com/zkVerify/compose-zkverify-simplified.git
        fi
        cd compose-zkverify-simplified
        ./scripts/init.sh
        ./scripts/start.sh
    '
}

# Update repo zkVerify jika sudah ada
update_zkverify() {
    sudo -u zkverify bash -c '
        echo "🔄 Memperbarui repository zkVerify..."
        cd ~/compose-zkverify-simplified || exit
        git pull
        ./scripts/update.sh
    '
}

# Menjalankan validator node di testnet
run_validator_node() {
    sudo -u zkverify bash -c '
        echo "🚀 Menjalankan validator node di testnet..."
        docker compose -f ~/compose-zkverify-simplified/deployments/validator-node/testnet/docker-compose.yml up -d
    '
}

# Jalankan semua fungsi
check_root
install_dependencies
install_docker_compose
setup_docker_user
create_zkverify_user
setup_zkverify
update_zkverify
run_validator_node

echo "✅ Instalasi selesai! Silakan keluar dan masuk kembali untuk menerapkan perubahan."
