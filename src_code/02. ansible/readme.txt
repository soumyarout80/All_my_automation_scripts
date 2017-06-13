to run, navigate to the folder where you have copied bothe deploy.yml and install_nginx.yml 
Run the command in the ansible server location
	ansible-playbook -b --become-user root deploy.yml
This assumes that 
	you have created a group called webservers in /etc/ansible/hosts
        Connectivity to these servers have been properly established. 