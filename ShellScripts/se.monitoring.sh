
#!/bin/bash


#############################################################################################
#Script for Down-percentage,Disc-Usage,Logremove,Version-Mismatch,Detail-Status of all cluster
##############################################################################################



##########################################
#Input Variables for cluster name and action
#########################################

var="$1"
var1="$2"

###########################################
#Print how to use script
##########################################

usage()
{
echo "sh scriptname.sh  [[clustername like [aggregator] [electronicshigh] [electronicslow] [lifestyle] [books] [internal-aggregator] [internal-electronicshigh] [internal-electronicslow] [internal-lifestyle] [internal-books] [ etc.]] [[action like [detail] [logremove] [down]]"
}

##########################################
#Declaring function for version mismatch
#########################################

version_mismatch(){
if [ "$var" = "electronicslow" ]||[ "$var" = "electronicshigh" ]|| [ "$var" = "lifestyle" ] || [ "$var" = "books" ]||[ "$var" = "internal-electronicslow" ]||[ "$var" = "internal-electronicshigh" ]|| [ "$var" = "internal-lifestyle" ] || [ "$var" = "internal-books" ]
then

parallel-ssh -t 0 -O StrictHostKeyChecking=no --user soumya.rout -iH "`cat ~/iplist|grep -A3 "$1$"|grep "primary_ip"|grep -o '[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*'|tr "\n" " "`"  "dpkg -l | grep dk-webapp-solr | awk '{print \$3}'" > ~/timeout
elif  [ "$var" = "hudson" ]||[ "$var" = "internal-hudson" ]||[ "$var" = "hudson-precomput" ]
then
parallel-ssh -t 0 -O StrictHostKeyChecking=no --user soumya.rout -iH "`cat ~/iplist|grep -A3 "$1$"|grep "primary_ip"|grep -o '[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*'|tr "\n" " "`"  "dpkg -l | grep dk-w3-hudson | awk '{print \$3}'" > ~/timeout
else
parallel-ssh -t 0 -O StrictHostKeyChecking=no --user soumya.rout -iH "`cat ~/iplist|grep -A3 "$1$"|grep "primary_ip"|grep -o '[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*'|tr "\n" " "`"  "dpkg -l | grep dk-w3-webapp | awk '{print \$3}'" > ~/timeout
fi
cat ~/timeout|tr "\n" "\t"|tr "[" "\n"|grep "SUCCESS"|awk '{print $2"\t"$3}'|awk '{if ($2!="") print $0}'|sort -k2>~/ip3
cat ~/timeout|tr "\n" "\t"|tr "[" "\n"|grep "SUCCESS"|awk '{print $2"\t"$3}'|awk '{if ($2!="") print $0}'|awk '{print $2}'|sort|uniq -c >~/ip5
a=`cat ~/ip5|wc -l|awk '{print $1}'`
if [ "$a" -gt 1 ]
then
cat ~/timeout|tr "\n" "\t"|tr "[" "\n"|grep "SUCCESS"|awk '{print $3}'|sort|uniq -c|awk '{print $2}' >~/ip1
for i in `cat ~/ip1`
do

echo "<B>Version:$i installed  on:`grep "$i" ~/ip3|wc -l|awk '{print $1}'` machines</B><br>"
echo "<B>Cluster name:$var and Group name:$1</B><br>"
echo "ip:`grep "$i" ~/ip3|awk '{print $1}'|tr "\n" ","|sed 's/.$//'`<br><br>"

done
fi

}

##############################################################################
#Declaring function for Down percentage for all cluster except Redish-Cluster 
##############################################################################


