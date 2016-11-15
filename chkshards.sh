#!/bin/bash

DATE=$(date '+%b')

#  %e

# cd /home/chris/Desktop/
# ./dtdnsup storj.dtdns.net xxxxxxxxxx d
# ./dtdnsup digitalatoll.flnet.org xxxxxxxxxx d
# ./dtdnsup bbx.flnet.org xxxxxxxxxx d
# ./dtdnsup tkp.darktech.org xxxxxxxxxx d
# ./dtdnsup tawhakisoft.slyip.net xxxxxxxxxx d

cp /home/chris/Desktop/www/status.txt /home/chris/Desktop/www/statusold.txt
# md5sum /home/chris/Desktop/www/status.txt > /home/chris/Desktop/www/statusmd5.txt

echo "      " > /home/chris/Desktop/www/status.txt

# date >> /home/chris/Desktop/www/status.txt

# set for each instance running 

ls /home/chris/Desktop/data/storj0/storjshare-c23e26 -altr > /home/chris/Desktop/dir.txt

#farmer.db 

if grep "$DATE" /home/chris/Desktop/dir.txt > /dev/null; then
    echo "Operational and open to new shards." >> /home/chris/Desktop/www/status.txt
else
    echo "No new shards." >> /home/chris/Desktop/www/status.txt
    echo "" > /home/chris/Desktop/offline.txt
    ps aux | grep "storjshare" > /home/chris/Desktop/offline.txt    
fi

echo "Connections " >> /home/chris/Desktop/www/status.txt

netstat -tn | grep -i esta | wc -l >> /home/chris/Desktop/www/status.txt 

# /media/chris/* 

du -shc /home/chris/Desktop/data/storj0/* /media/chris/* >> /home/chris/Desktop/www/status.txt

df -h >> /home/chris/Desktop/www/status.txt

uname -a >> /home/chris/Desktop/www/status.txt

lscpu | grep "U MHz:" >> /home/chris/Desktop/www/status.txt
lscpu | grep "U max MHz:" >> /home/chris/Desktop/www/status.txt
lscpu | grep "U min MHz:" >> /home/chris/Desktop/www/status.txt

# remove the below two lines of not running BOINC 
# boinccmd --get_cc_status >> /home/chris/Desktop/www/status.txt
# boinccmd --get_simple_gui_info | grep "fraction done:" >> /home/chris/Desktop/www/status.txt

cd /home/chris/Downloads
if [ -e "storjshare-gui.amd64.deb" ] ;then
	echo upgrading storjshare...
	dpkg -i storjshare-gui.amd64.deb
	echo restarting storjshare... 
	/opt/storjshare/storjshare
        rm storjshare-gui.amd64.deb   
fi

if dig +noall +answer -x 8.8.8.8 | grep --quiet "google-public-dns" ;then

	echo DNS network okay >> /home/chris/Desktop/www/status.txt

        if ping -c 3 digitalatoll.flnet.org | grep "0% packet loss";then 
           echo "Connectivity issues on digitalatoll.flnet.org." >> /home/chris/Desktop/www/status.txt
        if ping -c 3 storj.dtdns.net | grep "0% packet loss";then 
           echo "Connectivity issues on storj.dtdns.net" >> /home/chris/Desktop/www/status.txt
        if ping -c 3 storj.twilightparadox.com | grep "0% packet loss";then 
           echo "Connectivity issues on storj.twilightparadox.com" >> /home/chris/Desktop/www/status.txt
        if ping -c 3 storjnode.ddns.net | grep "0% packet loss";then 
           echo "Connectivity issues on storjnode.ddns.net" >> /home/chris/Desktop/www/status.txt

else
	echo DNS network not okay >> /home/chris/Desktop/www/status.txt
      #  if ping 8.8.8.8 | grep "unknown host" ;then
      #       echo Network hosed! >> /home/chris/Desktop/www/status.txt
      #  else
      #       echo Network ping okay >> /home/chris/Desktop/www/status.txt
      #  fi 
fi

if pgrep "storjshare" > /dev/null
   then
            echo "Storjshare is running." >> /home/chris/Desktop/www/status.txt
   else
            echo "Storjshare is not running." >> /home/chris/Desktop/www/status.txt
            echo "Storjshare is not running." >> /home/chris/Desktop/offline.txt
            cat /home/chris/Desktop/www/status.txt | mailx -s "Node 1 statistics analysis prior to reboot"  aaxiomfinity@gmail.com

            cat /home/chris/Desktop/offline.txt | mailx -s "Node 1 reboot"  aaxiomfinity@gmail.com
            
            shutdown -r now
fi 

if cmp -s /home/chris/Desktop/www/statusold.txt /home/chris/Desktop/www/status.txt ; then

        echo "No Status Changes"

        # killall storjshare

	# /opt/storjshare/storjshare

        # sleep 5

        # echo "so reboot."  

        # shutdown -r now

else
   
   echo " " > /home/chris/Desktop/www/temp.txt

   diff /home/chris/Desktop/www/status.txt /home/chris/Desktop/www/statusold.txt >> /home/chris/Desktop/www/temp.txt

   cat /home/chris/Desktop/www/temp.txt | mailx -s "Node 1 statistics analysis"  aaxiomfinity@gmail.com

fi

# md5sum  > /home/chris/Desktop/www/statusoldmd5.txt
# md5sum /home/chris/Desktop/www/status.txt > /home/chris/Desktop/www/statusmd5.txt
# md5sum /home/chris/Desktop/www/statusold.txt > /home/chris/Desktop/www/statusoldmd5.txt
# md5sum /home/chris/Desktop/www/status.txt > /home/chris/Desktop/www/statusmd5.txt

