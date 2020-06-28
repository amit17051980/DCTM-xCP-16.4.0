# Launch Ubuntu-18-LTS 
multipass launch --cpus 4 --disk 60G --mem 6G --name dctm-16-4 lts

# Mount the current directory on to created VM
multipass exec -v dctm-16-4 -- mkdir -p /home/ubuntu/media
multipass mount . dctm-16-4:/home/ubuntu/media

# Clone the project
multipass exec -v dctm-16-4 -- mkdir -p /home/ubuntu/project
multipass exec -v dctm-16-4 -- mkdir -p /home/ubuntu/project

# Login to the VM and clone the project
multipass shell dctm-16-4
cd /home/ubuntu/project
ls -ltr



