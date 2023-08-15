#!/bin/sh
if [[ $EUID -ne 0 ]]; then
	whiptail --title "FDMR+" --msgbox "Debe ejecutar este script como usuario ROOT" 0 50
	exit 0
fi
######################################################################################################################
(crontab -l; echo "* */1 * * * sync ; echo 3 > /proc/sys/vm/drop_caches >/dev/null 2>&1")|awk '!x[$0]++'|crontab -
# apt-get upgrade -y
######################################################################################################################

apps=("wget" "git" "sudo" "python3" "python3-pip" "python3-distutils")

# Función para verificar e instalar una aplicación
check_and_install() {
    app=$1
    if ! dpkg -s $app 2>/dev/null | grep -q "Status: install ok installed"; then
        echo "$app no está instalado. Instalando..."
        sudo apt-get install -y $app
        echo "$app instalado correctamente."
    else
        echo "$app ya está instalado."
    fi
}

# Verificar e instalar cada aplicación
for app in "${apps[@]}"; do
    check_and_install $app
done
#install hblink

cd /opt/
#wget https://bootstrap.pypa.io/get-pip.py
#python3 get-pip.py
#############
apt-get install python3-venv -y
python3 -m venv env0
source env0/bin/activate
pip3 install --upgrade pip
pip install pyopenssl --upgrade
deactivate

##################

apps=("python3-twisted" "python3-bitarray" "python3-dev")

# Función para verificar e instalar una aplicación
check_and_install() {
    app=$1
    if ! dpkg -s $app 2>/dev/null | grep -q "Status: install ok installed"; then
        echo "$app no está instalado. Instalando..."
        sudo apt-get install -y $app
        echo "$app instalado correctamente."
    else
        echo "$app ya está instalado."
    fi
}

# Verificar e instalar cada aplicación
for app in "${apps[@]}"; do
    check_and_install $app
done
if [ -d "/opt/backup" ]
then
   sudo rm -rf /opt/backup
fi
if [ -d "/opt/HBmonitor" ]
then
   sudo rm -rf /opt/HBmonitor
fi
if [ -d "/opt/HBmonitor2" ]
then
   sudo rm -rf /opt/HBmonitor2
fi
if [ -d "/opt/HBlink3" ]
then
   sudo rm -rf /opt/HBlink3
fi
if [ -d "/opt/dmr_utils3" ]
then
   sudo rm -rf /opt/dmr_utils3
fi
if [ -d "/var/log/hblink" ]
then
   sudo rm -rf /var/log/hblink
fi
mkdir /var/log/hblink
mkdir /opt/backup/
cd /opt/
git clone r /opt/backup/
mv /opt/backup/dmr_utils3/ /opt/
#mv /opt/HBlink3/ /opt/backup/

#mv /opt/backup/HBlink3/ /opt/
cd /opt/
git clone https://github.com/iu7igu/hblink3-aprs.git /opt/HBlink3
cd /opt/HBlink3
sudo git checkout private-call
sudo pip install -U -r requirements.txt
#chmod +x install.sh

#./install.sh
###########################     hbmonitor 1
#mv /opt/backup/HBmonitor/ /opt/
cd /opt/
git clone https://github.com/sp2ong/HBmonitor.git /opt/HBmonitor
cd /opt/HBmonitor/
#sudo git checkout webserver-python
chmod +x install.sh
./install.sh
rm /opt/HBmonitor/log/*
rm /opt/HBmonitor/*.json
cp /opt/HBmonitor/config_SAMPLE.py /opt/HBmonitor/config.py
#cp /opt/HBmonitor/utils/hbmon.service /lib/systemd/system/
cp /opt/HBmonitor/index_template.html /opt/HBmonitor/index.html
#nano /opt/HBmonitor/config.py

sed -i "s/<br><br>.*/ Proyect : <a href=\"https:\/\/gitlab.com\/hp3icc\/Easy-HBL\/\" target=\"_blank\">Easy-HBL+<\/a><br\/><br\/><\/span>/g" /opt/HBmonitor/*.html
#sed -i "s/<img src=.*/<img src=\"data:image\/HBlink.png\"\/>/g" /opt/HBmonitor/*.html
<img src=
sed -i "s/WEB_AUTH =.*/WEB_AUTH =  False/g" /opt/HBmonitor/config.py
sed -i "s/WEB_SERVER_PORT =.*/WEB_SERVER_PORT = 80/g" /opt/HBmonitor/config.py
sed -i "s/FILE_RELOAD     =.*/FILE_RELOAD     = 1/g" /opt/HBmonitor/config.py
sed -i "s/SUBSCRIBER_URL  =.*/SUBSCRIBER_URL  = 'http:\/\/datafiles.ddns.net:8888\/user.json'/g" /opt/HBmonitor/config.py
#wget http://downloads.freedmr.uk/downloads/talkgroup_ids.json -O /opt/HBmonitor/talkgroup_ids.json
 
