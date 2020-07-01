# Launch Ubuntu-18-LTS 
multipass launch --cpus 4 --disk 60G --mem 6G --name dctm-16-4 lts

# Handling halt issue in Visual Studio PowerShell Terminal.
$handle = Read-Host "Virtual machine has been provisioned..... Hit Return to continue"
Write-Output $handle

# Mount the current directory on to created VM
multipass exec -v dctm-16-4 -- bash -c 'mkdir -p /home/ubuntu/media'
multipass mount . dctm-16-4:/home/ubuntu/media

# Clone the project 
$user = Read-Host "Enter GitHub User Name: "
$pass = Read-Host "Enter GitHub Password: " -AsSecureString
Write-Output $pass

multipass exec -v dctm-16-4 -- git config --global credential.helper store
multipass exec -v dctm-16-4 -- git clone https://${user}:${pass}@github.com/amit17051980/DCTM-xCP-16.4.0.git

# Install Docker & Docker Compose
multipass exec -v dctm-16-4 -- sudo snap install docker

# Compose Documentum DB, CS
$user = read-host "Enter DockerHub User Name: "
$pass = Read-Host "Enter DockerHub Password: " -AsSecureString

multipass exec -v dctm-16-4 -- sudo docker login -u ${user} -p ${pass}

# Setup Content Server
multipass exec -v dctm-16-4 -- bash ~/DCTM-xCP-16.4.0/SetupCS.sh

Write-Output "=============Content Server is being provisioned=================="
Write-Output "ETA : 30 minutes. "
Write-Output "=================================================================="
Write-Output "If you want to kill the current process, you can, but run the command below after setup verification."
Write-Output ""
Write-Output "..........Verification Step............."
Write-Output ":===> multipass exec -v dctm-16-4 -- sudo docker exec -it documentum-cs su - dmadmin -c 'idql documentum -udmadmin -pfakepassword'"
Write-Output "........................................"
Write-Output "If you see 1> then you are good to go."
Write-Output ""
Write-Output "............SCRIPT (Next Steps)..........."
Write-Output ":===> multipass exec -v dctm-16-4 -- bash -c ~/media/DCTM-xCP-16.4.0/Setup.sh"
Write-Output ":===> multipass exec -v dctm-16-4 -- bash -c ~/media/DCTM-xCP-16.4.0/SetupApp.sh"
Write-Output ":===> multipass exec -v dctm-16-4 -- bash -c ~/media/DCTM-xCP-16.4.0/SetupDA.sh"

Start-Sleep -Seconds 1800s

# Install Process Engine
multipass exec -v dctm-16-4 -- bash -c 'chmod 775 ~/DCTM-xCP-16.4.0/SetupPE.sh && ~/DCTM-xCP-16.4.0/SetupPE.sh'

# Setup xCP App Container
multipass exec -v dctm-16-4 -- bash -c 'chmod 775 ~/DCTM-xCP-16.4.0/SetupApp.sh && ~/DCTM-xCP-16.4.0/SetupApp.sh'

# Setup DA App Container
multipass exec -v dctm-16-4 -- bash -c 'chmod 775 ~/DCTM-xCP-16.4.0/SetupDA.sh && ~/DCTM-xCP-16.4.0/SetupDA.sh'

# Login to the Virtual MAchine
multipass shell dctm-16-4
