## installing Docker on a Ubuntu machine
# Perform  updates.... 
	sudo apt-get update
	# install core certificates
	sudo apt-get install -y apt-transport-https ca-certificates
	# Add repository
	sudo apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
	echo "deb https://apt.dockerproject.org/repo ubuntu-trusty main"| sudo tee /etc/apt/sources.list.d/docker.list
	sudo apt-get update
# verify it's getting correctly 
apt-cache policy docker-engine
# install extra packages required for docker
sudo apt-get install -y linux-image-extra-$(uname -r) linux-image-extra-virtual
# Install docker 
sudo apt-get install -y docker-engine
# if you are experiencing network issues, disable them
iptables -F
iptables -Z
iptables -L 
#Alternatively set up docker to --iptables=FALSE 
# if you also have UFW, disable - use either UFW or IPTABLE not both
sudo ufw disable
# Start the service 
sudo service docker start
sudo docker run hello-world
# edit /etc/default/docker and make it run on differnt port
# set DOCKER_HOST in /etc/profile and restart server

