source documentum-environment.profile
docker-compose -f CS-Docker-Compose_Stateless.yml up -d
docker exec postgres su -c "mkdir /var/lib/postgresql/data/db_documentum_dat.dat" postgres
docker logs -f documentum-cs
