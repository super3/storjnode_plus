#!/bin/bash

DATE=$(date '+%b')

#  %e

# cd /home/chris/Desktop/
# ./dtdnsup storj.dtdns.net xxxxxxxxxx d
# ./dtdnsup digitalatoll.flnet.org xxxxxxxxxx d
# ./dtdnsup bbx.flnet.org xxxxxxxxxx d
# ./dtdnsup tkp.darktech.org xxxxxxxxxx d
# ./dtdnsup tawhakisoft.slyip.net xxxxxxxxxx d

date > /var/www/html/status.txt

ls /home/chris/Desktop/data/storj0/farmer.db -altr > /home/chris/Desktop/dir.txt
# ls "/media/chris/TOSHIBA EXT/storj1/farmer.db" -altr >> /home/chris/Desktop/dir.txt

if grep "$DATE" /home/chris/Desktop/dir.txt > /dev/null; then
    echo "Operational and open to new shards." >> /var/www/html/status.txt
else
    echo "No new shards." >> /var/www/html/status.txt
    echo "" > /home/chris/Desktop/offline.txt
    ps aux | grep "storjshare" > /home/chris/Desktop/offline.txt    
fi

echo "Connections " >> /var/www/html/status.txt

netstat -tn | grep -i esta | wc -l >> /var/www/html/status.txt 

du -shc /home/chris/Desktop/data/storj0/* /media/chris/* >> /var/www/html/status.txt

df -h >> /var/www/html/status.txt

if pgrep "storjshare" > /dev/null
   then
            echo "Storjshare is running." >> /var/www/html/status.txt
   else
            echo "Storjshare is not running." >> /var/www/html/status.txt
            echo "Storjshare is not running." >> /home/chris/Desktop/offline.txt
            cat /home/chris/Desktop/offline.txt | mailx -s "Node 1 statistics analysis"  axiomfinity@netzero.com
            # shutdown -r now
fi 