if [ "$(cat /opt/HBmonitor/config.py | grep 'TGID_URL')" != "" ]; then
sed -i "s/TGID_URL.*/TGID_URL        = 'http:\/\/datafiles.ddns.net:8888\/talkgroup_ids.json'/g" /opt/HBmonitor/config.py
else
sed "32 a TGID_URL        = 'http://datafiles.ddns.net:8888/talkgroup_ids.json'" -i /opt/HBmonitor/config.py 
fi
if ! grep -q 'TGID_URL' /opt/HBmonitor/monitor.py; then
    sed "848 a \   " -i /opt/HBmonitor/monitor.py
    sed "848 a \    logging.info(result)" -i /opt/HBmonitor/monitor.py
    sed "848 a \    result = try_download(PATH, TGID_FILE, TGID_URL, (FILE_RELOAD * 86400))" -i /opt/HBmonitor/monitor.py
    sed "848 a \   " -i /opt/HBmonitor/monitor.py
fi

sudo cat > /lib/systemd/system/hbmon.service <<- "EOF"
[Unit]
Description=HBMonitor
# To make the network-online.target available
# systemctl enable systemd-networkd-wait-online.service

After=network-online.target syslog.target
Wants=network-online.target

[Service]
StandardOutput=null
WorkingDirectory=/opt/HBmonitor
RestartSec=3
ExecStart=/usr/bin/python3 /opt/HBmonitor/monitor.py
Restart=on-abort

[Install]
WantedBy=multi-user.target

EOF
##############################  hbmon2
cd /opt/
git clone https://github.com/sp2ong/HBMonv2.git /opt/HBmonitor2
cd /opt/HBmonitor2/
sudo git checkout webserver-python
chmod +x install.sh
./install.sh
#mv /opt/backup/dmr_utils3/ /opt/
rm /opt/HBmonitor2/log/*
rm /opt/HBmonitor2/*.json
cp /opt/HBmonitor2/config_SAMPLE.py /opt/HBmonitor2/config.py
#cp /opt/HBmonitor/utils/hbmon.service /lib/systemd/system/
cp /opt/HBmonitor2/index_template.html /opt/HBmonitor2/index.html
#nano /opt/HBmonitor/config.py

sed -i "s/<br><br>.*/ Proyect : <a href=\"https:\/\/gitlab.com\/hp3icc\/Easy-HBL\/\" target=\"_blank\">Easy-HBL+<\/a><br\/><br\/><\/span>/g" /opt/HBmonitor2/templates/*.html

sed -i "s/WEB_AUTH =.*/WEB_AUTH =  False/g" /opt/HBmonitor2/config.py
sed -i "s/WEB_SERVER_PORT =.*/WEB_SERVER_PORT = 80/g" /opt/HBmonitor2/config.py
sed -i "s/FILE_RELOAD     =.*/FILE_RELOAD     = 1/g" /opt/HBmonitor2/config.py
sed -i "s/SUBSCRIBER_URL  =.*/SUBSCRIBER_URL  = 'http:\/\/datafiles.ddns.net:8888\/user.json'/g" /opt/HBmonitor2/config.py
#wget http://downloads.freedmr.uk/downloads/talkgroup_ids.json -O /opt/HBmonitor/talkgroup_ids.json
 
