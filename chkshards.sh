#!/bin/bash
#chkshards.sh - (c) 2016 Christopher Evans 
# ------------- A script to monitor and update the apache index status text file for StorjShare program 
#

DATE=$(date '+%b')

#  %e

date > /var/www/html/status.txt

ls /home/chris/Desktop/data/storj0/farmer.db -altr > /home/chris/Desktop/dir.txt

if grep "$DATE" /home/chris/Desktop/dir.txt > /dev/null; then
    echo "Operational and open to new shards :-)" >> /var/www/html/status.txt
else
    echo "No new shards, as we be full to the brim :-)" >> /var/www/html/status.txt
    echo "" > /home/chris/Desktop/offline.txt
    ps aux | grep "storjshare" > /home/chris/Desktop/offline.txt 
    cat /home/chris/Desktop/offline.txt | mailx -s "Node 1 statistics analysis"  axiomfinity@netzero.com
fi

echo "Connections " >> /var/www/html/status.txt

netstat -tn | grep -i esta | wc -l >> /var/www/html/status.txt 

du -shc /home/chris/Desktop/data/storj0/* >> /var/www/html/status.txt

