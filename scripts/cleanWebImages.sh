export DOCKER_HOST=tcp://192.168.1.11:2376
username=$1 
password=$2
docker login -u $username -p $password
if [ $? -ne 0 ] 
then 
	echo "failed to connect to DockerHub" 
	exit 1
fi 
appname=$3
tagnumber=$4 
if [ -z "${appname// }" ]
then 
   echo "Please pass image name to  pass" 
   exit 1 
fi 
echo Passed Image Name: $appname
docker images | grep $appname
if [ $? -ne 0 ] 
then 
	echo No Such image $appname
	exit 1
fi
for i in `docker ps -a | grep "$appname:$tagnumber"| cut -d " " -f1`
do 
		echo removing Container ... $i
		docker stop $i 2>&1 >/dev/null
		docker rm $i 2>&1 >/dev/null
done 

docker tag $username/$appname $username/$appname:$tagnumber 
docker push $username/$appname:$tagnumber
docker push $username/$appname
# Your call -- Do you want to keep all of this.. ?
# Probably not.. 
docker rmi $username/$appname:$tagnumber 
docker pull $username/$appname
#docker rmi $param 2>&1 /dev/null

