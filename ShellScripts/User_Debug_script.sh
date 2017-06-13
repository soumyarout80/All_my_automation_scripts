#!/bin/bash
DATE=`date --date="-1 day" +"%Y-%m-%d"`
echo ""
echo ""
echo "STATUS"
echo "_______________________________"
sudo df-website-admin status;
uptime
echo "_______________________________"
echo "Requests with highest latencies (count,request,time) sorted on time"
echo "_______________________________"
tail -3000 /var/log/nginx/website_access.log | cut -f2,3 -d'"' | cut -f2,5 -d' ' | sort -nr -t' ' -k2 | uniq -c | head -20
echo "_______________________________"
echo "Requests with highest counts (count,request,time) sorted on count"
echo "_______________________________"
tail -3000 /var/log/nginx/website_access.log | cut -f2,3 -d'"' | cut -f2,5 -d' ' | sort -nr -t' ' -k2 | uniq -c | sort -nr |head -20
echo "_______________________________"
echo "Degrading services (time,service)"
echo "_______________________________"
tail -3000 /var/log/soumya/w3/agent/perf-metrics.log.$DATE | egrep -o "[a-zA-Z0-9\\_\.]+:[0-9]{4}[0-9]*" | cut -d: -f1 | sort | uniq -c | sort -nr | head -20
echo "_______________________________"
echo "Max Nginx errors"
echo "_______________________________"
tail -3000 /var/log/nginx/website_error.log | cut -f6- -d' ' | cut -f1 -d',' | sort | uniq -c | sort -nr | head
echo "_______________________________"
echo "Max exceptions"
echo "_______________________________"
tail -3000 /var/log/soumya/w3/website/exceptions.log.$DATE | grep 'message:protected' | sort | uniq -c | sort -nr | head
echo "_______________________________"
echo "Max ips hitting us"
echo "_______________________________"
tail -3000 /var/log/nginx/website_access.log | cut -f1 -d' ' | sort | uniq -c | sort -nr | head
echo "_______________________________"
#This is for checkout exceptions, Uncomment if needed : 
#echo "Checkout exceptions"
#echo "_______________________________"
#cat /var/log/soumya/w3/website/checkout_exceptions.log.2013-01-21 | grep -2 'LogID' | grep 'message:protected' 
#echo "_______________________________" 