down(){

> ~/downboxes
a="0"
if [ "$var" = "internal-electronicshigh" ] || [ "$var" = "internal-electronicslow" ] || [ "$var" = "internal-lifestyle" ] || [ "$var" = "internal-books" ]
then
var3=`curl -fSsl "http://10.47.1.95:25290/hudson/v1/webapp/nodes/internal-aggregator"|tr "," "\n"|grep -E -o '[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*'|head -1`
var_json=`curl -fSsl "http://$var3:25280/webapp/v1/sharded/nodes"|tr "," "\n"|tr -d '{'OR'}'OR'"'OR'['OR']'|sed -n "/\<$1\>/,/shard/p"|sed  '$ d'|grep -o '[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*'|wc -l`
curl -fSsl "http://$var3:25280/webapp/v1/sharded/nodes"|tr "," "\n"|tr -d '{'OR'}'OR'"'OR'['OR']'|sed -n "/\<$1\>/,/shard/p"|sed  '$ d'|grep -o '[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*' > ~/file2
var_file=`cat ~/file2|wc -l`
d=`cat ~/iplist|grep -A3 "$2$"|grep "primary_ip"|grep -o '[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*'|wc -l`
cat ~/iplist|grep -A3 "$2$"|grep "primary_ip"|grep -o '[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*'> ~/file1
var_ip=`cat ~/iplist|grep -A3 "$2$"|grep "primary_ip"|grep -o '[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*'|wc -l`
elif [ "$var" = "aggregator" ]
then
var_json=`curl -fSsl "http://10.47.1.159:25290/hudson/v1/webapp/nodes/aggregator"|tr "," "\n"|grep -E -o '[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*'|wc -l`
curl -fSsl "http://10.47.1.159:25290/hudson/v1/webapp/nodes/aggregator"|tr "," "\n"|grep -E -o '[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*' >~/file2
var_file=`cat ~/file2|wc -l`
cat ~/iplist|grep -A2 "$1$"|grep -o '[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*'> ~/file1
d=`cat ~/iplist|grep -A2 "$1$"|grep -o '[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*'|wc -l`
var_ip=`cat ~/iplist|grep -A2 "$1$"|grep -o '[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*'|wc -l`
elif [ "$var" = "internal-aggregator" ]
then
var_ip=`cat ~/iplist|grep -A2  "$1$"|grep "primary_ip"|grep -o '[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*'|wc -l`
var_json=`curl -fSsl "http://10.47.1.95:25290/hudson/v1/webapp/nodes/internal-aggregator"|tr "," "\n"|grep -E -o '[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*'|wc -l`
curl -fSsl "http://10.47.1.95:25290/hudson/v1/webapp/nodes/internal-aggregator"|tr "," "\n"|grep -E -o '[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*' >~/file2
var_file=`cat ~/file2|wc -l`
cat ~/iplist|grep -A2 "$1$"|grep "primary_ip"|grep -o '[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*'> ~/file1
d=`cat ~/iplist|grep -A2  "$1$"|grep "primary_ip"|grep -o '[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*'|wc -l`
var_ip=`cat ~/iplist|grep -A2  "$1$"|grep "primary_ip"|grep -o '[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*'|wc -l`
elif [ "$var" = "hudson" ]||[ "$var" = "internal-hudson" ]
then
var_json=`curl -fSsl "http://10.47.1.159:25290/hudson/v1/members"|tr "," "\n"|grep -E -o '[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*'|wc -l`
curl -fSsl "http://10.47.1.159:25290/hudson/v1/members"|tr "," "\n"|grep -E -o '[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*' >~/file2
var_file=`cat ~/file2|wc -l`
cat ~/iplist|grep -A3 "$1$"|grep "primary_ip"|grep -o '[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*'> ~/file1
d=`cat ~/iplist|grep -A3 "$1$"|grep "primary_ip"|grep -o '[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*'|wc -l`
var_ip=`cat ~/iplist|grep -A3 "$1$"|grep "primary_ip"|grep -o '[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*'|wc -l`
elif [ "$var" = "rols" ]
then
#curl -fSsl "http://10.47.1.159:25290/hudson/v1/webapp/nodes/rols-sharded/"|tr "," "\n" |tr -d '"'OR':'OR'{'OR'}'|grep -B2 "nodeData"|grep -B2 "nodeDatabucketId0|grep -E -o '[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*'">~/file2
var_json=`curl -fSsl "http://10.47.1.159:25290/hudson/v1/webapp/nodes/rols-sharded"|tr "," "\n"|grep -E -o '[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*'|wc -l`
var_ip=`cat ~/iplist|grep -A2 "$1$"|grep "primary_ip"|grep -o '[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*'|wc -l`
cat ~/iplist|grep -A2 "$1"|grep "primary_ip"|grep -o '[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*'> ~/file1
curl -fSsl "http://10.47.1.159:25290/hudson/v1/webapp/nodes/rols-sharded"|tr "," "\n"|grep -E -o '[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*' >~/file2
var_file=`cat ~/file2|wc -l`
d=`cat ~/iplist|grep -A2 "$1$"|grep "primary_ip"|grep -o '[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*'|wc -l`

elif [ "$var" = "completion" ]
then
var_json=`curl -fSsl "http://10.47.1.159:25290/hudson/v1/webapp/nodes/completions"|tr "," "\n"|grep -E -o '[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*'|wc -l`
var_ip=`cat ~/iplist|grep -A3 "$1$"|grep "primary_ip"|grep -o '[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*'|wc -l`
cat ~/iplist|grep -A3 "$1"|grep "primary_ip"|grep -o '[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*'> ~/file1
curl -fSsl "http://10.47.1.159:25290/hudson/v1/webapp/nodes/completions"|tr "," "\n"|grep -E -o '[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*'>~/file2
var_file=`cat ~/file2|wc -l`
d=`cat ~/iplist|grep -A3 "$1$"|grep "primary_ip"|grep -o '[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*'|wc -l`

else
d=`cat ~/iplist|grep -A2  "$2$" |grep "primary_ip"|grep -o '[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*'|wc -l`
var3=`curl -fSsl "http://10.47.1.159:25290/hudson/v1/webapp/nodes/aggregator"|tr "," "\n"|grep -E -o '[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*'|head -1`
var_json=`curl -fSsl "http://$var3:25280/webapp/v1/sharded/nodes"|tr "," "\n"|tr -d '{'OR'}'OR'"'OR'['OR']'|sed -n "/\<$1\>/,/shard/p"|sed  '$ d'|grep -o '[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*'|wc -l`
curl -fSsl "http://$var3:25280/webapp/v1/sharded/nodes"|tr "," "\n"|tr -d '{'OR'}'OR'"'OR'['OR']'|sed -n "/\<$1\>/,/shard/p"|sed  '$ d'|grep -o '[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*' > ~/file2
var_file=`cat ~/file2|wc -l`
cat ~/iplist|grep -A2 "$2$"|grep "primary_ip"|grep -o '[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*'> ~/file1
var_ip=`cat ~/iplist|grep -A2  "$2$" |grep "primary_ip"|grep -o '[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*'|wc -l`
fi
if [ "$var_json" -ne  "$var_ip" -a "$var_json" -gt  "$a" -a "$var_json" -eq "$var_file" ]
then
for i in `cat ~/file1`
do
if  grep "$i" ~/file2 > /dev/null 2>&1
then
echo"" > /dev/null 2>&1
else
echo "$i" >> ~/downboxes
fi
done
w=`expr $d - $var_json`
exp1=`expr $w \* 100 \/ $d`
echo -n "<textarea rows="3" cols="100"> $exp1% ";echo "DOWN `cat ~/downboxes|tr "\n" ","|sed 's/.$//'`:$var:$1</textarea>"
#echo  "$var:$1:$exp1 percent of machines are down:`cat ~/downboxes|tr "\n" ","|sed 's/.$//'`"
fi
unset var_json
unset var_ip
unset d
unset e
unset w
unset exp1

}


##############################################################################
#Declaring function for Down percentage for only Redish-Cluster
##############################################################################

redisdown(){


if [ "$var" = "webapp-redis" ]
then
var3=`curl -fSsl "http://10.32.29.249:25280/webapp/v1/sharded/nodes"|tr "," "\n"|grep -E -o '[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*'|head -1`
curl -fSsl "http://$var3:56789/stats;csv"|grep "^$1"|grep DOWN|awk -F ',' '{print $2}'|tr "\n" "," >~/downboxes1
var_down=`cat ~/downboxes1|tr "," "\n"|wc -l`
d=`curl -fSsl "http://$var3:56789/stats;csv"|grep "^$1"|grep -v "BACKEND"|wc -l`
w=`curl -fSsl "http://$var3:56789/stats;csv"|grep "^$1"|grep -v "BACKEND"|grep "DOWN"|wc -l`
else
curl -fSsl "http://10.33.101.161:56789/stats;csv"|grep "^$1"|grep DOWN|awk -F ',' '{print $2}'|tr "\n" "," >~/downboxes1
var_down=`cat ~/downboxes1|tr "," "\n"|wc -l`
d=`curl -fSsl "http://10.33.101.161:56789/stats;csv"|grep "^$1"|grep -v "BACKEND"|wc -l`
w=`curl -fSsl "http://10.33.101.161:56789/stats;csv"|grep "^$1"|grep -v "BACKEND"|grep "DOWN"|wc -l`
fi
if [ "$w" -gt "0" -a "$d" -gt "0" -a "$var_down" -eq "$w" ]
then
exp1=`expr $w \* 100 \/ $d`
echo -n "<textarea rows="3" cols="100"> $exp1% ";echo "DOWN `cat ~/downboxes1|tr "\n" ","|sed 's/.$//'`:$var:$1</textarea>"
fi
}

ingesterdown(){
>~/downboxes2

for i in `cat ~/iplist |grep -A2 "$1$"|grep -o '[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*'`

do

var_in=$(curl -I "http://$i:9000/ingester/v1/sources"|head -1|awk '{print $2}')


if [ "$var_in" != 200 ]
then
echo "$i" >>~/downboxes2
fi

done

d=`cat ~/iplist |grep -A2 "$1$"|grep -o '[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*'|wc -l`
w=`cat ~/downboxes2|wc -l`
exp1=`expr $w \* 100 \/ $d`
echo -n "<textarea rows="3" cols="100"> $exp1% ";echo "DOWN `cat ~/downboxes2|tr "\n" ","|sed 's/.$//'`:$var:$1</textarea>"


}


