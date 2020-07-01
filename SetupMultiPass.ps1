# Launch Ubuntu-18-LTS 
multipass launch --cpus 4 --disk 60G --mem 6G --name dctm-16-4 lts

# Mount the current directory on to created VM
multipass exec -v dctm-16-4 -- mkdir -p /home/ubuntu/media
multipass mount . dctm-16-4:/home/ubuntu/media

# Clone the project 
$user = read-host -Prompt "Enter GitHub User Name: "
$pass = Read-Host -Prompt "Enter GitHub Password: " -AsSecureString

multipass exec -v dctm-16-4 -- git config --global credential.helper store
multipass exec -v dctm-16-4 -- git clone https://${user}:${pass}@github.com/amit17051980/DCTM-xCP-16.4.0.git

# Install Docker & Docker Compose
multipass exec -v dctm-16-4 -- sudo snap install docker

# Compose Documentum DB, CS
$user = read-host -Prompt "Enter DockerHub User Name: "
$pass = Read-Host -Prompt "Enter DockerHub Password: "

multipass exec -v dctm-16-4 -- sudo docker login -u ${user} -p ${pass}
multipass exec -v dctm-16-4 -- bash -c ~/DCTM-xCP-16.4.0/SetupCS.sh

echo "Waiting for Documntum Server to intialise in next 30 minutes. "
echo "But, if you killed the process by accident, run the command below to decide the next step"
echo ""
echo ":===> multipass exec -v dctm-16-4 -- sudo docker exec -it documentum-cs su - dmadmin -c 'idql documentum -udmadmin -pfakepassword'"
echo ""
echo "If you see below prompt, it means you are ready to go to next step. Run the script."
echo ""
echo "Connected to OpenText Documentum Server running Release 16.4.0000.0248  Linux64.Postgres"
echo "1>"
echo ""
echo "SCRIPT (Next Steps)"
echo ":===> multipass exec -v dctm-16-4 -- bash -c ~/DCTM-xCP-16.4.0/Setup.sh"
echo ":===> multipass exec -v dctm-16-4 -- bash -c ~/DCTM-xCP-16.4.0/SetupApp.sh"

# Copy Process Engine TAR file to be used in next steps.
multipass exec -v dctm-16-4 -- cp media/Downloads/process_engine_linux.tar DCTM-xCP-16.4.0/media-files/

Start-Sleep -Seconds 1800

# Install Process Engine
multipass exec -v dctm-16-4 -- bash -c ~/DCTM-xCP-16.4.0/SetupPE.sh

# Setup xCP App Container
multipass exec -v dctm-16-4 -- bash -c ~/DCTM-xCP-16.4.0/SetupApp.sh

# Setup DA App Container
multipass exec -v dctm-16-4 -- bash -c ~/DCTM-xCP-16.4.0/SetupDA.sh

# Clone the project
multipass shell dctm-16-4
ls -ltr

