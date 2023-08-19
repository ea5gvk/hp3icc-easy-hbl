#!/bin/sh
sudo cat > /bin/menu-hbl <<- "EOF"
#!/bin/bash
if [[ $EUID -ne 0 ]]; then
        whiptail --title "sudo su" --msgbox "requiere ser usuario root , escriba (sudo su) antes de entrar a menu / requires root user, type (sudo su) before entering menu" 0 50
        exit 0
fi
while : ; do
choix=$(whiptail --title "Raspbian Proyect HP3ICC HBL+" --menu "move up or down with the keyboard arrows and select your option by pressing enter:" 23 56 13 \
1 " Edit HBLink Server " \
2 " Edit Interlink  " \
3 " Edit HBMon 1 " \
4 " Edit HBMon 2 " \
5 " Edit HBMon JSon " \
6 " Start-Restart HBLink Server  " \
7 " Stop HBLink SERVER " \
8 " Select Dashboard HBMon-1" \
9 " Select Dashboard HBMon-2" \
10 " Select Dashboard HBMon-Json" \
11 " Stop Dashboard " \
12 " Menu update " 3>&1 1>&2 2>&3)
exitstatus=$?
#on recupere ce choix
#exitstatus=$?
if [ $exitstatus = 0 ]; then
    echo "Your chosen option:" $choix
else
    echo "You chose cancel."; break;
fi
# case : action en fonction du choix
case $choix in
1)
sudo nano /opt/HBlink3/hblink.cfg
if systemctl status hblink.service |grep "service; enabled;" >/dev/null 2>&1
then sudo systemctl restart hblink.service
  if systemctl status hbmon.service |grep "service; enabled;" >/dev/null 2>&1
  then sudo systemctl restart hbmon.service
    else
      if systemctl status hbmon2.service |grep "service; enabled;" >/dev/null 2>&1
      then sudo systemctl restart hbmon2.service
         else
           if systemctl status hbmon-js.service |grep "service; enabled;" >/dev/null 2>&1
           then sudo systemctl restart hbmon-js.service
        fi           
    fi
  fi
fi;;
2)
sudo nano /opt/HBlink3/rules.py
if systemctl status hblink.service |grep "service; enabled;" >/dev/null 2>&1
then sudo systemctl restart hblink.service
  if systemctl status hbmon.service |grep "service; enabled;" >/dev/null 2>&1
  then sudo systemctl restart hbmon.service
    else
      if systemctl status hbmon2.service |grep "service; enabled;" >/dev/null 2>&1
      then sudo systemctl restart hbmon2.service
         else
           if systemctl status hbmon-js.service |grep "service; enabled;" >/dev/null 2>&1
           then sudo systemctl restart hbmon-js.service
        fi           
    fi
  fi
fi ;;
3)
sudo nano /opt/HBmonitor/config.py &&
if systemctl status hbmon.service |grep "service; enabled;" >/dev/null 2>&1
then sudo systemctl restart hbmon.service

fi ;;
4)
sudo nano /opt/HBmonitor2/config.py &&
if systemctl status hbmon2.service |grep "service; enabled;" >/dev/null 2>&1
then sudo systemctl restart hbmon2.service

fi;;
5)
sudo nano /opt/HBJson/config.py &&
if systemctl status hbmon-js.service |grep "service; enabled;" >/dev/null 2>&1
then sudo systemctl restart hbmon-js.service

fi;;
6)
if systemctl status hblparrot.service |grep active >/dev/null 2>&1
then sudo systemctl stop hblparrot.service

fi
if systemctl status hblink.service |grep active >/dev/null 2>&1
then sudo systemctl stop hblink.service

fi
if systemctl status hblparrot.service |grep disable >/dev/null 2>&1
then sudo systemctl enable hblparrot.service

fi
if systemctl status hblink.service |grep disable >/dev/null 2>&1
then sudo systemctl enable hblink.service