###########################################################################################################
#Declaring function for Detail cluster status for all cluster and it is useing for Cluster-Status Dashboard
###########################################################################################################

detail(){
echo ""
echo "$1"
echo ""
if [ "$var" = "aggregator" ]||[ "$var" = "internal-aggregator" ]||[ "$var" = "completion" ]||[ "$var" = "rols" ]||[ "$var" = "precomput" ]||[ "$var" = "ingester" ]
then
parallel-ssh -t 0 -O StrictHostKeyChecking=no --user soumya.rout -iH "`cat ~/iplist|grep -A2 "$1$"|grep "primary_ip"|grep -o '[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*'|tr "\n" " "`" "dpkg -l | grep dk-w3-webapp | awk '{print \$3}';sudo apt-cache policy dk-w3-webapp|grep "Packages"|awk -F'/' '{print \$6}';sudo -u dk-w3-webapp -s [ -f /var/lib/dk-w3-webapp/webapps/ROOT/solr/status.html -a  -f /var/lib/dk-w3-webapp/ranger.html ] && echo "In-rotation" || echo "Out-of-rotation" ; df -kh|grep root|awk '{print \$5}';df -kh|grep lib|awk '{print \$5}';sed -nr '/`date --date='5 minutes ago' +"%d\/%b\/%Y:%H:%M:%S"`/,/`date +"%d\/%b\/%Y:%H:%M:%S"`/p' /var/lib/dk-w3-webapp/logs/access.`date +%Y-%m-%d`.log|grep "webapp\/"|grep -v "elb"|grep -v "solr"|grep -v "127.0.0.1"|awk '{if (\$9 ~ /5[0-9][0-9]/) print\$9\"\t\"\$7}'|wc -l"> ~/PACKAGE




else

parallel-ssh -t 0 -O StrictHostKeyChecking=no --user soumya.rout -iH "`cat ~/iplist|grep -A2 "$1$"|grep "primary_ip"|grep -o '[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*'|tr "\n" " "`" "dpkg -l | grep dk-webapp-solr | awk '{print \$3}';sudo apt-cache policy dk-webapp-solr|grep "Packages"|awk -F'/' '{print \$6}';sudo -u dk-webapp-solr -s [ -f /var/lib/dk-webapp-solr/webapps/ROOT/solr/status.html -a  -f /var/lib/dk-webapp-solr/ranger.html ] && echo "In-rotation" || echo "Out-of-rotation" ; df -kh|grep root|awk '{print \$5}';df -kh|grep lib|awk '{print \$5}';sed -nr '/`date --date='5 minutes ago' +"%d\/%b\/%Y:%H:%M:%S"`/,/`date +"%d\/%b\/%Y:%H:%M:%S"`/p' /var/lib/dk-webapp-solr/logs/access.`date +%Y-%m-%d`.log|grep "webapp\/"|grep -v "elb"|grep -v "solr"|grep -v "127.0.0.1"|awk '{if (\$9 ~ /5[0-9][0-9]/) print\$9\"\t\"\$7}'|wc -l"> ~/PACKAGE

fi
cat ~/PACKAGE|tr "\n" " "|tr "[" "\n"|grep  "SUCCESS"|awk '{print $2"\t""\t"$3"\t""\t"$4"\t""\t"$5"\t""\t"$6"\t""\t"$7"\t""\t"$8}'|sort -k8>~/version
cat ~/version|echo "`awk 'BEGIN{print "BOXE IP""\t""\t""\t""VERSION""\t""\t""PACKAGE""\t""\t""STATUS""\t""\t""\t""ROOT-SIZE""\t""CORE-SIZE""\t""5XX"}1'`"
rm ~/PACKAGE
rm ~/version

}


##########################################################
#Declaring function for checking disc usage in all cluster 
#########################################################

disk(){
parallel-ssh -t 0 -O StrictHostKeyChecking=no --user soumya.rout -iH "`cat ~/iplist|grep -A2 "$1$"|grep -o '[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*'|tr "\n" " "`" "df -kh|grep -v "rootfs"|awk '{print \$5}'">~/disk

cat ~/disk|tr "\n" "\t"|tr "[" "\n"|grep SUCCESS|awk '{print $2"\t"$4"\t"$5"\t"$6"\t"$7"\t"$8"\t"$9}'|tr -d "%"|awk '{if ($2 >=90||$3>=90||$4>=92||$5>=90||$6>=90||$7>=90||$8>=90) print $1}'>disk1

for i in `cat disk1`
do
echo "<B>Cluster name:$var and Group name:$1</B><br>"
echo "ip:$i<br><br>"
done
rm ~/disk
}


################################################
#Declaring function for Remove logs automaticaly 
################################################

