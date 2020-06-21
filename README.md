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
# Setup Isolated Network
This network will be used by all the components for inter-communications using hostname instead of IP.

```bash
docker network create dctm-dev
```
# Setup DB (Postgres)

```bash
docker run --network dctm-dev --name postgres --hostname postgres -e POSTGRES_PASSWORD=password -d -p 5432:5432 postgres:9.6
sleep 5s
docker exec postgres su -c "mkdir /var/lib/postgresql/data/db_documentum_dat.dat" postgres
```
# Create Content Server Docker Container
## Upload Content Server Docker Image to Local Registry

```bash
tar -xvf contentserver_docker_ubuntu.tar
docker load -i Contentserver_Ubuntu.tar
docker image ls
```
If you have docker hub account, you are allowed to create 1 private docker repository. You can use this as content server private docker repository. Follow the general gudelines to push above image to your own private docker hub repository, but beware of the licensing t&c while using it this way. 

## Update the YAML file and load Environment variables
Use the <b>'CS-Docker-Compose_Stateless.yml'</b> file, and place right image:tag information in the line below.

**CS-Docker-Compose_Stateless.yml**

```yaml
image: amit17051980/dctm-cs:16.4.0
```
**Environment File**

```bash
export APP_SERVER_PASSWORD=password
export INSTALL_OWNER_PASSWORD=password
export ROOT_PASSWORD=password
export DOCBASE_PASSWORD=password
export DATABASE_PASSWORD=password
export GLOBAL_REGISTRY_PASSWORD=password
export AEK_PASSPHRASE=password
export LOCKBOX_PASSPHRASE=password 
```

## Compose the docker container for Content Server

```bash
docker-compose -f CS-Docker-Compose_Stateless.yml up -d
```

## Wait for 30 minutes and review the log
Based on computer resources, the above compose operation should be completed within 30 minutes.
Check the log as below:

```bash
docker logs -f documentum-cs
```
Once the below lines are shown, try to login to documentum-cs container and review iapi/idql.

<pre>
/opt/dctm_docker/scripts/start_all_services.sh: line 64: kill: (1171) - No such process
UID        PID  PPID  C STIME TTY          TIME CMD
</pre>

```bash
docker exec -it documentum-cs su - dmadmin -c 'idql documentum -udmadmin -pfakepassword'
```

# Install Process Engine
Get the Process Engine tar file (**process_engine_linux.tar**) form Support site and place it to current working directory.
Initialise the silent installation property file (**pe.properties**).

```property
INSTALLER_UI=SILENT
PE.INSTALL_TARGET=/opt/dctm
PE.FQDN=localhost
PE.DOCBASES_ADMIN_USER_NAME=dmadmin
PE.DOCBASES_ADMIN_USER_PASSWORD=password
PROCESS_ENGINE.GLOBAL_REGISTRY_ADMIN_USER_NAME=documentum
PROCESS_ENGINE.SECURE.GLOBAL_REGISTRY_ADMIN_PASSWORD=password
```

Transfer files to Documentum CS container and install the PE:

```bash
docker exec documentum-cs su - dmadmin -c 'mkdir -p /opt/dctm_docker/PE'
docker cp process_engine_linux.tar documentum-cs:/opt/dctm_docker/PE/
docker cp pe.properties documentum-cs:/opt/dctm_docker/PE/
docker exec documentum-cs su - dmadmin -c 'cd /opt/dctm_docker/PE/; tar -xvf process_engine_linux.tar; chmod 775 peSetup.bin'
docker exec documentum-cs su - dmadmin -c 'rm -rf /opt/dctm_docker/PE/process_engine_linux.tar'
docker exec documentum-cs su - dmadmin -c 'cd /opt/dctm_docker/PE/; ./peSetup.bin -f pe.properties'
```

# Create xCP App Container
```bash
docker run --network dctm-dev -d --name documentum-xcp --hostname documentum-xcp -p 8000:8080 amit17051980/dctm-tomcat:latest
docker exec documentum-xcp su -c "cp -r /usr/local/tomcat/webapps.dist/manager /usr/local/tomcat/webapps/"
docker cp context.xml documentum-xcp:/usr/local/tomcat/webapps/manager/META-INF/
docker cp catalina.properties documentum-xcp:/usr/local/tomcat/conf/
docker cp tomcat-users.xml documentum-xcp:/usr/local/tomcat/conf/
docker cp custom-conf documentum-xcp:/usr/local/tomcat/
```

