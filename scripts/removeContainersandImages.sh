param=$1
if [ -z "${param// }" ]
then 
   echo "Please pass image name to remove" 
   exit 1 
fi 
echo Passed Image Name: $param
stripped_param=`echo $param | sed 's/\(:.*\)//'`
echo Without Tag $stripped_param
docker images | grep $stripped_param 
if [ $? -ne 0 ] 
then 
	echo No Such image $param
	exit 1
fi
for i in `docker ps -a | grep $param | cut -d " " -f1` 
do 
	echo Removing container: $i
        docker stop $i 2>&1 >/dev/null 
        docker rm $i 2>&1 >/dev/null 
done 
docker rmi $param 2>&1 /dev/null