logremove(){

parallel-ssh -t 0 -O StrictHostKeyChecking=no --user soumya.rout -iH "`cat ~/iplist |grep -A2 "$1$"|grep -o '[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*'|tr "\n" " "`" -t 5 "df -kh|grep root"> ~/new-disc
cat ~/new-disc|awk '/SUCCESS/ { print $4} /rootfs/ {print $5}'|tr "\n" "\t"|tr "%" "\n"|awk '{if ($2 >= 90) print $1}'|sort|uniq >~/disc
var1="`wc -c ~/disc| awk -F" " '{print $1}'`";
size="0";
if [ "$var1" -ne "$size" ]
then
for i in `cat ~/disc`
do
if [ "$var" = "aggregator" ]||[ "$var" = "internal-aggregator" ]||[ "$var" = "completion" ]||[ "$var" = "rols" ]||[ "$var" = "precomput" ]||[ "$var" = "masters" ]

then
ssh soumya.rout@$i 'sudo -u dk-w3-webapp -s find /var/log/Soumya/w3/webapp \( -name "webapp-error.log.[1-9]" -o -name "webapp-root.log.[1-9]" -o -name "solrCore.log.[1-9]" -o -name "semantic.log.[1-9]" -o -name  "searcher.log.[1-9]" -o -name "webapp-warmup.log.[1-9]" \) -exec rm {} \;; sudo -u dk-w3-webapp -s find /var/log/soumya/w3/webapp \( -name "access.*" -a ! -name  "access.`date +%Y-%m-%d`.log" -o -name "catalina.*" -a ! -name "catalina.out" \) -exec rm {} \;;sudo truncate -s0 /var/log/auth.log;sudo truncate -s0 /var/log/syslog ; sudo -u dk-w3-webapp -s find /var/log/soumya/w3/webapp -name "catalina.out" -type f -size +1048576 -exec truncate -s0 {} \;; sudo -u dk-w3-webapp -s find /var/log/soumya/w3/webapp -name "shardLatentCalls*" -mtime +2 -exec rm {} \;;sudo -u dk-w3-webapp -s find /var/log/soumya/w3/webapp -name "failedNRTListings*" -exec rm {} \;;sudo -u dk-w3-webapp -s find /var/log/soumya/w3/webapp -name "gc.log*" -a ! -name "gc.log`date +"%Y-%m"`*" -exec rm {} \;;sudo -u dk-w3-webapp -s find /var/log/soumya/w3/webapp -name "INFOSTREAM*" -exec truncate -s0 {} \;;sudo apt-get autoclean;sudo truncate -s 0 /var/log/apache2/*'> /dev/null 2>&1
elif [ "$var" = "hudson" ]||[ "$var" = "internal-hudson" ]||[ "$var" = "hudson-precomput" ]
then
ssh soumya.rout@$i 'sudo  truncate -s 0 /var/log/Soumya/w3/hudson/hudson-access.log.1;sudo truncate -s 0 /var/log/soumya/w3/hudson/hudson-root.log.1;sudo  truncate -s 0 /var/log/soumya/w3/hudson/hudson-error.log.1;sudo  truncate -s 0 /var/log/soumya/w3/hudson/hudson-access-rol.log.1;' > /dev/null 2>&1
else
ssh soumya.rout@$i 'sudo -u dk-webapp-solr -s find /var/log/Soumya/webapp \( -name "webapp-error.log.[1-9]" -o -name "webapp-root.log.[1-9]" -o -name "solrCore.log.[1-9]" -o -name "semantic.log.[1-9]" -o -name  "searcher.log.[1-9]" -o -name "webapp-warmup.log.[1-9]" \) -exec rm {} \; ; sudo -u dk-webapp-solr -s find /var/log/soumya/webapp \( -name "access.*" -a ! -name  "access.`date +%Y-%m-%d`.log" -o -name "catalina.*" -a ! -name "catalina.out" \) -exec rm {} \; ;sudo apt-get autoclean;sudo truncate -s0 /var/log/auth.log;sudo truncate -s0 /var/log/syslog ; sudo -u dk-webapp-solr -s find /var/log/soumya/webapp -name "catalina.out" -type f -size +1048576 -exec truncate -s0 {} \;;sudo -u dk-webapp-solr -s find /var/log/soumya/webapp -name "access.*" -type f -size +1048576 -exec truncate -s0 {} \;;sudo truncate -s 0 /var/log/apache2/*;sudo apt-get autoclean' > /dev/null 2>&1
fi



#ssh soumya.rout@$i 'sudo -u dk-w3-webapp -s find /var/log/Soumya/w3/webapp \( -name "webapp-error.log.[1-9]" -o -name "webapp-root.log.[1-9]" -o -name "solrCore.log.[1-9]" -o -name "semantic.log.[1-9]" -o -name  "searcher.log.[1-9]" -o -name "webapp-warmup.log.[1-9]" \) -exec rm {} \; ; sudo -u dk-w3-webapp -s find /var/log/soumya/w3/webapp \( -name "access.*" -a ! -name  "access.`date +%Y-%m-%d`.log" -o -name "catalina.*" -a ! -name "catalina.out" \) -exec rm {} \; ;sudo truncate -s0 /var/log/auth.log;sudo truncate -s0 /var/log/syslog ; sudo -u dk-w3-webapp -s find /var/log//w3/webapp -name "catalina.out" -type f -size +1048576 -exec truncate -s0 {} \;sudo -u dk-w3-webapp -s truncate -s 0 /var/log/soumya/w3/hudson/hudson-access.log.1;sudo -u dk-w3-webapp -s truncate -s 0 /var/log/soumya/w3/hudson/hudson-root.log.1;sudo -u dk-w3-webapp -s truncate -s 0 /var/log/soumya/w3/hudson/hudson-error.log.1;sudo -u dk-w3-webapp -s truncate -s 0 /var/log/soumya/w3/hudson/hudson-access-rol.log.1;sudo -u dk-w3-webapp -s find /var/log/soumya/w3/webapp -name "access.*" -type f -size +1048576 -exec truncate -s0 {} \;;sudo -u dk-webapp-solr -s find /var/log/soumya/webapp \( -name "webapp-error.log.[1-9]" -o -name "webapp-root.log.[1-9]" -o -name "solrCore.log.[1-9]" -o -name "semantic.log.[1-9]" -o -name  "searcher.log.[1-9]" -o -name "webapp-warmup.log.[1-9]" \) -exec rm {} \; ; sudo -u dk-webapp-solr -s find /var/log/soumya/webapp \( -name "access.*" -a ! -name  "access.`date +%Y-%m-%d`.log" -o -name "catalina.*" -a ! -name "catalina.out" \) -exec rm {} \; ;sudo truncate -s0 /var/log/auth.log;sudo truncate -s0 /var/log/syslog ; sudo -u dk-webapp-solr -s find /var/log/soumya/webapp -name "catalina.out" -type f -size +1048576 -exec truncate -s0 {} \;;sudo -u dk-webapp-solr -s find /var/log/soumya/webapp -name "access.*" -type f -size +1048576 -exec truncate -s0 {} \;' > /dev/null 2>&1

done

for i in `cat ~/disc`;  do ssh soumya.rout@$i "df -kh|grep root;hostname -i"|tr -d rootfs|tr "\n" " "|tr -d "%"|awk '{if ($4 >= 90)print $6}' ;done  > ~/logip.txt

for i in `cat ~/disc`;  do ssh soumya.rout@$i "df -kh|grep root;hostname -i"|tr -d rootfs|tr "\n" " "|tr -d "%"|awk '{if ($4 <= 90)print $6}' ;done > ~/logip1.txt

var2="`wc -c ~/logip1.txt| awk -F" " '{print $1}'`";


var3="`wc -c ~/logip.txt| awk -F" " '{print $1}'`";


if [ "$var3" -eq "$size" ]

then

#echo "All Disc-space cleared in $1"
echo "Below is the list of boxes in which disc space cleared from $1"
#echo "Number of boxes:-`cat ~/logip1.txt|sort|uniq|wc -l`"
echo "`cat ~/logip1.txt|sort|uniq|tr '\n' ',' |sed "s/.$/$(printf '\n')/"` "

else

if [ "$var3" -gt "$size" ]

then

echo "<B>clear manually</B><br>"
echo "<B>Cluster name:$var and Group name:$1</B><br>"
echo "ip:`cat ~/logip.txt|tr '\n' ',' | sed "s/.$/$(printf '\n')/"`<br><br>"

if [ "$var2" -gt "$size" ]

then

echo "Below is the list of boxes in which disc space cleared from $1 "
echo "Number of boxes:-`cat ~/logip1.txt|sort|uniq|wc -l`"
echo "`cat ~/logip1.txt|sort|uniq|tr '\n' ',' |sed "s/.$/$(printf '\n')/"` "

#else

#echo "There is no more Boxes having disc usage more then 90% in $1"

fi
fi
fi
fi

rm -rf ~/new-disc
rm -rf ~/disc
rm -rf ~/logip
rm -rf ~/logip1
}




