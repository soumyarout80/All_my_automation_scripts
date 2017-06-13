sudo apt-get purge -y maven maven2 && sudo apt-get -y autoremove
# Add maven 3 repository 
sudo apt-add-repository -y ppa:andrei-pozolotin/maven3
sudo apt-get update 
# install maven 3 (Ensure JDK8 is installed first see below) 
sudo apt-get install -y maven3 