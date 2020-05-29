# Assumptions

1. CentOS 7/8 VM is installed with all updates
2. OpneText Documentum is accessible and available to download
3. Little knowledge on Docker and Documentum has been gained
4. Private/Local Docker Registry to upload content server docker image

Please follow the guide below. If Docker and Docker Compose are already setup/available, please ignore the 'Docker Setup on CentOS 7/8' section.

# Docker Setup on CentOS 7/8
## Install Docker using Admin user

```
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo yum install docker-ce docker-ce-cli containerd.io
sudo systemctl enable docker
sudo systemctl start docker
sudo usermod -aG docker $LOGNAME
```
## Install Docker Bash Completion

```
sudo yum install bash-completion bash-completion-extras
sudo curl -L https://raw.githubusercontent.com/docker/compose/1.25.5/contrib/completion/bash/docker-compose -o /etc/bash_completion.d/docker-compose
```
## Install Docker Compose

```
sudo curl -L "https://github.com/docker/compose/releases/download/1.25.5/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
```
# Upload Content Server Docker Image to Local/Private Registry

