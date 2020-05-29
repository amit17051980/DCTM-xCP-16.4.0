# Assumptions

1. CentOS 7/8 VM is installed with all updates
2. OpneText Documentum is accessible and available to download
3. Little knowledge on Docker and Documentum has been gained
4. Private/Local Docker Registry to upload content server docker image

Please follow the guide below. If Docker and Docker Compose are already setup/available, please ignore the 'Docker Setup on CentOS 7/8' section.

# Docker Setup on CentOS 7/8
## Install Docker using Admin user

```bash
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo yum install docker-ce docker-ce-cli containerd.io
sudo systemctl enable docker
sudo systemctl start docker
sudo usermod -aG docker $LOGNAME
```
## Install Docker Bash Completion

```bash
sudo yum install bash-completion bash-completion-extras
sudo curl -L https://raw.githubusercontent.com/docker/compose/1.25.5/contrib/completion/bash/docker-compose -o /etc/bash_completion.d/docker-compose
```
## Install Docker Compose

```bash
sudo curl -L "https://github.com/docker/compose/releases/download/1.25.5/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
```
# Upload Content Server Docker Image to Local Registry

```bash
tar -xvf contentserver_docker_ubuntu.tar
docker load -i Contentserver_Ubuntu.tar
docker image ls
```
If you have docker hub account, you are allowed to create 1 private docker repository. You can use this as content server private docker repository. Follow the general gudelines to push above image to your own private docker hub repository, but beware of the licensing t&c while using it this way. 

# Clone the project and update the YAML file
Use the <b>'CS-Docker-Compose_Stateless.yml'</b> file, and place right image:tag information in the line below.

```yaml
image: amit17051980/dctm-cs:16.4.0
```
