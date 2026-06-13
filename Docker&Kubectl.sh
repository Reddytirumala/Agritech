#!bin/bash

#................Jenkines Installation.........................
# 1. Install Java (Jenkins requires Java)
sudo apt update -y
sudo apt install fontconfig openjdk-21-jre -y

# 2. Add the official Jenkins repository GPG key
sudo wget -O /etc/apt/keyrings/jenkins-keyring.asc https://pkg.jenkins.io/debian/jenkins.io-2026.key

# 3. Add the Jenkins APT repository
echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian binary/" | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null

# 4. Update the package index and install Jenkins
sudo apt update -y
sudo apt install jenkins -y

# 5. Start and enable the Jenkins service
sudo systemctl start jenkins
sudo systemctl enable jenkins

#...........................Install Docker Engine.......................
# Add Docker's official GPG key:
sudo apt update -y
sudo apt install ca-certificates curl -y
sudo install -m 0755 -d /etc/apt/keyrings 
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
sudo tee /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")
Components: stable
Architectures: $(dpkg --print-architecture)
Signed-By: /etc/apt/keyrings/docker.asc
EOF

sudo apt update -y
sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
sudo usermod -aG docker ubuntu

#.........................Kubectl Cli install....................

# Install kubectl binary with curl on Linux- Download the latest release with the command: 
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
#Validate the binary (optional)
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"
echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check
#------Install kubectl---
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
kubectl version --client
sudo apt-get update -y

#-----------------Install------Terraform--------------
wget -O - https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(grep -oP '(?<=UBUNTU_CODENAME=).*' /etc/os-release || lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install terraform -y