if [ "$(cat /opt/HBmonitor2/config.py | grep 'TGID_URL')" != "" ]; then
sed -i "s/TGID_URL.*/TGID_URL        = 'http:\/\/datafiles.ddns.net:8888\/talkgroup_ids.json'/g" /opt/HBmonitor2/config.py
else
sed "59 a TGID_URL        = 'http://datafiles.ddns.net:8888/talkgroup_ids.json'" -i /opt/HBmonitor2/config.py 
fi
if ! grep -q 'TGID_URL' /opt/HBmonitor2/monitor.py; then
    sed "1046 a \   " -i /opt/HBmonitor2/monitor.py
    sed "1046 a \    logging.info(result)" -i /opt/HBmonitor2/monitor.py
    sed "1046 a \    result = try_download(PATH, TGID_FILE, TGID_URL, (FILE_RELOAD * 86400))" -i /opt/HBmonitor2/monitor.py
    sed "1046 a \   " -i /opt/HBmonitor2/monitor.py
fi

sudo cat > /lib/systemd/system/hbmon2.service <<- "EOF"
[Unit]
Description=HBMonitor2
# To make the network-online.target available
# systemctl enable systemd-networkd-wait-online.service

After=network-online.target syslog.target
Wants=network-online.target

[Service]
StandardOutput=null
WorkingDirectory=/opt/HBmonitor2
RestartSec=3
ExecStart=/usr/bin/python3 /opt/HBmonitor2/monitor.py
Restart=on-abort

[Install]
WantedBy=multi-user.target

EOF
##############################
cd /opt/dmr_utils3

chmod +x install.sh

./install.sh

/usr/bin/python3 -m pip install --upgrade pip

pip install --upgrade dmr_utils3

cd /opt/HBlink3
#Install Parrot for Echotest:

chmod +x playback.py

#cp hblink-SAMPLE.cfg hblink.cfg
##################
#sed -i "s/LOG_FILE:.*/LOG_FILE: /var/log/hblink/g" /opt/HBmonitor/config.py
#Create directory for registration files, if /var/log/hblink is not created.
#cp rules-SAMPLE.py rules.py

rm -r /opt/backup/
sudo cat > /opt/HBlink3/hblink.cfg <<- "EOFX"
# PROGRAM-WIDE PARAMETERS GO HERE
# PATH - working path for files, leave it alone unless you NEED to change it
# PING_TIME - the interval that peers will ping the master, and re-try registraion
#           - how often the Master maintenance loop runs
# MAX_MISSED - how many pings are missed before we give up and re-register
#           - number of times the master maintenance loop runs before de-registering a peer
#
# ACLs:
#
# Access Control Lists are a very powerful tool for administering your system.
# But they consume packet processing time. Disable them if you are not using them.
# But be aware that, as of now, the configuration stanzas still need the ACL
# sections configured even if you're not using them.
#
# REGISTRATION ACLS ARE ALWAYS USED, ONLY SUBSCRIBER AND TGID MAY BE DISABLED!!!
#
# The 'action' May be PERMIT|DENY
# Each entry may be a single radio id, or a hypenated range (e.g. 1-2999)
# Format:
# 	ACL = 'action:id|start-end|,id|start-end,....'
#		--for example--
#	SUB_ACL: DENY:1,1000-2000,4500-60000,17
#
# ACL Types:
# 	REG_ACL: peer radio IDs for registration (only used on HBP master systems)
# 	SUB_ACL: subscriber IDs for end-users
# 	TGID_TS1_ACL: destination talkgroup IDs on Timeslot 1
# 	TGID_TS2_ACL: destination talkgroup IDs on Timeslot 2
#
# ACLs may be repeated for individual systems if needed for granularity
# Global ACLs will be processed BEFORE the system level ACLs
# Packets will be matched against all ACLs, GLOBAL first. If a packet 'passes'
# All elements, processing continues. Packets are discarded at the first
# negative match, or 'reject' from an ACL element.
#
# If you do not wish to use ACLs, set them to 'PERMIT:ALL'
# TGID_TS1_ACL in the global stanza is used for OPENBRIDGE systems, since all
# traffic is passed as TS 1 between OpenBridges
[GLOBAL]
PATH: ./
PING_TIME: 5
MAX_MISSED: 3
USE_ACL: True
REG_ACL: PERMIT:ALL
SUB_ACL: DENY:1
TGID_TS1_ACL: PERMIT:ALL
TGID_TS2_ACL: PERMIT:ALL

