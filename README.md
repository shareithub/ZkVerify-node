# ZkVerify Node tutorial

u can following this step by step
1. Update & install docker
```
sudo apt update && sudo apt install -y docker.io docker-compose jq sed
```

2. Add user in group docker
```
sudo usermod -aG docker $USER
newgrp docker
```

3. Check docker
```
docker ps
```

4. Create user for Node. u can change "shareithub" to your name node
```
sudo useradd -m -s /bin/bash shareithub
sudo passwd shareithub
sudo usermod -aG docker shareithub
```

5. Login user. your_user change to your create user for node
```
su - shareithub
```

# U CAN CHANGE "shareithub" to your username or other name for step 4 & 5

6. Clone repository
```
git clone https://github.com/zkVerify/compose-zkverify-simplified.git
cd compose-zkverify-simplified
```

7. Start init , and choose Validator Node
```
./scripts/init.sh
```

8. Update Node
```
cd ~/zkverify-repo
git pull
./scripts/update.sh
```

9. Start Node
```
./scripts/start.sh
```

10. Compose your docker. Chaneg " your_user " to your folder
```
docker compose -f /home/your_user/compose-zkverify-simplified/deployments/validator-node/testnet/docker-compose.yml up -d
```

# DONE

#CHECK LOGS
```
docker logs -f validator-node
```

# CHECK YOUR NODE IN :
[CLICK HERE ](https://testnet-telemetry.zkverify.io/#/0xc00425dcaa0a1bc5bf1163a2d69d7abb2cc6180de78b4e10297b31a4d9cc928a)

# Download Wallet Talisman :
[CLICK HERE](https://chromewebstore.google.com/detail/talisman-wallet/fijngjgcjhjmmpcmkeiomlglpeiijkld)

# Claim Faucet :
[CLICK HERE](https://zkverify-faucet.zkverify.io/)


