#!/bin/bash

DATE=$(date '+%b')

#  %e

# cd /home/chris/Desktop/
# ./dtdnsup storj.dtdns.net xxxxxxxxxx d
# ./dtdnsup digitalatoll.flnet.org xxxxxxxxxx d
# ./dtdnsup bbx.flnet.org xxxxxxxxxx d
# ./dtdnsup tkp.darktech.org xxxxxxxxxx d
# ./dtdnsup tawhakisoft.slyip.net xxxxxxxxxx d

cp /home/chris/Desktop/www/nodestatus.txt /home/chris/Desktop/www/old_nodestatus.txt
# md5sum /home/chris/Desktop/www/nodestatus.txt > /home/chris/Desktop/www/statusmd5.txt

echo "      " > /home/chris/Desktop/www/nodestatus.txt

# date >> /home/chris/Desktop/www/nodestatus.txt

# set for each instance running 

ls /media/chris/ -altRr | grep ".ldb" > /home/chris/Desktop/dir.txt

#farmer.db 

if grep "$DATE" /home/chris/Desktop/dir.txt > /dev/null; then
    echo "Operational and open to new shards." >> /home/chris/Desktop/www/nodestatus.txt
else
    echo "No new shards." >> /home/chris/Desktop/www/nodestatus.txt
    ps aux | grep "storjshare" >> /home/chris/Desktop/www/nodestatus.txt   
fi

echo "Connections " >> /home/chris/Desktop/www/nodestatus.txt

netstat -tn | grep -i esta | wc -l >> /home/chris/Desktop/www/nodestatus.txt 

echo "Contracts " >> /home/chris/Desktop/www/nodestatus.txt

cat "/home/chris/.config/Storj Share/settings.json" | grep "total" >> /home/chris/Desktop/www/nodestatus.txt

cat "/home/chris/.config/Storj Share/settings.json" | grep "size"  >> /home/chris/Desktop/www/nodestatus.txt


# /media/chris/* 

du -shc /media/chris/* >> /home/chris/Desktop/www/nodestatus.txt

df -h >> /home/chris/Desktop/www/nodestatus.txt

uname -a >> /home/chris/Desktop/www/nodestatus.txt

lscpu | grep "U MHz:" >> /home/chris/Desktop/www/nodestatus.txt
lscpu | grep "U max MHz:" >> /home/chris/Desktop/www/nodestatus.txt
lscpu | grep "U min MHz:" >> /home/chris/Desktop/www/nodestatus.txt

# remove the below two lines of not running BOINC 
# boinccmd --get_cc_status >> /home/chris/Desktop/www/nodestatus.txt
# boinccmd --get_simple_gui_info | grep "fraction done:" >> /home/chris/Desktop/www/nodestatus.txt

cd /home/chris/Downloads
if [ -e "storjshare-gui.amd64.deb" ] ;then
	echo upgrading storjshare...
	dpkg -i storjshare-gui.amd64.deb
	echo restarting storjshare... 
	/opt/storjshare/storjshare
        rm storjshare-gui.amd64.deb   
fi

if dig +noall +answer -x 8.8.8.8 | grep --quiet "google-public-dns" ;then

	echo DNS network okay >> /home/chris/Desktop/www/nodestatus.txt

        if ping -c 3 digitalatoll.flnet.org | grep "0 received" ;then
                echo "Connectivity issues digitalatoll.flnet.org" >> /home/chris/Desktop/www/nodestatus.txt
           else 
                echo "digitalatoll.flnet.org online" >> /home/chris/Desktop/www/nodestatus.txt
        fi
        if ping -c 3 storj.dtdns.net | grep "0 received" ;then
                echo "Connectivity issues storj.dtdns.net" >> /home/chris/Desktop/www/nodestatus.txt
           else 
                echo "storj.dtdns.net online" >> /home/chris/Desktop/www/nodestatus.txt
        fi
        if ping -c 3 storj.twilightparadox.com | grep "0 received" ;then
                echo "Connectivity issues storj.twilightparadox.com" >> /home/chris/Desktop/www/nodestatus.txt
           else 
                echo "storj.twilightparadox.com online" >> /home/chris/Desktop/www/nodestatus.txt
        fi
        if ping -c 3 storjnode.ddns.net | grep "0 received" ;then
                echo "Connectivity issues storjnode.ddns.net" >> /home/chris/Desktop/www/nodestatus.txt
           else 
                echo "storjnode.ddns.net online" >> /home/chris/Desktop/www/nodestatus.txt
        fi

else

	echo DNS network not okay >> /home/chris/Desktop/www/nodestatus.txt
      #  if ping 8.8.8.8 | grep "unknown host" ;then
      #       echo Network hosed! >> /home/chris/Desktop/www/nodestatus.txt
      #  else
      #       echo Network ping okay >> /home/chris/Desktop/www/nodestatus.txt
      #  fi 
fi
echo "SMART DATA for sda ">> /home/chris/Desktop/www/nodestatus.txt
smartctl -a /dev/sda | grep "self-assessment test result" >> /home/chris/Desktop/www/nodestatus.txt
echo "SMART DATA for sdb ">> /home/chris/Desktop/www/nodestatus.txt
smartctl -a /dev/sdb | grep "self-assessment test result" >> /home/chris/Desktop/www/nodestatus.txt

if pgrep "storjshare" > /dev/null
   then

            echo "Storjshare is running." >> /home/chris/Desktop/www/nodestatus.txt
            echo "Storjshare is running." > /home/chris/Desktop/www/storjshare_status.txt
   else

            smartctl -a /dev/sda >> /home/chris/Desktop/www/nodestatus.txt
            smartctl -a /dev/sdb >> /home/chris/Desktop/www/nodestatus.txt

            echo "Storjshare is not running." >> /home/chris/Desktop/www/nodestatus.txt
            echo "Storjshare is not running." > /home/chris/Desktop/www/storjshare_status.txt

            cat /home/chris/Desktop/www/nodestatus.txt | mailx -s "Node 1 statistics analysis abd reboot"  aaxiomfinity@gmail.com
           
            shutdown -r now
fi 

if cmp -s /home/chris/Desktop/www/old_nodestatus.txt /home/chris/Desktop/www/nodestatus.txt ; then

        echo "No Status Changes"

        # killall storjshare

	# /opt/storjshare/storjshare

        # sleep 5

        # echo "so reboot."  

        # shutdown -r now

else
   
   echo " " > /home/chris/Desktop/www/temp.txt

   diff /home/chris/Desktop/www/nodestatus.txt /home/chris/Desktop/www/old_nodestatus.txt >> /home/chris/Desktop/www/temp.txt

   cat /home/chris/Desktop/www/temp.txt | mailx -s "Node 1 statistics analysis"  aaxiomfinity@gmail.com

fi

# md5sum  > /home/chris/Desktop/www/statusoldmd5.txt
# md5sum /home/chris/Desktop/www/nodestatus.txt > /home/chris/Desktop/www/statusmd5.txt
# md5sum /home/chris/Desktop/www/old_nodestatus.txt > /home/chris/Desktop/www/statusoldmd5.txt
# md5sum /home/chris/Desktop/www/nodestatus.txt > /home/chris/Desktop/www/statusmd5.txt