[APRS]
ENABLED: False
REPORT_INTERVAL: 15
CALLSIGN:HB1LNK-11
SERVER:euro.aprs2.net
MESSAGE:Connesso ad HBLINK

# NOT YET WORKING: NETWORK REPORTING CONFIGURATION
#   Enabling "REPORT" will configure a socket-based reporting
#   system that will send the configuration and other items
#   to a another process (local or remote) that may process
#   the information for some useful purpose, like a web dashboard.
#
#   REPORT - True to enable, False to disable
#   REPORT_INTERVAL - Seconds between reports
#   REPORT_PORT - TCP port to listen on if "REPORT_NETWORKS" = NETWORK
#   REPORT_CLIENTS - comma separated list of IPs you will allow clients
#       to connect on. Entering a * will allow all.
#
# ****FOR NOW MUST BE TRUE - USE THE LOOPBACK IF YOU DON'T USE THIS!!!****
[REPORTS]
REPORT: True
REPORT_INTERVAL: 1
REPORT_PORT: 4321
REPORT_CLIENTS: 127.0.0.1


# SYSTEM LOGGER CONFIGURAITON
#   This allows the logger to be configured without chaning the individual
#   python logger stuff. LOG_FILE should be a complete path/filename for *your*
#   system -- use /dev/null for non-file handlers.
#   LOG_HANDLERS may be any of the following, please, no spaces in the
#   list if you use several:
#       null
#       console
#       console-timed
#       file
#       file-timed
#       syslog
#   LOG_LEVEL may be any of the standard syslog logging levels, though
#   as of now, DEBUG, INFO, WARNING and CRITICAL are the only ones
#   used.
#
[LOGGER]
LOG_FILE: /var/log/hblink/hblink.log
LOG_HANDLERS: console-timed
LOG_LEVEL: DEBUG
LOG_NAME: HBlink

# DOWNLOAD AND IMPORT SUBSCRIBER, PEER and TGID ALIASES
# Ok, not the TGID, there's no master list I know of to download
# This is intended as a facility for other applcations built on top of
# HBlink to use, and will NOT be used in HBlink directly.
# STALE_DAYS is the number of days since the last download before we
# download again. Don't be an ass and change this to less than a few days.
[ALIASES]
TRY_DOWNLOAD: False
PATH: ./
PEER_FILE: peer_ids.json
SUBSCRIBER_FILE: subscriber_ids.json
TGID_FILE: talkgroup_ids.json
PEER_URL: https://www.radioid.net/static/rptrs.json
SUBSCRIBER_URL: https://www.radioid.net/static/users.json
STALE_DAYS: 7

# OPENBRIDGE INSTANCES - DUPLICATE SECTION FOR MULTIPLE CONNECTIONS
# OpenBridge is a protocol originall created by DMR+ for connection between an
# IPSC2 server and Brandmeister. It has been implemented here at the suggestion
# of the Brandmeister team as a way to legitimately connect HBlink to the
# Brandemiester network.
# It is recommended to name the system the ID of the Brandmeister server that
# it connects to, but is not necessary. TARGET_IP and TARGET_PORT are of the
# Brandmeister or IPSC2 server you are connecting to. PASSPHRASE is the password
# that must be agreed upon between you and the operator of the server you are
# connecting to. NETWORK_ID is a number in the format of a DMR Radio ID that
# will be sent to the other server to identify this connection.
# other parameters follow the other system types.
#
# ACLs:
# OpenBridge does not 'register', so registration ACL is meaningless.
# OpenBridge passes all traffic on TS1, so there is only 1 TGID ACL.
# Otherwise ACLs work as described in the global stanza
[OBP-1]
MODE: OPENBRIDGE
#ENABLED: True
ENABLED: False
IP:
PORT: 62035
NETWORK_ID: 3129100
PASSPHRASE: password
TARGET_IP: 1.2.3.4
TARGET_PORT: 62035
USE_ACL: True
SUB_ACL: DENY:1
TGID_ACL: PERMIT:ALL

