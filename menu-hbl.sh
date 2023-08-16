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
5 " Start-Restart HBLink Server  " \
6 " Stop HBLink SERVER " \
7 " Select Dashboard HBMon 1" \
8 " Select Dashboard HBMon 2" \
9 " Stop Dashboard " \
10 " Menu update " 3>&1 1>&2 2>&3)
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
sudo nano /opt/HBlink3/hblink.cfg ;;
2)
sudo nano /opt/HBlink3/rules.py ;;
3)
sudo nano /opt/HBmonitor/config.py &&
if systemctl status hbmon.service |grep "service; enabled;" >/dev/null 2>&1
then sudo systemctl restart hbmon.service

fi;;
4)
sudo nano /opt/HBmonitor2/config.py &&
if systemctl status hbmon2.service |grep "service; enabled;" >/dev/null 2>&1
then sudo systemctl restart hbmon2.service

fi;;
5)
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
6)
sudo systemctl stop hblparrot.service
sudo systemctl disable hblparrot.service
sudo systemctl stop hblink.service
sudo systemctl disable hblink.service ;;
7)
(crontab -l; echo "* */1 * * * sync ; echo 3 > /proc/sys/vm/drop_caches >/dev/null 2>&1")|awk '!x[$0]++'|crontab -
rm /opt/HBmonitor/*.json
rm /opt/HBmonitor/log/*
(crontab -l | grep -v "sh /opt/HBmonitor2/sysinfo/graph.sh") | crontab -
(crontab -l | grep -v "sh /opt/HBmonitor2/sysinfo/cpu.sh") | crontab -

if systemctl status hbmon2.service |grep "service; enabled;" >/dev/null 2>&1
then sudo systemctl disable hbmon2.service

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
sudo systemctl start hbmon.service ;;
8)
(crontab -l; echo "* */1 * * * sync ; echo 3 > /proc/sys/vm/drop_caches >/dev/null 2>&1")|awk '!x[$0]++'|crontab -
(crontab -l; echo "*/5 * * * * sh /opt/HBmonitor2/sysinfo/graph.sh")|awk '!x[$0]++'|crontab -
(crontab -l; echo "*/2 * * * * sh /opt/HBmonitor2/sysinfo/cpu.sh")|awk '!x[$0]++'|crontab -
rm /opt/HBmonitor2/*.json
rm /opt/HBmonitor2/log/*
sh /opt/HBmonitor2/sysinfo/rrd-db.sh &&
sh /opt/HBmonitor2/sysinfo/graph.sh
sleep 1
sh /opt/HBmonitor2/sysinfo/cpu.sh

if systemctl status hbmon.service |grep "service; enabled;" >/dev/null 2>&1
then sudo systemctl disable hbmon.service

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
sudo systemctl start hbmon2.service ;;
9)
(crontab -l | grep -v "sh /opt/HBmonitor2/sysinfo/graph.sh") | crontab -
(crontab -l | grep -v "sh /opt/HBmonitor2/sysinfo/cpu.sh") | crontab -

sudo systemctl stop hbmon2.service
sudo systemctl disable hbmon2.service
sudo systemctl stop hbmon.service
sudo systemctl disable hbmon.service ;; 
10)
bash -c "$(curl -fsSL https://gitlab.com/hp3icc/easy-hbl/-/raw/main/update.sh)";
esac
done
exit 0


EOF
################ 
sudo chmod +x /bin/menu*

