#!/bin/bash
cd /home/ubuntu/DCTM-xCP-16.4.0/media-files
sudo docker exec documentum-cs su - dmadmin -c 'mkdir -p /opt/dctm_docker/PE'
sudo docker cp process_engine_linux.tar documentum-cs:/opt/dctm_docker/PE/
sudo docker cp pe.properties documentum-cs:/opt/dctm_docker/PE/
sudo docker exec documentum-cs su - dmadmin -c 'cd /opt/dctm_docker/PE/; tar -xvf process_engine_linux.tar; chmod 775 peSetup.bin'
sudo docker exec documentum-cs su - dmadmin -c 'rm -rf /opt/dctm_docker/PE/process_engine_linux.tar'
echo "Wait for 15 minutes to complete this process. "
echo "{STARTED [`date`]}"
sudo docker exec documentum-cs su - dmadmin -c 'cd /opt/dctm_docker/PE/; ./peSetup.bin -f pe.properties'
echo "{FINISHED [`date`]}"
