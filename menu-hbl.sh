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
sudo nano /opt/HBmonitor/config.py ;;
4)
sudo nano /opt/HBmonitor2/config.py ;;
6)
if systemctl status hblparrot.service |grep active >/dev/null 2>&1
then sudo systemctl stop hblparrot.service

fi
if systemctl status proxy.service |grep active >/dev/null 2>&1
then sudo systemctl stop proxy.service

fi
if systemctl status freedmr.service |grep active >/dev/null 2>&1
then sudo systemctl stop freedmr.service

fi
if systemctl status hblparrot.service |grep disable >/dev/null 2>&1
then sudo systemctl enable hblparrot.service

fi
if systemctl status freedmr.service |grep disable >/dev/null 2>&1
then sudo systemctl enable freedmr.service

fi
sudo systemctl start freedmr.service
sudo systemctl start hblparrot.service ;;
7)
sudo systemctl stop hblparrot.service
sudo systemctl disable hblparrot.service
sudo systemctl stop freedmr.service
sudo systemctl disable freedmr.service ;;
8)
(crontab -l; echo "* */1 * * * sync ; echo 3 > /proc/sys/vm/drop_caches >/dev/null 2>&1")|awk '!x[$0]++'|crontab -
cronedit.sh '*/5 * * * *' 'sh /opt/FDMR-Monitor/sysinfo/graph.sh' add &&
cronedit.sh '*/2 * * * *' 'sh /opt/FDMR-Monitor/sysinfo/cpu.sh' add &&
cronedit.sh '*/5 * * * *' 'sh /etc/freedmr/hbmon/sysinfo/graph.sh' remove &&
cronedit.sh '*/2 * * * *' 'sh /etc/freedmr/hbmon/sysinfo/cpu.sh' remove &&
cronedit.sh '* */24 * * *' 'rm /etc/freedmr/hbmon/data/*' remove &&
cronedit.sh '* */24 * * *' 'rm /opt/FDMR-Monitor/data/*' add &&
cronedit.sh '* */24 * * *' 'rm /opt/FDMR-Monitor2/data/*' remove

if systemctl status http.server-fdmr2.service |grep "service; enabled;" >/dev/null 2>&1
then sudo systemctl disable http.server-fdmr2.service

fi
if ! systemctl status http.server-fdmr.service | grep "service; enabled;" >/dev/null 2>&1; then
   sudo systemctl enable http.server-fdmr.service

fi
if systemctl status fdmr_mon2.service |grep "service; enabled;" >/dev/null 2>&1
then sudo systemctl disable fdmr_mon2.service

fi
if ! systemctl status fdmr_mon.service | grep "service; enabled;" >/dev/null 2>&1; then
    sudo systemctl enable fdmr_mon.service
fi
if ! systemctl status proxy.service | grep "service; enabled;" >/dev/null 2>&1; then
   sudo systemctl enable proxy.service

fi
#####################################
if sudo systemctl status http.server-fdmr.service |grep active >/dev/null 2>&1
then 
   sudo systemctl stop http.server-fdmr.service
fi &&
if sudo systemctl status http.server-fdmr2.service |grep active >/dev/null 2>&1
then 
   sudo systemctl stop http.server-fdmr2.service
fi
if systemctl status fdmr_mon2.service |grep active >/dev/null 2>&1
then sudo systemctl stop fdmr_mon2.service

fi
if systemctl status fdmr_mon.service |grep active >/dev/null 2>&1
then sudo systemctl stop fdmr_mon.service

fi
sudo systemctl start fdmr_mon.service
sudo systemctl start http.server-fdmr.service ;;
9)
(crontab -l; echo "* */1 * * * sync ; echo 3 > /proc/sys/vm/drop_caches >/dev/null 2>&1")|awk '!x[$0]++'|crontab -
cronedit.sh '*/5 * * * *' 'sh /opt/FDMR-Monitor/sysinfo/graph.sh' remove &&
cronedit.sh '*/2 * * * *' 'sh /opt/FDMR-Monitor/sysinfo/cpu.sh' remove &&
cronedit.sh '*/5 * * * *' 'sh /etc/freedmr/hbmon/sysinfo/graph.sh' remove &&
cronedit.sh '*/2 * * * *' 'sh /etc/freedmr/hbmon/sysinfo/cpu.sh' remove &&
cronedit.sh '* */24 * * *' 'rm /etc/freedmr/hbmon/data/*' remove &&
cronedit.sh '* */24 * * *' 'rm /opt/FDMR-Monitor/data/*' remove &&
cronedit.sh '* */24 * * *' 'rm /opt/FDMR-Monitor2/data/*' add
if systemctl status mariadb.service |grep inactive >/dev/null 2>&1
then sudo systemctl start mariadb.service

fi
if systemctl status mariadb.service |grep disable >/dev/null 2>&1
then sudo systemctl enable mariadb.service

fi
if systemctl status http.server-fdmr.service |grep "service; enabled;" >/dev/null 2>&1
then sudo systemctl disable http.server-fdmr.service

fi
if ! systemctl status http.server-fdmr2.service | grep "service; enabled;" >/dev/null 2>&1; then
   sudo systemctl enable http.server-fdmr2.service

fi
if systemctl status fdmr_mon.service |grep "service; enabled;" >/dev/null 2>&1
then sudo systemctl disable fdmr_mon.service

fi
if ! systemctl status fdmr_mon2.service | grep "service; enabled;" >/dev/null 2>&1; then
    sudo systemctl enable fdmr_mon2.service
fi
if ! systemctl status proxy.service | grep "service; enabled;" >/dev/null 2>&1; then
   sudo systemctl enable proxy.service

fi
#####################################
if sudo systemctl status http.server-fdmr.service |grep active >/dev/null 2>&1
then 
   sudo systemctl stop http.server-fdmr.service
fi &&
if sudo systemctl status http.server-fdmr2.service |grep active >/dev/null 2>&1
then 
   sudo systemctl stop http.server-fdmr2.service
fi 
if systemctl status fdmr_mon.service |grep active >/dev/null 2>&1
then sudo systemctl stop fdmr_mon.service

fi
if systemctl status fdmr_mon2.service |grep active >/dev/null 2>&1
then sudo systemctl stop fdmr_mon2.service

fi
sudo systemctl start fdmr_mon2.service
sudo systemctl start http.server-fdmr2.service ;;
10)
cronedit.sh '*/5 * * * *' 'sh /opt/FDMR-Monitor/sysinfo/graph.sh' remove
cronedit.sh '*/2 * * * *' 'sh /opt/FDMR-Monitor/sysinfo/cpu.sh' remove
cronedit.sh '* */24 * * *' 'rm /opt/FDMR-Monitor/data/*' remove
cronedit.sh '* */24 * * *' 'rm /opt/FDMR-Monitor2/data/*' remove
sudo systemctl stop fdmr_mon2.service
sudo systemctl disable fdmr_mon2.service
sudo systemctl stop http.server-fdmr2.service
sudo systemctl disable http.server-fdmr2.service
sudo systemctl stop fdmr_mon.service
sudo systemctl disable fdmr_mon.service
sudo systemctl stop http.server-fdmr.service
sudo systemctl disable http.server-fdmr.service
;; 
12)
bash -c "$(curl -fsSL https://gitlab.com/hp3icc/fdmr/-/raw/main/update.sh)";
esac
done
exit 0


EOF
################ 
sudo chmod +x /bin/menu*