fi
sudo systemctl start hblink.service
sudo systemctl start hblparrot.service ;;
7)
sudo systemctl stop hblparrot.service
sudo systemctl disable hblparrot.service
sudo systemctl stop hblink.service
sudo systemctl disable hblink.service ;;
8)
(crontab -l; echo "* */1 * * * sync ; echo 3 > /proc/sys/vm/drop_caches >/dev/null 2>&1")|awk '!x[$0]++'|crontab -
if [ -n "$(ls -A /opt/HBmonitor/log/)" ]; then
    rm /opt/HBmonitor/log/*
fi
if [ -f "/opt/HBmonitor/talkgroup_ids.json" ]
then
  rm /opt/HBmonitor/talkgroup_ids.json
fi
if [ -f "/opt/HBmonitor/subscriber_ids.jsonn" ]
then
  rm /opt/HBmonitor/subscriber_ids.json
fi
if [ -f "/opt/HBmonitor/peer_ids.json " ]
then
  rm /opt/HBmonitor/peer_ids.json 
fi
(crontab -l | grep -v "sh /opt/HBmonitor2/sysinfo/graph.sh") | crontab -
(crontab -l | grep -v "sh /opt/HBmonitor2/sysinfo/cpu.sh") | crontab -

if systemctl status hbmon2.service |grep "service; enabled;" >/dev/null 2>&1
then sudo systemctl disable hbmon2.service

fi
if systemctl status hbmon-js.service |grep "service; enabled;" >/dev/null 2>&1
then sudo systemctl disable hbmon-js.service

fi
if ! systemctl status hbmon.service | grep "service; enabled;" >/dev/null 2>&1; then
    sudo systemctl enable hbmon.service
fi

#####################################
if systemctl status hbmon2.service |grep active >/dev/null 2>&1
then sudo systemctl stop hbmon2.service

fi
if systemctl status hbmon.service |grep active >/dev/null 2>&1
then sudo systemctl stop hbmon.service

fi
if systemctl status hbmon-js.service |grep active >/dev/null 2>&1
then sudo systemctl stop hbmon-js.service

fi
sudo systemctl start hbmon.service ;;
9)
(crontab -l; echo "* */1 * * * sync ; echo 3 > /proc/sys/vm/drop_caches >/dev/null 2>&1")|awk '!x[$0]++'|crontab -
(crontab -l; echo "*/5 * * * * sh /opt/HBmonitor2/sysinfo/graph.sh")|awk '!x[$0]++'|crontab -
(crontab -l; echo "*/2 * * * * sh /opt/HBmonitor2/sysinfo/cpu.sh")|awk '!x[$0]++'|crontab -
if [ -n "$(ls -A /opt/HBmonitor2/log/)" ]; then
    rm /opt/HBmonitor2/log/*
fi
if [ -f "/opt/HBmonitor2/talkgroup_ids.json" ]
then
  rm /opt/HBmonitor2/talkgroup_ids.json
fi
if [ -f "/opt/HBmonitor2/subscriber_ids.jsonn" ]
then
  rm /opt/HBmonitor2/subscriber_ids.json
fi
if [ -f "/opt/HBmonitor2/peer_ids.json " ]
then
  rm /opt/HBmonitor2/peer_ids.json 
fi
sh /opt/HBmonitor2/sysinfo/rrd-db.sh &&
sh /opt/HBmonitor2/sysinfo/graph.sh
sleep 1
sh /opt/HBmonitor2/sysinfo/cpu.sh

if systemctl status hbmon.service |grep "service; enabled;" >/dev/null 2>&1
then sudo systemctl disable hbmon.service

fi
if systemctl status hbmon-js.service |grep "service; enabled;" >/dev/null 2>&1
then sudo systemctl disable hbmon-js.service

fi
if ! systemctl status hbmon2.service | grep "service; enabled;" >/dev/null 2>&1; then
    sudo systemctl enable hbmon2.service
fi

#####################################

if systemctl status hbmon.service |grep active >/dev/null 2>&1
then sudo systemctl stop hbmon.service

fi
if systemctl status hbmon2.service |grep active >/dev/null 2>&1
then sudo systemctl stop hbmon2.service

fi
if systemctl status hbmon-js.service |grep active >/dev/null 2>&1
then sudo systemctl stop hbmon-js.service

fi
sudo systemctl start hbmon2.service ;;
10)
(crontab -l | grep -v "sh /opt/HBmonitor2/sysinfo/graph.sh") | crontab -
(crontab -l | grep -v "sh /opt/HBmonitor2/sysinfo/cpu.sh") | crontab -
if [ -n "$(ls -A /opt/HBJson/log/)" ]; then
    rm /opt/HBJson/log/*
fi
if [ -f "/opt/HBJson/talkgroup_ids.json" ]
then
  rm /opt/HBJson/talkgroup_ids.json
fi
if [ -f "/opt/HBJson/subscriber_ids.jsonn" ]
then
  rm /opt/HBJson/subscriber_ids.json
fi
if [ -f "/opt/HBJson/peer_ids.json " ]
then
  rm /opt/HBJson/peer_ids.json 
fi
if systemctl status hbmon.service |grep "service; enabled;" >/dev/null 2>&1
then sudo systemctl disable hbmon.service

fi
if systemctl status hbmon2.service |grep "service; enabled;" >/dev/null 2>&1
then sudo systemctl disable hbmon2.service

fi
if ! systemctl status hbmon-js.service | grep "service; enabled;" >/dev/null 2>&1; then
    sudo systemctl enable hbmon-js.service
fi

#####################################

if systemctl status hbmon.service |grep active >/dev/null 2>&1
then sudo systemctl stop hbmon.service

fi
if systemctl status hbmon2.service |grep active >/dev/null 2>&1
then sudo systemctl stop hbmon2.service

fi
if systemctl status hbmon-js.service |grep active >/dev/null 2>&1
then sudo systemctl stop hbmon-js.service

fi
sudo systemctl start hbmon-js.service ;;
11)
(crontab -l | grep -v "sh /opt/HBmonitor2/sysinfo/graph.sh") | crontab -
(crontab -l | grep -v "sh /opt/HBmonitor2/sysinfo/cpu.sh") | crontab -

if systemctl status hbmon2.service |grep "service; enabled;" >/dev/null 2>&1
then sudo systemctl disable hbmon2.service

fi
if systemctl status hbmon.service |grep "service; enabled;" >/dev/null 2>&1
then sudo systemctl disable hbmon.service

fi
if systemctl status hbmon-js.service |grep "service; enabled;" >/dev/null 2>&1
then sudo systemctl disable hbmon-js.service

fi
###############
if systemctl status hbmon.service |grep active >/dev/null 2>&1
then sudo systemctl stop hbmon.service

fi
if systemctl status hbmon2.service |grep active >/dev/null 2>&1
then sudo systemctl stop hbmon2.service

fi
if systemctl status hbmon-js.service |grep active >/dev/null 2>&1
then sudo systemctl stop hbmon-js.service

fi ;; 
12)
bash -c "$(curl -fsSL https://gitlab.com/hp3icc/easy-hbl/-/raw/main/update.sh)";
esac
done
exit 0


EOF
################ 
sudo chmod +x /bin/menu*

