cd /home/ubuntu/DCTM-xCP-16.4.0
sudo docker network create dctm-dev
source documentum-environment.profile
sudo docker-compose -f CS-Docker-Compose_Stateless.yml up -d
sudo docker exec postgres su -c "mkdir /var/lib/postgresql/data/db_documentum_dat.dat" postgres
sudo docker ps
