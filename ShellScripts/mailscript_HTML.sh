#!/usr/bin/env bash

echo From:cp-Devops-techpse@example.com
echo Reply-To:soumyarout80@gmail.com
echo Subject: 'CLUSTERS DOWN!!!'
echo TO: soumyarout80@gmail.com
echo CC:
echo Content-Type: text/html

echo "<html>"
echo "<head>"
echo "<title>"
echo "Daily Report for `date --date='2 days ago' +%F`"
echo "</title>"
echo "<style>"
echo "table {"
echo "    border: 5px solid black;"
echo "    border-collapse: collapse;"
echo "    width: 100%;"
echo "}"
echo "td, th {"
echo "    border: 1px solid red;"
echo "    border-collapse: collapse;"
echo "}"
echo "th {"
echo "    background-color: green;"
echo "    color: white;"
echo "</style>"
echo "</head>"
echo "<body>"


#echo "<B> CRITICAL ALERT for `date +%F` </B> <BR/><BR/>"
#echo "<table> "
#echo "<tr> <th>Cluster down`cat ip|grep elect*|tr -d "%"|awk '{if ($1>10)print $1"%"}'`</th><th>`cat ip|grep elect*|tr -d "%"|awk '{if ($1>10)print $0}'|awk -F ':' '{print $3}'`</th><th>"
#echo "<p style="background-color:rgb(255,0,0)"> CRITICAL CLUSTERS DOWN!! FOR `date +%F`</p><BR/>"
#echo "<p> STEPS TO BE TAKEN?<a href="https://docs.google.com/document/d/1SjIg8NZUapAkMUPOg6HvDqh5nRnhVt7kdCIQFdfiQ8E/edit">CLICK HERE!=></a></p>"
#echo "<B style="background-color:cyan;blue:red">STEPS TO BE TAKEN :-https://docs.google.com/document/d/1SjIg8NZUapAkMUPOg6HvDqh5nRnhVt7kdCIQFdfiQ8E/edit</B>"
#echo "</tr></table><BR/>"
echo "</body>"
echo "</html>"


echo "<html>
<body>
<p><h2 style="background-color:Bisque"> CRITICAL CLUSTERS DOWN!! FOR `date`</h2></p>
</body>
</html>"
echo "`cat /home/soumya.rout/down_boxes1`"
var3=`curl -fSsl "http://10.47.1.95:25290/hudson/v1/project/nodes/internal-aggregator"|tr "," "\n"|grep -E -o '[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*'|head -1`
var_json=`curl -fSsl "http://$var3:25280/project/v1/sharded/nodes"|tr "," "\n"|tr -d '{'OR'}'OR'"'OR'['OR']'|grep -E -o '[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*'|head -1`
echo "<html>
<body>
<a href="http://$var_json:56789">shard-Haproxy-url!!</a>
<a href="http://10.33.101.161:56789">Haproxy-url!!</a>

<B><p style="background-color:PapayaWhip"> STEPS TO BE TAKEN?<a href="https://docs.google.com/document/d/1SjIg8NZUapAkMUPOg6HvDqh5nRnhVt7kdCIQFdfiQ8E/edit">CLICK HERE!</a></p></B>
</body>
</html>