# MASTER INSTANCES - DUPLICATE SECTION FOR MULTIPLE MASTERS
# HomeBrew Protocol Master instances go here.
# IP may be left blank if there's one interface on your system.
# Port should be the port you want this master to listen on. It must be unique
# and unused by anything else.
# Repeat - if True, the master repeats traffic to peers, False, it does nothing.
#
# MAX_PEERS -- maximun number of peers that may be connect to this master
# at any given time. This is very handy if you're allowing hotspots to
# connect, or using a limited computer like a Raspberry Pi.
#
# ACLs:
# See comments in the GLOBAL stanza
[MASTER-1]
MODE: MASTER
ENABLED: True
REPEAT: True
MAX_PEERS: 10
EXPORT_AMBE: False
IP:
PORT: 54000
PASSPHRASE: passw0rd
GROUP_HANGTIME: 5
USE_ACL: True
REG_ACL: DENY:1
SUB_ACL: DENY:1
TGID_TS1_ACL: PERMIT:ALL
TGID_TS2_ACL: PERMIT:ALL

# PEER INSTANCES - DUPLICATE SECTION FOR MULTIPLE PEERS
# There are a LOT of errors in the HB Protocol specifications on this one!
# MOST of these items are just strings and will be properly dealt with by the program
# The TX & RX Frequencies are 9-digit numbers, and are the frequency in Hz.
# Latitude is an 8-digit unsigned floating point number.
# Longitude is a 9-digit signed floating point number.
# Height is in meters
# Setting Loose to True relaxes the validation on packets received from the master.
# This will allow HBlink to connect to a non-compliant system such as XLXD, DMR+ etc.
#
# ACLs:
# See comments in the GLOBAL stanza
[REPEATER-1]
MODE: PEER
#ENABLED: True
ENABLED: False
LOOSE: False
EXPORT_AMBE: False
IP: 
PORT: 54001
MASTER_IP: 172.16.1.1
MASTER_PORT: 54000
PASSPHRASE: homebrew
CALLSIGN: W1ABC
RADIO_ID: 312000
RX_FREQ: 449000000
TX_FREQ: 444000000
TX_POWER: 25
COLORCODE: 1
SLOTS: 1
LATITUDE: 38.0000
LONGITUDE: -095.0000
HEIGHT: 75
LOCATION: Anywhere, USA
DESCRIPTION: This is a cool repeater
URL: www.w1abc.org
SOFTWARE_ID: 20170620
PACKAGE_ID: MMDVM_HBlink
GROUP_HANGTIME: 5
OPTIONS:
USE_ACL: True
SUB_ACL: DENY:1
TGID_TS1_ACL: PERMIT:ALL
TGID_TS2_ACL: PERMIT:ALL

[XLX-1]
MODE: XLXPEER
#ENABLED: True
ENABLED: False
LOOSE: True
EXPORT_AMBE: False
IP: 
PORT: 54002
MASTER_IP: 172.16.1.1
MASTER_PORT: 62030
PASSPHRASE: passw0rd
CALLSIGN: W1ABC
RADIO_ID: 312000
RX_FREQ: 449000000
TX_FREQ: 444000000
TX_POWER: 25
COLORCODE: 1
SLOTS: 1
LATITUDE: 38.0000
LONGITUDE: -095.0000
HEIGHT: 75
LOCATION: Anywhere, USA
DESCRIPTION: This is a cool repeater
URL: www.w1abc.org
SOFTWARE_ID: 20170620
PACKAGE_ID: MMDVM_HBlink
GROUP_HANGTIME: 5
XLXMODULE: 4004
USE_ACL: True
SUB_ACL: DENY:1
TGID_TS1_ACL: PERMIT:ALL
TGID_TS2_ACL: PERMIT:ALL