################################
#Choose Action for aggregator cluster
##################################################################
#Fuctions are detail,logremove,coresize,down,version_mismatch,disk
###################################################################


cmd_aggregator(){

  if [ "$var1" = "detail" ]
   then
    detail webapp-aggregator
 elif [ "$var1" = "logremove" ]
   then
    logremove webapp-aggregator
 elif [ "$var1" = "coresize" ]
   then
    coresize webapp-aggregator

 elif [ "$var1" = "down" ]
   then
     down webapp-aggregator
 elif [ "$var1" = "version" ]
   then
     version_mismatch  webapp-aggregator
 elif  [ "$var1" = "diskusage" ]
then 
disk webapp-aggregator
else
usage
fi
}

###########################################
#Choose Action for electronicshigh cluster
##########################################


cmd_electronicshigh () {

if [ "$var1" = "detail" ]
then
detail solr-only-elecHigh-shard1
detail solr-only-elecHigh-shard2
detail solr-only-elecHigh-shard3
detail solr-only-elecHigh-shard4
elif [ "$var1" = "logremove" ]
then
logremove solr-only-elecHigh-shard1
logremove solr-only-elecHigh-shard2
logremove solr-only-elecHigh-shard3
logremove solr-only-elecHigh-shard4

elif [ "$var1" = "down" ]
then
electronicshigh_down
elif [ "$var1" = "version" ]
   then
 version_mismatch  solr-only-elecHigh-shard1
 version_mismatch  solr-only-elecHigh-shard2
 version_mismatch  solr-only-elecHigh-shard3  
 version_mismatch  solr-only-elecHigh-shard4 
 elif  [ "$var1" = "diskusage" ]
then
disk solr-only-elecHigh-shard1
disk solr-only-elecHigh-shard2
disk solr-only-elecHigh-shard3
disk solr-only-elecHigh-shard4
else
usage
fi
}

###########################################
#Choose Action for electronicslow cluster
###########################################

cmd_electronicslow(){

if [ "$var1" = "detail" ]
then
detail solr-only-elecLow-shard1
detail solr-only-elecLow-shard2
detail solr-only-elecLow-shard3
detail solr-only-elecLow-shard4
detail solr-only-elecLow-shard5
detail solr-only-elecLow-shard6
detail solr-only-elecLow-shard7
detail solr-only-elecLow-shard8
detail solr-only-elecLow-shard9
detail solr-only-elecLow-shard10
elif [ "$var1" = "logremove" ]
then
logremove solr-only-elecLow-shard1
logremove solr-only-elecLow-shard2
logremove solr-only-elecLow-shard3
logremove solr-only-elecLow-shard4
logremove solr-only-elecLow-shard5
logremove solr-only-elecLow-shard6
logremove solr-only-elecLow-shard7
logremove solr-only-elecLow-shard8
logremove solr-only-elecLow-shard9
logremove solr-only-elecLow-shard10

elif [ "$var1" = "down" ]
then
electronicslow_down
elif [ "$var1" = "version" ]
   then
version_mismatch solr-only-elecLow-shard1
version_mismatch solr-only-elecLow-shard2
version_mismatch solr-only-elecLow-shard3
version_mismatch solr-only-elecLow-shard4
version_mismatch solr-only-elecLow-shard5
version_mismatch solr-only-elecLow-shard6
version_mismatch solr-only-elecLow-shard7
version_mismatch solr-only-elecLow-shard8
version_mismatch solr-only-elecLow-shard9
version_mismatch solr-only-elecLow-shard10
 elif  [ "$var1" = "diskusage" ]
then
disk solr-only-elecLow-shard1
disk solr-only-elecLow-shard2
disk solr-only-elecLow-shard3
disk solr-only-elecLow-shard4
disk solr-only-elecLow-shard5
disk solr-only-elecLow-shard6
disk solr-only-elecLow-shard7
disk solr-only-elecLow-shard8
disk solr-only-elecLow-shard9
disk solr-only-elecLow-shard10
else
usage
fi
}


###########################################
#Choose Action for  Masters of cluster
##########################################

cmd_masters(){

if [ "$var1" = "logremove" ]
then
logremove elecHigh-master-shard.*
logremove elecLow-master-shard.*
logremove life-cluster-.*
logremove books-cluster-.*
logremove elec-low-master-shard9
elif  [ "$var1" = "diskusage" ]
then
disk elecHigh-master-shard.*
disk elecLow-master-shard.*
disk life-cluster-.*
disk books-cluster-.*
disk elec-low-master-shard9
fi
}


###########################################
#Choose Action for lifestyle cluster
###########################################

cmd_lifestyle(){

if [ "$var1" = "detail" ]
then
detail solr-only-life-shard1
detail solr-only-life-shard2
detail solr-only-life-shard3
detail solr-only-life-shard4
detail solr-only-life-shard5
detail solr-only-life-shard6
detail solr-only-life-shard7
detail solr-only-life-shard8
elif [ "$var1" = "logremove" ]
then
logremove solr-only-life-shard1
logremove solr-only-life-shard2
logremove solr-only-life-shard3
logremove solr-only-life-shard4
logremove solr-only-life-shard5
logremove solr-only-life-shard6
logremove solr-only-life-shard7
logremove solr-only-life-shard8
elif [ "$var1" = "down" ]
then
lifestyle_down
elif [ "$var1" = "version" ]
then
version_mismatch solr-only-life-shard1
version_mismatch solr-only-life-shard2
version_mismatch solr-only-life-shard3
version_mismatch solr-only-life-shard4
version_mismatch solr-only-life-shard5
version_mismatch solr-only-life-shard6
version_mismatch solr-only-life-shard7
version_mismatch solr-only-life-shard8
elif  [ "$var1" = "diskusage" ]
then
disk solr-only-life-shard1
disk solr-only-life-shard2
disk solr-only-life-shard3
disk solr-only-life-shard4
disk solr-only-life-shard5
disk solr-only-life-shard6
disk solr-only-life-shard7
disk solr-only-life-shard8
else
usage
fi
}

###########################################
#Choose Action for books cluster
###########################################

