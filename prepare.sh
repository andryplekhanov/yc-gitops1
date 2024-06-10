#!/bin/bash

sudo apt update
sudo apt upgrade -y
sudo apt install unzip -y

# Install terraform
chmod +x ./soft/terraform
sudo cp ./soft/terraform /bin/
sudo cp ./soft/.terraformrc /root/
chown -R $USER:$USER ./soft/.terraformrc

echo '' && echo '------------------------------------------' && echo ''


# Install kubectl
echo "Install kubectl binary with curl on Linux"
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

echo '' && echo '------------------------------------------' && echo ''


# Install Helm
echo "Install Helm"
curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null
sudo apt-get install apt-transport-https --yes
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
sudo apt-get update
sudo apt-get install helm

echo '' && echo '------------------------------------------' && echo ''


# Install helm-secrets plugin
echo "Install helm-secrets plugin"
helm plugin install https://github.com/jkroepke/helm-secrets --version v3.15.0

echo '' && echo '------------------------------------------' && echo ''


# Install YandexCloud CLI
echo "Install YandexCloud CLI"
curl -sSL https://storage.yandexcloud.net/yandexcloud-yc/install.sh | bash

echo '' && echo '------------------------------------------' && echo ''


# Install sops
echo "Install sops"
curl -LO https://github.com/getsops/sops/releases/download/v3.8.1/sops-v3.8.1.linux.amd64
sudo mv sops-v3.8.1.linux.amd64 /usr/local/bin/sops
sudochmod +x /usr/local/bin/sops

echo '' && echo '------------------------------------------' && echo ''


# Install age
echo "Install age"
sudo apt install age

echo '' && echo '------------------------------------------' && echo ''




echo -e "=========================== Версия kubectl =================================="
kubectl version --client
echo -e " "

echo -e "============================= Версия helm ==================================="
helm version
echo -e " "

echo -e "============================= Версия helm secrets ==================================="
helm secrets --version
echo -e " "

echo -e "============================= Версия YandexCloud CLI ==================================="
yc --version
echo -e " "

echo -e "============================= Версия sops ==================================="
sops --version
echo -e " "

echo -e "============================= Версия age ==================================="
age --version
echo -e " "

echo -e "============================= Версия terraform ==================================="
terraform --version
echo -e " "