[ECHOTEST]
MODE: PEER
ENABLED: True
LOOSE: False
EXPORT_AMBE: False
IP: 
PORT: 54098
MASTER_IP: 127.0.0.1
MASTER_PORT: 54100
PASSPHRASE: passw0rd
CALLSIGN: ECHO
RADIO_ID: 9990
RX_FREQ: 000000000
TX_FREQ: 000000000
TX_POWER: 1
COLORCODE: 1
SLOTS: 2
LATITUDE: 53.00000
LONGITUDE: -8.00000
HEIGHT: 0
LOCATION: Server Echo: TG 9990
DESCRIPTION: Echo server
URL: 
SOFTWARE_ID: DMRGateway-20190702
PACKAGE_ID: MMDVM_HBlink
GROUP_HANGTIME: 5
OPTIONS:
USE_ACL: False
SUB_ACL: DENY:1
TGID_TS1_ACL: PERMIT:ALL
TGID_TS2_ACL: PERMIT:ALL


EOFX
sudo cat > /opt/HBlink3/rules.py <<- "EOFY"
'''
THIS EXAMPLE WILL NOT WORK AS IT IS - YOU MUST SPECIFY YOUR OWN VALUES!!!

This file is organized around the "Conference Bridges" that you wish to use. If you're a c-Bridge
person, think of these as "bridge groups". You might also liken them to a "reflector". If a particular
system is "ACTIVE" on a particular conference bridge, any traffid from that system will be sent
to any other system that is active on the bridge as well. This is not an "end to end" method, because
each system must independently be activated on the bridge.

The first level (e.g. "WORLDWIDE" or "STATEWIDE" in the examples) is the name of the conference
bridge. This is any arbitrary ASCII text string you want to use. Under each conference bridge
definition are the following items -- one line for each HBSystem as defined in the main HBlink
configuration file.

    * SYSTEM - The name of the sytem as listed in the main hblink configuration file (e.g. hblink.cfg)
        This MUST be the exact same name as in the main config file!!!
    * TS - Timeslot used for matching traffic to this confernce bridge
        XLX connections should *ALWAYS* use TS 2 only.
    * TGID - Talkgroup ID used for matching traffic to this conference bridge
        XLX connections should *ALWAYS* use TG 9 only.
    * ON and OFF are LISTS of Talkgroup IDs used to trigger this system off and on. Even if you
        only want one (as shown in the ON example), it has to be in list format. None can be
        handled with an empty list, such as " 'ON': [] ".
    * TO_TYPE is timeout type. If you want to use timers, ON means when it's turned on, it will
        turn off afer the timout period and OFF means it will turn back on after the timout
        period. If you don't want to use timers, set it to anything else, but 'NONE' might be
        a good value for documentation!
    * TIMOUT is a value in minutes for the timout timer. No, I won't make it 'seconds', so don't
        ask. Timers are performance "expense".
    * RESET is a list of Talkgroup IDs that, in addition to the ON and OFF lists will cause a running
        timer to be reset. This is useful   if you are using different TGIDs for voice traffic than
        triggering. If you are not, there is NO NEED to use this feature.
'''

BRIDGES = {
    
    'HBLink-EchoTest-TG9990': [
            {'SYSTEM': 'ECHOTEST',            'TS': 2, 'TGID': 9990,     'ACTIVE': True,  'TIMEOUT': 0,  'TO_TYPE':'NONE', 'ON': [],         'OFF': [],      'RESET': []},
            {'SYSTEM': 'MASTER-1',            'TS': 2, 'TGID': 9990,     'ACTIVE': True,  'TIMEOUT': 0,  'TO_TYPE':'NONE', 'ON': [],         'OFF': [],      'RESET': []},
        ],
}



UNIT = ['ONE', 'TWO']

if __name__ == '__main__':
    from pprint import pprint
    pprint(BRIDGES)