cmd_books(){

if [ "$var1" = "detail" ]
then
detail solr-only-books-shard1
detail solr-only-books-shard2
detail solr-only-books-shard3
detail solr-only-books-shard4
detail solr-only-books-shard5
detail solr-only-books-shard6
detail solr-only-books-shard7
detail solr-only-books-shard8
detail solr-only-books-shard9
detail solr-only-books-shard10
elif [ "$var1" = "logremove" ]
then
logremove solr-only-books-shard1
logremove solr-only-books-shard2
logremove solr-only-books-shard3
logremove solr-only-books-shard4
logremove solr-only-books-shard5
logremove solr-only-books-shard6
logremove solr-only-books-shard7
logremove solr-only-books-shard8
logremove solr-only-books-shard9
logremove solr-only-books-shard10
elif [ "$var1" = "down" ]
then
book_down
elif [ "$var1" = "version" ]
   then
version_mismatch solr-only-books-shard1
version_mismatch solr-only-books-shard2
version_mismatch solr-only-books-shard3
version_mismatch solr-only-books-shard4
version_mismatch solr-only-books-shard5
version_mismatch solr-only-books-shard6
version_mismatch solr-only-books-shard7
version_mismatch solr-only-books-shard8
version_mismatch solr-only-books-shard9
version_mismatch solr-only-books-shard10
elif  [ "$var1" = "diskusage" ]
then
disk solr-only-books-shard1
disk solr-only-books-shard2
disk solr-only-books-shard3
disk solr-only-books-shard4
disk solr-only-books-shard5
disk solr-only-books-shard6
disk solr-only-books-shard7
disk solr-only-books-shard8
disk solr-only-books-shard9
disk solr-only-books-shard10
else
usage
fi
}

###########################################
#Choose Action for internal-aggregator cluster
###########################################

cmd_internal_aggregator(){

if [ "$var1" = "detail" ]
then
detail internal-aggregator
elif [ "$var1" = "logremove" ]
then
logremove internal-aggregator
elif [ "$var1" = "down" ]
then
down internal-aggregator
elif [ "$var1" = "version" ]
   then
version_mismatch internal-aggregator
elif  [ "$var1" = "diskusage" ]
then
disk internal-aggregator
else
usage
fi
}

###################################################
#Choose Action for internal-electronicshigh cluster
##################################################

cmd_internal_electronicshigh(){

if [ "$var1" = "detail" ]
then
detail solr-only-elecHigh1-grp
detail solr-only-elecHigh2-grp
detail solr-only-elecHigh3-grp
detail solr-only-elecHigh4-grp
elif [ "$var1" = "logremove" ]
then
logremove solr-only-elecHigh1-grp
logremove solr-only-elecHigh2-grp
logremove solr-only-elecHigh3-grp
logremove solr-only-elecHigh4-grp

elif [ "$var1" = "down" ]
then
internal_electronicshigh_down
elif [ "$var1" = "version" ]
   then
version_mismatch solr-only-elecHigh1-grp
version_mismatch solr-only-elecHigh2-grp
version_mismatch solr-only-elecHigh3-grp
version_mismatch solr-only-elecHigh4-grp
elif  [ "$var1" = "diskusage" ]
then
disk solr-only-elecHigh1-grp
disk solr-only-elecHigh2-grp
disk solr-only-elecHigh3-grp
disk solr-only-elecHigh4-grp
else
usage
fi
}

##################################################
#Choose Action for internal-electronicslow cluster
#################################################

cmd_internal_electronicslow(){

if [ "$var1" = "detail" ]
then
detail solr-only-elecLow1-grp
detail solr-only-elecLow2-grp
detail solr-only-elecLow3-grp
detail solr-only-elecLow4-grp
detail solr-only-elecLow5-grp
detail solr-only-elecLow6-grp
detail solr-only-elecLow7-grp
detail solr-only-elecLow8-grp
detail solr-only-elecLow9-grp
detail solr-only-elecLow10-grp
elif [ "$var1" = "logremove" ]
then
logremove solr-only-elecLow1-grp
logremove solr-only-elecLow2-grp
logremove solr-only-elecLow3-grp
logremove solr-only-elecLow4-grp
logremove solr-only-elecLow5-grp
logremove solr-only-elecLow6-grp
logremove solr-only-elecLow7-grp
logremove solr-only-elecLow8-grp
logremove solr-only-elecLow9-grp
logremove solr-only-elecLow10-grp
elif [ "$var1" = "down" ]
then
internal_electronicslow_down
elif [ "$var1" = "version" ]
   then
version_mismatch solr-only-elecLow1-grp
version_mismatch solr-only-elecLow2-grp
version_mismatch solr-only-elecLow3-grp
version_mismatch solr-only-elecLow4-grp
version_mismatch solr-only-elecLow5-grp
version_mismatch solr-only-elecLow6-grp
version_mismatch solr-only-elecLow7-grp
version_mismatch solr-only-elecLow8-grp
version_mismatch solr-only-elecLow9-grp
version_mismatch solr-only-elecLow10-grp
elif  [ "$var1" = "diskusage" ]
then
disk solr-only-elecLow1-grp
disk solr-only-elecLow2-grp
disk solr-only-elecLow3-grp
disk solr-only-elecLow4-grp
disk solr-only-elecLow5-grp
disk solr-only-elecLow6-grp
disk solr-only-elecLow7-grp
disk solr-only-elecLow8-grp
disk solr-only-elecLow9-grp
disk solr-only-elecLow10-grp
else
usage
fi
}

###########################################
#Choose Action for internal-lifestyle cluster
###########################################

cmd_internal_lifestyle(){

if [ "$var1" = "detail" ]
then
detail solr-only-life1-grp
detail solr-only-life2-grp
detail solr-only-life3-grp
detail solr-only-life4-grp
detail solr-only-life5-grp
detail solr-only-life6-grp
detail solr-only-life7-grp
detail solr-only-life8-grp

elif [ "$var1" = "logremove" ]
then
logremove solr-only-life1-grp
logremove solr-only-life2-grp
logremove solr-only-life3-grp
logremove solr-only-life4-grp
logremove solr-only-life5-grp
logremove solr-only-life6-grp
logremove solr-only-life7-grp
logremove solr-only-life8-grp

elif [ "$var1" = "down" ]
then
internal_lifestyle_down
elif [ "$var1" = "version" ]
   then
version_mismatch solr-only-life1-grp
version_mismatch solr-only-life2-grp
version_mismatch solr-only-life3-grp
version_mismatch solr-only-life4-grp
version_mismatch solr-only-life5-grp
version_mismatch solr-only-life6-grp
version_mismatch solr-only-life7-grp
version_mismatch solr-only-life8-grp
elif  [ "$var1" = "diskusage" ]
then
disk solr-only-life1-grp
disk solr-only-life2-grp
disk solr-only-life3-grp
disk solr-only-life4-grp
disk solr-only-life5-grp
disk solr-only-life6-grp
disk solr-only-life7-grp
disk solr-only-life8-grp

else
usage
fi
}

###########################################
#Choose Action for internal-books cluster
###########################################

