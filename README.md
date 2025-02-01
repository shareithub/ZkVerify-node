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

4. Create user for Node
```
sudo useradd -m -s /bin/bash shareithub
sudo passwd shareithub
sudo usermod -aG docker shareithub
```

5. Login user Zkverify
```
su - zkverify
```

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



