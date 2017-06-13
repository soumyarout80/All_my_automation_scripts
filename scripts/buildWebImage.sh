cd /home/edureka/dockerfiles/myapp
param=seshagirisriram/addressbook:$1
# param=seshagirisriram/addressbook:14 
echo PARAM -- $param `pwd`
export DOCKER_HOST=tcp://192.168.1.11:2376
echo "Now setting $DOCKER_HOST"
docker build -t soumya/addressbook:$1 . 
docker run -itd -p 8080:8080 $param
for i in `docker ps -a | grep $param | cut -d " " -f1` 
do 
	echo Started image.... $param
done