EOFY
sudo cat > /opt/HBlink3/playback.cfg <<- "EOFP"
[GLOBAL]

PATH: ./
PING_TIME: 10
MAX_MISSED: 5
USE_ACL: True
REG_ACL: PERMIT:ALL
SUB_ACL: DENY:1
TGID_TS1_ACL: PERMIT:ALL
TGID_TS2_ACL: PERMIT:ALL

[APRS]
ENABLED: False
REPORT_INTERVAL: 15
CALLSIGN:HB1LNK-11
SERVER:euro.aprs2.net
MESSAGE:Connesso ad HBLINK

[REPORTS]

REPORT: False
REPORT_INTERVAL: 10
REPORT_PORT: 4323
REPORT_CLIENTS: 127.0.0.1

[LOGGER]

LOG_FILE: /var/log/hblink/parrot.log
LOG_HANDLERS: file-timed
LOG_LEVEL: DEBUG
LOG_NAME: Parrot

[ALIASES]

TRY_DOWNLOAD: False
PATH: ./
PEER_FILE: peer_ids.json
SUBSCRIBER_FILE: subscriber_ids.json
TGID_FILE: talkgroup_ids.json
PEER_URL: https://www.radioid.net/static/rptrs.json
SUBSCRIBER_URL: https://www.radioid.net/api/dmr/user/?State=Georgia
STALE_DAYS: 7

[PARROT]

MODE: MASTER
ENABLED: True
REPEAT: True
MAX_PEERS: 10
EXPORT_AMBE: False
IP: 127.0.0.1
PORT: 54100
PASSPHRASE: passw0rd
GROUP_HANGTIME: 5
USE_ACL: True
REG_ACL: DENY:1
SUB_ACL: DENY:1
TGID_TS1_ACL: DENY:ALL
TGID_TS2_ACL: PERMIT:9990

EOFP
sudo cat > /lib/systemd/system/hblink.service <<- "EOF"
[Unit]
Description=Start HBlink
After=network-online.target syslog.target
Wants=network-online.target

[Service]
StandardOutput=null
WorkingDirectory=/opt/HBlink3
RestartSec=3
ExecStart=/usr/bin/python3 /opt/HBlink3/bridge.py -c /opt/HBlink3/hblink.cfg -r /opt/HBlink3/rules.py
Restart=on-abort

[Install]
WantedBy=multi-user.target

EOF


#To start Parrot service must use file /lib/systemd/system/parrot.service 

sudo cat > /lib/systemd/system/hblparrot.service <<- "EOF"
[Unit]
Description=HB bridge all Service
After=network-online.target syslog.target
Wants=network-online.target

[Service]
StandardOutput=null
WorkingDirectory=/opt/HBlink3
RestartSec=3
ExecStart=/usr/bin/python3 /opt/HBlink3/playback.py -c /opt/HBlink3/playback.cfg
Restart=on-abort

[Install]
WantedBy=multi-user.target


EOF

#Start Parrot service:

systemctl daemon-reload

#systemctl restart hblparrot.service
#systemctl restart hblink.service
#systemctl restart hbmon.service


#########################


#########################
cd /opt
rm -rf /opt/HBJson/
git clone https://github.com/Avrahqedivra/HBJson.git
cd /opt/HBJson
#sudo git checkout dev
sudo pip install -U -r requirements.txt
cp config_SAMPLE.py config.py
sed -i "s/JSON_SERVER_PORT =.*/JSON_SERVER_PORT = 80/g" /opt/HBJson/config.py


sudo cat > /lib/systemd/system/hbmon-js.service <<- "EOF"
[Unit]
Description=HBJson
# To make the network-online.target available
# systemctl enable systemd-networkd-wait-online.service

After=network-online.target syslog.target
Wants=network-online.target

[Service]
StandardOutput=null
WorkingDirectory=/opt/HBJson
RestartSec=3
ExecStart=/usr/bin/python3 /opt/HBJson/monitor.py
Restart=on-abort

[Install]
WantedBy=multi-user.target

EOF

systemctl daemon-reload
#################################
