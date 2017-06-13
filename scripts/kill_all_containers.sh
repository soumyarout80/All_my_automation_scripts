for i  in `docker ps -a | tail -n +2 | cut -d " " -f1`
do
	echo Stopping Container id $i 
	docker stop $i 2>&1 > /dev/null
	docker rm $i 2>&1 > /dev/null
done 