cmd_internal_books(){

if [ "$var1" = "detail" ]
then
detail solr-only-books1-grp
detail solr-only-books2-grp
detail solr-only-books3-grp
detail solr-only-books4-grp
detail solr-only-books5-grp
detail solr-only-books6-grp
detail solr-only-books7-grp
detail solr-only-books8-grp
detail solr-only-books9-grp
detail solr-only-books10-grp
elif [ "$var1" = "logremove" ]
then
logremove solr-only-books1-grp
logremove solr-only-books2-grp
logremove solr-only-books3-grp
logremove solr-only-books4-grp
logremove solr-only-books5-grp
logremove solr-only-books6-grp
logremove solr-only-books7-grp
logremove solr-only-books8-grp
logremove solr-only-books9-grp
logremove solr-only-books10-grp
elif [ "$var1" = "down" ]
then
internal_books_down
elif [ "$var1" = "version" ]
   then
version_mismatch solr-only-books1-grp
version_mismatch solr-only-books2-grp
version_mismatch solr-only-books3-grp
version_mismatch solr-only-books4-grp
version_mismatch solr-only-books5-grp
version_mismatch solr-only-books6-grp
version_mismatch solr-only-books7-grp
version_mismatch solr-only-books8-grp
version_mismatch solr-only-books9-grp
version_mismatch solr-only-books10-grp
elif  [ "$var1" = "diskusage" ]
then
disk solr-only-books1-grp
disk solr-only-books2-grp
disk solr-only-books3-grp
disk solr-only-books4-grp
disk solr-only-books5-grp
disk solr-only-books6-grp
disk solr-only-books7-grp
disk solr-only-books8-grp
disk solr-only-books9-grp
disk solr-only-books10-grp
else
usage
fi
}

###########################################
#Choose Action for rols cluster
###########################################

cmd_rols(){

if [ "$var1" = "detail" ]
then
detail rols-shard0-grp
detail rols-shard-1-grp
detail rols-shard-2-grp
detail rols-shard-3-grp
detail rols-shard-4-grp
detail rols-shard-5-grp
elif [ "$var1" = "logremove" ]
then
logremove rols-shard0-grp
logremove rols-shard-1-grp
logremove rols-shard-2-grp
logremove rols-shard-3-grp
logremove rols-shard-4-grp
logremove rols-shard-5-grp
elif [ "$var1" = "down" ]
then
rols_down
elif [ "$var1" = "version" ]
   then
version_mismatch rols-shard0-grp
version_mismatch rols-shard-1-grp
version_mismatch rols-shard-2-grp
version_mismatch rols-shard-3-grp
version_mismatch rols-shard-4-grp
version_mismatch rols-shard-5-grp
elif  [ "$var1" = "diskusage" ]
then
disk rols-shard0-grp
disk rols-shard-1-grp
disk rols-shard-2-grp
disk rols-shard-3-grp
disk rols-shard-4-grp
disk rols-shard-5-grp
else
usage
fi
}

###########################################
#Choose Action for completion cluster
###########################################

cmd_completion(){
if [ "$var1" = "detail" ]
then
detail webapp-completions-grp4
detail replicators-lifestyle-grp
elif [ "$var1" = "logremove" ]
then
logremove webapp-completions-grp4
logremove replicators-lifestyle-grp
elif [ "$var1" = "down" ]
then
down webapp-completions-grp4
elif [ "$var1" = "version" ]
   then
version_mismatch webapp-completions-grp4
elif  [ "$var1" = "diskusage" ]
then
disk webapp-completions-grp4
else
usage
fi

}

###########################################
#Choose Action for hudson cluster
###########################################

cmd_hudson(){
if [ "$var1" = "detail" ]
then
detail hudson-grp4

elif [ "$var1" = "logremove" ]
then
logremove hudson-grp4
elif [ "$var1" = "down" ]
then
 down hudson-grp4

elif [ "$var1" = "version" ]
   then
version_mismatch hudson-grp
elif  [ "$var1" = "diskusage" ]
then
disk hudson-grp4
else
usage
fi

}

###########################################
#Choose Action for internal-hudson cluster
###########################################

cmd_internal_hudson(){
if [ "$var1" = "detail" ]
then
detail hudson-grp
elif [ "$var1" = "logremove" ]
then
logremove hudson-grp
elif [ "$var1" = "down" ]
then
down hudson-grp
elif [ "$var1" = "version" ]
   then
version_mismatch hudson-grp
elif  [ "$var1" = "diskusage" ]
then
disk hudson-grp
else
usage
fi

}

###########################################
#Choose Action for hudson_precomput cluster
###########################################

cmd_hudson__precomput(){
if [ "$var1" = "detail" ]
then
detail precompute-grp6
elif [ "$var1" = "logremove" ]
then
logremove precompute-grp6
elif [ "$var1" = "down" ]
then
down precompute-grp6
elif [ "$var1" = "version" ]
   then
version_mismatch precompute-grp6
elif  [ "$var1" = "diskusage" ]
then
disk precompute-grp6
else
usage
fi
}



###########################################
#Choose Action for precomput cluster
###########################################

cmd_precomput(){
if [ "$var1" = "detail" ]
then
detail rols-precomp-bkt0-grp3
detail rols-precomp-bkt1-grp2

elif [ "$var1" = "logremove" ]
then
logremove rols-precomp-bkt0-grp3
logremove rols-precomp-bkt1-grp2
logremove rols-master1-grp
logremove rols-master2-grp
elif [ "$var1" = "down" ]
then
down rols-precomp-bkt0-grp3
down rols-precomp-bkt1-grp2
elif [ "$var1" = "version" ]
   then
version_mismatch rols-precomp-bkt0-grp3
version_mismatch rols-precomp-bkt1-grp2
elif  [ "$var1" = "diskusage" ]
then
disk rols-precomp-bkt0-grp3
disk rols-precomp-bkt1-grp2
else
usage
fi
}

##########################################################################################################################################################################################################
#Choose Disc usge  Action for redis-listing-data-rols,redis-santa-webapp,redis-pricing-rols,zk-cloud-grp,zk-ingeter-grp,hudson-ranger-zk-grp,webapp-hbase-nn-cl2-grp,webapp-hbase-dn-cl2-grp,webapp-hbase-nn-grp,webapp-hbase-dn-grp,ingestion-zk,foxtrot-grp2,es-grp,webapp-mysql-grp3,kf-grp4
##########################################################################################################################################################################################################

cmd_all(){
if [ "$var1" = "diskusage" ]
then
disk redis-listing-data-rols
disk redis-santa-webapp
disk redis-pricing-rols
disk zk-cloud-grp
disk zk-ingeter-grp
disk hudson-ranger-zk-grp
disk webapp-hbase-nn-cl2-grp
disk webapp-hbase-dn-cl2-grp
disk webapp-hbase-nn-grp
disk webapp-hbase-dn-grp
disk ingestion-zk
disk foxtrot-grp2
disk es-grp
disk webapp-mysql-grp3
disk kf-grp4
else
usage
fi

}

###########################################
#Choose Action for ingester cluster
###########################################

cmd_ingester(){
if [ "$var1" = "detail" ]
then
detail in-grp2

elif [ "$var1" = "logremove" ]
then
logremove in-grp2
elif [ "$var1" = "diskusage" ]
then
disk in-grp2
elif [ "$var1" = "down" ]
then
ingesterdown in-grp2
else
usage
fi
}

cmd_webapp_redis(){
if [ "$var1" = "down" ]
then
webapp
fi
}



cmd_storm_redis(){
if [ "$var1" = "down" ]
then
storm
fi
}

###########################################
#Choose Action for Redis-Sherlock cluster
###########################################

webapp(){
redisdown mysql_cluster
redisdown bk_redis_slave
redisdown santa_bk_redis_slave
redisdown pricing_bk_redis_slave

}

###########################################
#Choose Action for Redis-Storm cluster
###########################################

storm(){
redisdown pricing_bk_redis_master
redisdown pricing_bk_redis_slave
redisdown santa_bk_redis_slave
redisdown bk_redis_slave
redisdown bk_redis_master
redisdown pricing_bk_redis_master
redisdown santa_bk_redis_master


}


##############################################
#calling Down percentage function cluster wise 
#############################################

electronicshigh_down(){
####################################
#function $1 $2
###################################

down electronicsHigh-shard1 solr-only-elecHigh-shard1 
down electronicsHigh-shard2 solr-only-elecHigh-shard2
down electronicsHigh-shard3 solr-only-elecHigh-shard3
down electronicsHigh-shard4 solr-only-elecHigh-shard4
}

electronicslow_down(){

down electronicsLow-shard1 solr-only-elecLow-shard1 
down electronicsLow-shard2 solr-only-elecLow-shard2 
down electronicsLow-shard3 solr-only-elecLow-shard3 
down electronicsLow-shard4 solr-only-elecLow-shard4 
down electronicsLow-shard5 solr-only-elecLow-shard5 
down electronicsLow-shard6 solr-only-elecLow-shard6 
down electronicsLow-shard7 solr-only-elecLow-shard7 
down electronicsLow-shard8 solr-only-elecLow-shard8 
down electronicsLow-shard9 solr-only-elecLow-shard9 
down electronicsLow-shard10 solr-only-elecLow-shard10 
}


lifestyle_down(){

down lifestyleCore-shard1 solr-only-life-shard1 
down lifestyleCore-shard2 solr-only-life-shard2 
down lifestyleCore-shard3 solr-only-life-shard3 
down lifestyleCore-shard4 solr-only-life-shard4 
down lifestyleCore-shard5 solr-only-life-shard5 
down lifestyleCore-shard6 solr-only-life-shard6 
down lifestyleCore-shard7 solr-only-life-shard7 
down lifestyleCore-shard8 solr-only-life-shard8 
}

book_down(){

down booksCore-shard1 solr-only-books-shard1
down booksCore-shard2 solr-only-books-shard2
down booksCore-shard3 solr-only-books-shard3
down booksCore-shard4 solr-only-books-shard4
down booksCore-shard5 solr-only-books-shard5
down booksCore-shard6 solr-only-books-shard6
down booksCore-shard7 solr-only-books-shard7
down booksCore-shard8 solr-only-books-shard8
down booksCore-shard9 solr-only-books-shard9
down booksCore-shard10 solr-only-books-shard10
}


internal_electronicshigh_down(){

down electronicsHigh-shard1 solr-only-elecHigh1-grp
down electronicsHigh-shard2 solr-only-elecHigh2-grp
down electronicsHigh-shard3 solr-only-elecHigh3-grp
down electronicsHigh-shard4 solr-only-elecHigh4-grp
}


internal_electronicslow_down(){

down electronicsLow-shard1 solr-only-elecLow1-grp
down electronicsLow-shard2 solr-only-elecLow2-grp
down electronicsLow-shard3 solr-only-elecLow3-grp
down electronicsLow-shard4 solr-only-elecLow4-grp
down electronicsLow-shard5 solr-only-elecLow5-grp
down electronicsLow-shard6 solr-only-elecLow6-grp
down electronicsLow-shard7 solr-only-elecLow7-grp
down electronicsLow-shard8 solr-only-elecLow8-grp
down electronicsLow-shard9 solr-only-elecLow9-grp
down electronicsLow-shard10 solr-only-elecLow10-grp
}


internal_lifestyle_down(){
down lifestyleCore-shard1 solr-only-life1-grp
down lifestyleCore-shard2 solr-only-life2-grp
down lifestyleCore-shard3 solr-only-life3-grp
down lifestyleCore-shard4 solr-only-life4-grp
down lifestyleCore-shard5 solr-only-life5-grp
down lifestyleCore-shard6 solr-only-life6-grp
down lifestyleCore-shard7 solr-only-life7-grp
down lifestyleCore-shard8 solr-only-life8-grp

}

internal_books_down(){

down booksCore-shard1 solr-only-books1-grp
down booksCore-shard2 solr-only-books2-grp
down booksCore-shard3 solr-only-books3-grp
down booksCore-shard4 solr-only-books4-grp
down booksCore-shard5 solr-only-books5-grp
down booksCore-shard6 solr-only-books6-grp
down booksCore-shard7 solr-only-books7-grp
down booksCore-shard8 solr-only-books8-grp
down booksCore-shard9 solr-only-books9-grp
down booksCore-shard10 solr-only-books10-grp

}

rols_down(){
down rols-shard.*-grp
#down rols-shard-1-grp
#down rols-shard-2-grp
#down rols-shard-3-grp
#down rols-shard-4-grp
#down rols-shard-5-grp
}


########################################
#Taking first input as a cluster name
#######################################

if [ "$var" = "aggregator" ]
then
 cmd_aggregator
elif  [ "$var" = "electronicshigh" ]
then
 cmd_electronicshigh
elif  [ "$var" = "electronicslow" ]
then
cmd_electronicslow
elif  [ "$var" = "lifestyle" ]
then
cmd_lifestyle
elif  [ "$var" = "books" ]
then
cmd_books
elif  [ "$var" = "internal-aggregator" ]
then
cmd_internal_aggregator
elif  [ "$var" = "internal-electronicshigh" ]
then
cmd_internal_electronicshigh
elif  [ "$var" = "internal-electronicslow" ]
then
cmd_internal_electronicslow
elif  [ "$var" = "internal-lifestyle" ]
then
cmd_internal_lifestyle
elif  [ "$var" = "internal-books" ]
then
cmd_internal_books
elif  [ "$var" = "rols" ]
then
cmd_rols
elif  [ "$var" = "completion" ]
then
cmd_completion
elif  [ "$var" = "hudson" ]
then
cmd_hudson
elif  [ "$var" = "internal-hudson" ]
then
cmd_internal_hudson
elif  [ "$var" = "hudson-precomput" ]
then
cmd_hudson__precomput
elif  [ "$var" = "precomput" ]
then
cmd_precomput
elif  [ "$var" = "ingester" ]
then
cmd_ingester
elif  [ "$var" = "masters" ]
then
cmd_masters
elif  [ "$var" = "webapp-redis" ]
then
cmd_webapp_redis
elif  [ "$var" = "storm-redis" ]
then
cmd_storm_redis
elif  [ "$var" = "disk-alert" ]
then
cmd_all
elif  [ "$var" = "" ]
then
usage
else
usage
fi

###########################################################################################################################################################################################################


