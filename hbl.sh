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
        sudo apt-get install --only-upgrade $app -y
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

apps=("python3-twisted" "python3-bitarray" "python3-dev")

# Función para verificar e instalar una aplicación
check_and_install() {
    app=$1
    if ! dpkg -s $app 2>/dev/null | grep -q "Status: install ok installed"; then
        echo "$app no está instalado. Instalando..."
        sudo apt-get install --only-upgrade $app -y
        echo "$app instalado correctamente."
    else
        echo "$app ya está instalado."
    fi
}

# Verificar e instalar cada aplicación
for app in "${apps[@]}"; do
    check_and_install $app
done
###############
cd /
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source $HOME/.cargo/env


#############
apt-get install python3-venv -y
python3 -m venv env0
source env0/bin/activate
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
python3 get-pip.py --force-reinstall
python3 -m pip install --upgrade pip setuptools
python3 -m pip install --upgrade cryptography pyopenssl
python3 -m pip install --upgrade pip setuptools
python3 -m pip install --upgrade Twisted
python3 -m pip install --upgrade dmr_utils3
python3 -m pip install --upgrade bitstring
python3 -m pip install --upgrade autobahn
python3 -m pip install --upgrade jinja2
python3 -m pip install --upgrade markupsafe
python3 -m pip install --upgrade bitarray
python3 -m pip install --upgrade configparser
python3 -m pip install --upgrade aprslib
python3 -m pip install --upgrade attrs
deactivate

##################

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
git clone https://github.com/lz5pn/HBlink3.git /opt/backup/
mv /opt/backup/dmr_utils3/ /opt/
#mv /opt/HBlink3/ /opt/backup/

#mv /opt/backup/HBlink3/ /opt/
cd /opt/
git clone https://github.com/iu7igu/hblink3-aprs.git /opt/HBlink3
cd /opt/HBlink3
sudo git checkout private-call
#sudo pip install -U -r requirements.txt
#chmod +x install.sh

#./install.sh
###########################     hbmonitor 1
#mv /opt/backup/HBmonitor/ /opt/
cd /opt/
git clone https://github.com/sp2ong/HBmonitor.git /opt/HBmonitor
cd /opt/HBmonitor/
#sudo git checkout webserver-python
#chmod +x install.sh
#./install.sh

rm /opt/HBmonitor/log/*
rm /opt/HBmonitor/*.json
cp /opt/HBmonitor/config_SAMPLE.py /opt/HBmonitor/config.py
#cp /opt/HBmonitor/utils/hbmon.service /lib/systemd/system/
cp /opt/HBmonitor/index_template.html /opt/HBmonitor/index.html
#nano /opt/HBmonitor/config.py

sed -i "s/<br><br>.*/ Proyect : <a href=\"https:\/\/gitlab.com\/hp3icc\/Easy-HBL\/\" target=\"_blank\">Easy-HBL+<\/a><br\/><br\/><\/span>/g" /opt/HBmonitor/*.html
#sed -i "s/<img src=.*/<img src=\"data:image\/HBlink.png\"\/>/g" /opt/HBmonitor/*.html
<img src=
sed -i "s/9000/9100/g" /opt/HBmonitor/monitor.py
sed -i "s/9000/9100/g" /opt/HBmonitor/*.html
sed -i "s/WEB_AUTH =.*/WEB_AUTH =  False/g" /opt/HBmonitor/config.py
sed -i "s/WEB_SERVER_PORT =.*/WEB_SERVER_PORT = 80/g" /opt/HBmonitor/config.py
sed -i "s/HBLINK_PORT     =.*/HBLINK_PORT     = 4322/g" /opt/HBmonitor/config.py
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
sudo sed -i "s/REPORT_NAME     =.*/REPORT_NAME     = 'Dashboard HBLink of local DMR network'/g" /opt/HBmonitor/config.py
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
#chmod +x install.sh
#./install.sh
#mv /opt/backup/dmr_utils3/ /opt/
rm /opt/HBmonitor2/log/*
rm /opt/HBmonitor2/*.json
cp /opt/HBmonitor2/config_SAMPLE.py /opt/HBmonitor2/config.py
#cp /opt/HBmonitor/utils/hbmon.service /lib/systemd/system/
cp /opt/HBmonitor2/index_template.html /opt/HBmonitor2/index.html
#nano /opt/HBmonitor/config.py
cat > /opt/HBmonitor2/templates/buttons.html  <<- "EOFX"
<div style="width: 1100px;">
<!-- HBMonitor buttons HTML code -->
<a href="/"><button class="button link">&nbsp;Home&nbsp;</button></a>
{% if auth == True %}
&nbsp;
<div class="dropdown">
  <button class="dropbtn">&nbsp;Admin Area&nbsp;</button>
  <div class="dropdown-content">
    <a href="/masters">&nbsp;Masters&nbsp;</a>
    <a href="/peers">&nbsp;Peers&nbsp;</a>
    <a href="/opb">&nbsp;OpenBridge&nbsp;</a>
 {% if dbridges == True %}
    <a href="/bridges">&nbsp;Bridges&nbsp;</a>
 {% endif %}
    <a href="/moni">&nbsp;Monitor&nbsp;</a>
    <a href="/sinfo">&nbsp;System Info&nbsp;</a>
  </div>
</div>
{% else %}
&nbsp;
<a href="/masters"><button class="button link">&nbsp;Masters & Peers&nbsp;</button></a>
&nbsp;
<!--
<a href="/peers"><button class="button link">&nbsp;Peers&nbsp;</button></a>
&nbsp;
-->
<a href="/opb"><button class="button link">&nbsp;OpenBridge&nbsp;</button></a>
{% if dbridges == True %}
&nbsp;
<a href="/bridges"><button class="button link">&nbsp;Bridges&nbsp;</button></a>
 {% endif %}
&nbsp;
<a href="/moni"><button class="button link">&nbsp;Monitor&nbsp;</button></a>
&nbsp;
<a href="/sinfo"><button class="button link">&nbsp;System Info&nbsp;</button></a>
&nbsp;
<!--
{% endif %}
<a href="/info"><button class="button link">&nbsp;Info&nbsp;</button></a>
&nbsp;
-->
<!-- Own buttons HTML code -->
<!-- link to long lastheard
<a target='_blank' href="http://192.168.1.1/log.php"><button class="button link">&nbsp;Lastheard&nbsp;</button></a>
&nbsp;

-->

<!-- Example of buttons dropdown HTML code -->
<!--
<p></p>
<div class="dropdown">
  <button class="dropbtn">Admin Area</button>
  <div class="dropdown-content">
    <a href="/masters">Master&Peer</a>
    <a href="/opb">OpenBridge</a>
    <a href="/moni">Monitor</a>
  </div>
</div>
&nbsp;
<div class="dropdown">
  <button class="dropbtn">Reflectors</button>
  <div class="dropdown-content">
    <a target='_blank' href="#">YSF Reflector</a>
    <a target='_blank' href="#">XLX950</a>
  </div>
</div>
-->
</div>
<p></p>

EOFX
cat > /opt/HBmonitor2/templates/main_table.html  <<- "EOFT"
{% include 'buttons.html' ignore missing %}
<fieldset style="background-color:#f0f0f0f0;margin-left:15px;margin-right:15px;font-size:14px;border-top-left-radius: 10px; border-top-right-radius: 10px;border-bottom-left-radius: 10px; border-bottom-right-radius: 10px;">
<legend><b><font color="#000">&nbsp;.: DMR Server activity :.&nbsp;</font></b></legend>
{% if _table['MASTERS']|length >0 %}
 <table style="table-layout:fixed;font: 10pt arial, sans-serif;margin-top:4px;margin-bottom:4px;" width=100%>
    <tr style="height:30px;font: 10pt arial, sans-serif;{{ themec }}">
        <th style='width: 20%;'>Systems M&P</th>
        <th style='width: 40%;'>Source</th>
        <th style='width: 40%;'>Destination</th>
    </tr>
    {% for _master in _table['MASTERS'] %}    
    {% for _client, _cdata in _table['MASTERS'][_master]['PEERS'].items() %}
    {% if _cdata[1]['TS'] == True or _cdata[2]['TS'] == True %}
    <tr style="background-color:#a1dcb5;">
        {% if _cdata[1]['TRX'] == "RX" %}
        <td style="font-weight:bold; padding-left: 20px; text-align:center;color:#464646;">M: {{_master}} </td>
        <td style="font: 9.5pt arial, sans-serif;font-weight: 600;color:#0d1a81;">{{ _cdata[1]['SUB']|safe }} [<span style="align-items: center;justify-content:center;font-size: 8pt;font-weight:600;color:brown;">TS {{ 1 if _cdata[1]['TS'] == True else 2 }}</span>]</td>
        <td style="font: 9.5pt arial, sans-serif;font-weight: 600;color:#b5651d;">{{ _cdata[1]['DEST']|safe }}</td>
        {% endif %}
        {% if _cdata[2]['TRX'] == "RX" %}
        <td style="font-weight:bold; padding-left: 20px; text-align:center;color:#464646"><b>M: {{_master}} </td>
        <td style="font: 9.5pt arial, sans-serif;font-weight: 600;color:#0d1a81;">{{ _cdata[2]['SUB']|safe }} [<span style="align-items: center;justify-content:center;font-size: 8pt;font-weight:600;color:brown;">TS {{ 1 if _cdata[1]['TS'] == True else 2 }}</span>]</td>
        <td style="font: 9.5pt arial, sans-serif;font-weight: 600;color:#b5651d;">{{ _cdata[2]['DEST']|safe }}</td>
        {% endif %}
    </tr>
    {% endif %}
    {% endfor %}
    {% endfor %}

{% else %}
         <table style='width:1100px; font: 13pt arial, sans-serif; margin-top:8px;'>
             <tr style='border:none; background-color:#f1f1f1;'>
             <td style='border:none;height:60px;'><font color=brown><b><center>Waiting for Data from FreeDMR Server ...</center></b></td>
             </tr>
            </table>
 {% endif %}
    {% for _peer, _pdata  in _table['PEERS'].items() %}
    {% if _pdata[1]['TS'] == True or _pdata[2]['TS'] == True %}
    <tr style="background-color:#f9f9f9f9;">
        {% if _pdata[1]['TRX'] == "RX" %}
        <td style="font-weight:bold; padding-left: 20px; text-align:center;color:#464646;">P: {{_peer}} </td>
        <td style="font: 9.5pt arial, sans-serif;font-weight: 600;color:#0d1a81;">{{ _pdata[1]['SUB']|safe }} [<span style="align-items: center;justify-content:center;font-size: 8pt;font-weight:600;color:brown;">TS {{ 1 if _pdata[1]['TS'] == True else 2 }}</span>]</td>
        <td style="font: 9.5pt arial, sans-serif;font-weight: 600;color:#b5651d;">{{ _cdata[1]['DEST']|safe }}</td>
        {% endif %}
        {% if _pdata[2]['TRX'] == "RX" %}
        <td style="font-weight:bold; padding-left: 20px; text-align:center;color:#464646;">P: {{_peer}} </td>
        <td style="font: 9.5pt arial, sans-serif;font-weight: 600;color:#0d1a81;">{{ _pdata[2]['SUB']|safe }} [<span style="align-items: center;justify-content:center;font-size: 8pt;font-weight:600;color:brown;">TS {{ 1 if _pdata[1]['TS'] == True else 2 }}</span>]</td>
        <td style="font: 9.5pt arial, sans-serif;font-weight: 600;color:#b5651d;">{{ _pdata[2]['DEST']|safe }}</td>
        {% endif %}
    </tr>
    {% endif %}
    {% endfor %}
      <tr style="background-color:#f9f9f9;" height="2px"><td colspan=3><hr style="padding:0px; margin:0px;border:none;color:#f9f9f9;background-color:#f9f9f9;"></td></tr>
{% if _table['OPENBRIDGES']|length >0 %}
    <tr style="height:30px;width:100%; font: 10pt arial, sans-serif;{{ themec }}">        <th>Systems OpenBridge</th>
        <th colspan=2 '>Active Incoming Calls</th>
    </tr>
    {% for _openbridge in _table['OPENBRIDGES'] %}
    {% set rx = namespace(value=0) %}
    {% if _table['OPENBRIDGES'][_openbridge]['STREAMS']|length >0 %}
       {% for entry in _table['OPENBRIDGES'][_openbridge]['STREAMS'] if _table['OPENBRIDGES'][_openbridge]['STREAMS'][entry][0]=='RX' %}
         {% set rx.value=1 %}
       {% endfor %}
       {% if rx.value == 1 %}    
       <tr style="background-color:#de8184;">
         <td style="font-weight:bold; padding-left: 20px; text-align:center;"> {{ _openbridge}} </td>
         <td colspan=2 style="background-color:#a1dcb5; font: 9pt arial, sans-serif; font-weight: 600; color:#464646;">
         {% for entry in _table['OPENBRIDGES'][_openbridge]['STREAMS']  if _table['OPENBRIDGES'][_openbridge]['STREAMS'][entry][0] == 'RX' %}[<span style="color:#008000;">{{ _table['OPENBRIDGES'][_openbridge]['STREAMS'][entry][0] }}</span>: <font color=#0065ff> {{ _table['OPENBRIDGES'][_openbridge]['STREAMS'][entry][1] }}</font> >> <font color=#b5651d> {{ _table['OPENBRIDGES'][_openbridge]['STREAMS'][entry][2] }}</font>]&nbsp; {% endfor %}
        </td>
      </tr>
      {% endif %}
   {% endif %}
   {% endfor %}
{% endif %}
</table>
</fieldset>

{% if _table['SETUP']['LASTHEARD'] == True %}
  {% include 'lastheard.html' ignore missing %}
{% endif %}
<fieldset style="background-color:#f0f0f0f0;margin-left:15px;margin-right:15px;font-size:14px;border-top-left-radius: 10px; border-top-right-radius: 10px;border-bottom-left-radius: 10px; border-bottom-right-radius: 10px;">
<legend><b><font color="#000">&nbsp;.: Connected to DMR Server :.&nbsp;</font></b></legend>
<table style="table-layout:fixed;width:100%; font: 10pt arial, sans-serif;font-weight:600;margin-top:5px;margin-bottom:5px;" width=100%>
{% if _table['MASTERS']|length >0 %}
<tr style="background-color:#d0d0d0;"><td>
<br>
<div style="text-align:left;"><span style="color:#464646;font-weight:600;line-height:1.4;">&nbsp;&nbsp;LINKS:</span></div>
<div style="text-align:left;font:9.5pt arial, sans-serif;font-weight:bold;margin-left:25px; margin-right:25px;line-height:1.4;white-space:normal;">
    {% for _master in _table['MASTERS'] %}    
    {% if _table['MASTERS'][_master]['PEERS']|length >0 %}
    {% for _client, _cdata in _table['MASTERS'][_master]['PEERS'].items() %}
    <span class="tooltip" style="border-bottom: 0px dotted white;">
    <a style="border-bottom: 0px dotted white;font: 9.5pt arial,sans-serif;font-weight:bold;color:#0066ff;" target="_blank" href="http://www.qrz.com/db/{{_cdata['CALLSIGN']}}"><b>{{_cdata['CALLSIGN']}}</b></a>
    <span class="tooltiptext" style="left:115%;top:-10px;">
        <span style="font: 9pt arial,sans-serif;color:#3df8f8">
        &nbsp;&nbsp;&nbsp;<b>DMR ID</b>: <b><font color=yellow>{{ _client }}</b></font><br>
        {% if _cdata['RX_FREQ'] == 'N/A' and _cdata['TX_FREQ'] == 'N/A' %}
             &nbsp;&nbsp;&nbsp;<b>Type: <font color=yellow>IP Network</font></b><br>
        {% else %} 
            &nbsp;&nbsp;&nbsp;<b>Type: <font color=yellow>Radio</font></b> ({{ _cdata['SLOTS'] }})<br>
        {% endif %}
        &nbsp;&nbsp;&nbsp;<b>Hardware</b>: {{_cdata['PACKAGE_ID'] }}
        <br>&nbsp;&nbsp;&nbsp;<b>Soft_Ver</b>: {{_cdata['SOFTWARE_ID'] }}
        <br>&nbsp;&nbsp;&nbsp;<b>Info</b>: {{_cdata['LOCATION']}}
         <br>&nbsp;&nbsp;&nbsp;<b>Master</b>: <font color=yellow>{{_master}}</font>
        </span></span></span>&nbsp;
    {% endfor %}
    {% endif %}
    {% endfor %}
</div>
{% endif %}
{% if _table['PEERS']|length >0 %}
<br>
<div style="text-align:left;"><span style="color:#464646;font-weight:600;line-height:1.8;">&nbsp;&nbsp;PEERS:</span></div>
<div style="text-align:left;font:9.5pt arial, sans-serif;font-weight:bold;margin-left:25px; margin-right:25px;line-height:1.6;white-space:normal;">
    {% for _peer, _pdata  in _table['PEERS'].items() %}
    <span class="tooltip" style="bmargin-bottom:6px;order-bottom: 1px dotted white;{{'background-color:#98FB98; color:#464646;' if _table['PEERS'][_peer]['STATS']['CONNECTION'] == 'YES' else 'background-color:#ff0000; color:white;'}}"><b>&nbsp;&nbsp;{{_peer}}&nbsp;&nbsp;</b>
    {% if _table['PEERS'][_peer]['STATS']['CONNECTION'] == 'YES' %}
    <span class="tooltiptext" style="top:120%;left:50%;margin-left:-70%;width:100px;padding: 2px 0;">
    <center><font color=white>Connected</font></center>
    </span>
   {% else %}
    <span class="tooltiptext" style="top:120%;left:50%;margin-left:-70%;width:100px;padding: 2px 0;">
    <center><b><font color=white>Disconnected</font></center>
    </span>
    {% endif %}
    </span>&nbsp;
 {% endfor %}
</div>
{% endif %}
<br>
</td></tr></table>
</fieldset>


EOFT
cat > /opt/HBmonitor2/templates/masters_table.html  <<- "EOFD"
{% include 'buttons.html' ignore missing %}
<fieldset style="background-color:#e0e0e0e0; margin-left:15px;margin-right:15px;font-size:14px;border-top-left-radius: 10px; border-top-right-radius: 10px;border-bottom-left-radius: 10px; border-bottom-right-radius: 10px;">
<legend><b><font color="#000">&nbsp;.: Masters status :.&nbsp;</font></b></legend>
{% if _table['MASTERS']|length >0 %}
<table style="table-layout:fixed;width:100%; font: 10pt arial, sans-serif; margin-top:5px; margin-bottom:5px;">
    <tr style="font: 10pt arial, sans-serif;{{ themec }}">
        <th style='width: 120px;'>HB Protocol<br>Master Systems</th>
        <th style='width: 160px;'>Callsign (DMR Id)<br>Info</th>
        <th style='width: 90px;'>Time Connected</th>
        <th style='width: 40px;'>Slot</th>
        <th style='width: 50%;'>Source</th>
        <th style='width: 40%;'>Destination</th>
    </tr>

    {% for _master in _table['MASTERS'] %}    
    {% if ((_table['MASTERS'][_master]['PEERS']|length==0 or _table['MASTERS'][_master]['PEERS']|length>0) and emaster==True) or (_table['MASTERS'][_master]['PEERS']|length>0 and emaster==False) %}

    <tr style="background-color:#f9f9f9f9;">
        <td style="font-weight:bold" rowspan="{{ (_table['MASTERS'][_master]['PEERS']|length * 2) +1 }}"> {{_master}}<br><div style="font: 8pt arial, sans-serif">{{_table['MASTERS'][_master]['REPEAT']}}</div></td>
    </tr>
    {% for _client, _cdata in _table['MASTERS'][_master]['PEERS'].items() %}
    <tr style="background-color:#f9f9f9f9;">
        <td rowspan="2"><div class="tooltip"><b><font color=#0066ff>{{ _cdata['CALLSIGN']}}</font> 
        </b><span style="font: 8pt arial,sans-serif">(Id: {{ _client }})</span><span class="tooltiptext">
        <span style="font: 9pt arial,sans-serif;color:#FFFFFF">
        {% if _cdata['RX_FREQ'] == 'N/A' and _cdata['TX_FREQ'] == 'N/A' %}
             &nbsp;&nbsp;&nbsp;<b>Type: <font color=yellow>IP Network</font></b><br>
        {% else %} 
            &nbsp;&nbsp;&nbsp;<b>Type: <font color=yellow>Radio</font></b> ({{ _cdata['SLOTS'] }})<br>
        {% endif %}
            &nbsp;&nbsp;&nbsp;<b>Soft_Ver</b>: {{_cdata['SOFTWARE_ID'] }}
        <br>&nbsp;&nbsp;&nbsp;<b>Hardware</b>: {{_cdata['PACKAGE_ID'] }}</span></span></div>
        <br><div style="font: 92% arial,sans-serif; color:#b5651d;font-weight:bold">{{_cdata['LOCATION']}}</div></td>
        <td style="background-color:#e8ffec;font: 10pt arial, sans-serif;" rowspan="2">{{ _cdata['CONNECTED'] }}</td>
        <td style="font: 10pt arial, sans-serif;background-color:#{{ _cdata[1]['BGCOLOR'] if _cdata[1]['BGCOLOR']|length !=0 else 'f9f9f9f9' }}; color:#{{ _cdata[1]['COLOR'] if _cdata[1]['COLOR']|length !=0 else '000000' }}"><span style="color:#{{ _cdata[1]['COLOR'] if _cdata[1]['BGCOLOR'] == 'ff6347' else 'b70101'}}">TS1</span></td>
        <td style="font: 10pt arial, sans-serif;background-color:#{{ _cdata[1]['BGCOLOR'] if _cdata[1]['BGCOLOR']|length !=0 else 'f9f9f9f9' }}; color:#{{ _cdata[1]['COLOR'] if _cdata[1]['COLOR']|length !=0 else '000000' }}">{{ _cdata[1]['SUB']|safe }}</td>
        <td style="font: 10pt arial, sans-serif;background-color:#{{ _cdata[1]['BGCOLOR'] if _cdata[1]['BGCOLOR']|length !=0 else 'f9f9f9f9' }}; color:#{{ _cdata[1]['COLOR'] if _cdata[1]['COLOR']|length !=0 else '000000' }}">{{ _cdata[1]['DEST']|safe }}</td>
        <tr style="background-color:#f9f9f9f9;">
        <td style="font: 10pt arial, sans-serif;background-color:#{{ _cdata[2]['BGCOLOR'] if _cdata[2]['BGCOLOR']|length !=0 else 'f9f9f9f9' }}; color:#{{ _cdata[2]['COLOR'] if _cdata[2]['COLOR']|length !=0 else '000000' }}"><span style="color:#{{ _cdata[2]['COLOR'] if _cdata[2]['BGCOLOR'] == 'ff6347' else '3a4aa6'}}">TS2</span></td>
        <td style="font: 10pt arial, sans-serif;background-color:#{{ _cdata[2]['BGCOLOR'] if _cdata[2]['BGCOLOR']|length !=0 else 'f9f9f9f9' }}; color:#{{ _cdata[2]['COLOR'] if _cdata[2]['COLOR']|length !=0 else '000000' }}">{{ _cdata[2]['SUB']|safe }}</td>
        <td style="font: 10pt arial, sans-serif;background-color:#{{ _cdata[2]['BGCOLOR'] if _cdata[2]['BGCOLOR']|length !=0 else 'f9f9f9f9' }}; color:#{{ _cdata[2]['COLOR'] if _cdata[2]['COLOR']|length !=0 else '000000' }}">{{ _cdata[2]['DEST']|safe }}</td>
        </tr>

    </tr>    
     {% endfor %}
   {% endif %}
{% endfor %}
</table>
{% else %}
         <table style='width:100%; font: 13pt arial, sans-serif; margin-top:8px;margin-bottom:8px;'>
             <tr style='border:none; background-color:#f9f9f9f9;'>
             <td style='border:none;height:60px;'><font color=brown><b><center>Waiting for data from the DMR server ...</center></b></td>
             </tr>
            </table>
{% endif %}
</fieldset>

<fieldset style="background-color:#e0e0e0e0;margin-left:15px;margin-right:15px;font-size:14px;border-top-left-radius: 10px; border-top-right-radius: 10px;border-bottom-left-radius: 10px; border-bottom-right-radius: 10px;">
<fieldset class="big">
  <legend><b>.: Peers status :.</b></legend>
 {% if _table['PEERS']|length >0 %}
<table style="table-layout:fixed;width:100%; font: 10pt arial, sans-serif; margin-top:5px;margin-bottom:5px;">
    <tr style="font: 10pt arial, sans-serif;{{ themec }}">
        <th style='width: 120px;'>HB Protocol<br>Peer Systems</th>
        <th style='width: 160px;'>Callsign (DMR Id)<br>Info</th>
        <th style='width: 90px;'>Connected<br>TX/RX/Lost</th>
        <th style='width: 42px;'>Slot</th>
        <th style='width: 50%;'>Source</th>
        <th style='width: 40%;'>Destination</th>
    </tr>
    {% for _peer, _pdata  in _table['PEERS'].items() %}
    <tr style="background-color:#f9f9f9f9;">
        <td style="font-weight:bold" rowspan="2"> {{ _peer}}<br><span style="font-weight:normal; font: 7pt arial, sans-serif;">Mode: {{ _table['PEERS'][_peer]['MODE'] }}</span></td>
        <td rowspan="2"><div class="tooltip"><b><font color=#0066ff>{{_table['PEERS'][_peer]['CALLSIGN']}}</font> </b><span style="font-weight:normal; font: 8pt arial, sans-serif;">(Id: {{ _table['PEERS'][_peer]['RADIO_ID'] }})</span><span class="tooltiptext" style="width:170px;">&nbsp;&nbsp;&nbsp;<b>Linked Time Slot: <font color=yellow>{{ _table['PEERS'][_peer]['SLOTS'] }}</font></b></span></div><br><div style="font: 92% arial, sans-serif; color:#b5651d;font-weight:bold">{{_table['PEERS'][_peer]['LOCATION']}}</div></td>
        <td rowspan="2"; style="font: 9pt arial, sans-serif;{{ 'background-color:#98FB98' if _table['PEERS'][_peer]['STATS']['CONNECTION'] == 'YES' else ';background-color:#ff704d' }}">{{ _table['PEERS'][_peer]['STATS']['CONNECTED'] }}<br><div style="font: 8pt arial, sans-serif">{{ _table['PEERS'][_peer]['STATS']['PINGS_SENT'] }} / {{ _table['PEERS'][_peer]['STATS']['PINGS_ACKD'] }} / {{ _table['PEERS'][_peer]['STATS']['PINGS_SENT'] - _table['PEERS'][_peer]['STATS']['PINGS_ACKD'] }}</div></td>
        
        <td style="font: 10pt arial, sans-serif;background-color:#{{ _pdata[1]['BGCOLOR'] if _pdata[1]['BGCOLOR']|length !=0 else 'f9f9f9f9' }}; color:#{{ _pdata[1]['COLOR'] if _pdata[1]['COLOR']|length !=0 else '000000' }}"><span style="color:#b70101">TS1</span></td>
        <td style="font: 10pt arial, sans-serif;background-color:#{{ _pdata[1]['BGCOLOR'] if _pdata[1]['BGCOLOR']|length !=0 else 'f9f9f9f9' }}; color:#{{ _pdata[1]['COLOR'] if _pdata[1]['COLOR']|length !=0 else '000000' }}">{{ _pdata[1]['SUB']|safe }}</td>
        <td style="font: 10pt arial, sans-serif;color:#464646;background-color:#{{ _pdata[1]['BGCOLOR'] if _pdata[1]['BGCOLOR']|length !=0 else 'f9f9f9f9' }}; color:#{{ _pdata[1]['COLOR'] if _pdata[1]['COLOR']|length !=0 else '000000' }}">{{ _pdata[1]['DEST']|safe }}</td>
        <tr style="background-color:#f9f9f9f9;">
        <td style="font: 10pt arial, sans-serif;background-color:#{{ _pdata[2]['BGCOLOR'] if _pdata[2]['BGCOLOR']|length !=0 else 'f9f9f9f9' }}; color:#{{ _pdata[2]['COLOR'] if _pdata[2]['COLOR']|length !=0 else '000000' }}"><span style="color:#{{ _pdata[2]['COLOR'] if _pdata[2]['BGCOLOR'] == 'ff6347' else '3a4aa6'}}">TS2</span></td>
        <td style="font: 10pt arial, sans-serif;background-color:#{{ _pdata[2]['BGCOLOR'] if _pdata[2]['BGCOLOR']|length !=0 else 'f9f9f9f9' }}; color:#{{ _pdata[2]['COLOR'] if _pdata[2]['COLOR']|length !=0 else '000000' }}">{{ _pdata[2]['SUB']|safe }}</td>
        <td style="font: 10pt arial, sans-serif;color:#464646;background-color:#{{ _pdata[2]['BGCOLOR'] if _pdata[2]['BGCOLOR']|length !=0 else 'f9f9f9f9' }}; color:#{{ _pdata[2]['COLOR'] if _pdata[2]['COLOR']|length !=0 else '000000' }}">{{ _pdata[2]['DEST']|safe }}</td>
        </tr>
    </tr>
  {% endfor %}
</table>
 {% else %}
         <table style='width:100%; font: 13pt arial, sans-serif; margin-top:8px;margin-bottom:8px;'>
             <tr style='border:none; background-color:#f9f9f9f9;'>
             <td style='border:none;height:60px;'><font color=brown><b><center>Waiting for data from the DMR server ... or not defined on DMR server</center></b></td>
             </tr>
            </table>
 {% endif %}
</fieldset>


EOFD

sed -i 's/localhost_2-day.png/localhost_1-day.png/' /opt/HBmonitor2/templates/sysinfo_template.html
sed '39 a <!--' -i /opt/HBmonitor2/templates/sysinfo_template.html
sed '43 a -->' -i /opt/HBmonitor2/templates/sysinfo_template.html
sed -i "s/<br><br>.*/ Proyect : <a href=\"https:\/\/gitlab.com\/hp3icc\/Easy-HBL\/\" target=\"_blank\">Easy-HBL+<\/a><br\/><br\/><\/span>/g" /opt/HBmonitor2/templates/*.html
sed -i 's/b1eee9/3bb43d/' /opt/HBmonitor2/templates/moni_template.html


apps=("rrdtool")

for app in "${apps[@]}"
do
    # Verificar apps
    if ! dpkg -s "$app" >/dev/null 2>&1; then
        # app no instalada
        sudo apt-get install --only-upgrade $app -y
    else
        # app ya instalada
        echo "$app ya instalada"
    fi
done

sed -i "s/HBMonv2/HBmonitor2/g"  /opt/HBmonitor2/sysinfo/*.sh
sudo chmod +x /opt/HBmonitor2/sysinfo/*
sh /opt/HBmonitor2/sysinfo/rrd-db.sh &&
sh /opt/HBmonitor2/sysinfo/graph.sh
sh /opt/HBmonitor2/sysinfo/cpu.sh

sed -i "s/9000/9100/g" /opt/HBmonitor2/monitor.py
sed -i "s/9000/9100/g" /opt/HBmonitor2/scripts/hbmon.js
sed -i "s/REPORT_NAME     =.*/REPORT_NAME     = 'Dashboard HBLink of local DMR network'/g" /opt/HBmonitor2/config.py
sed -i "s/WEB_AUTH =.*/WEB_AUTH =  False/g" /opt/HBmonitor2/config.py
sed -i "s/WEB_SERVER_PORT =.*/WEB_SERVER_PORT = 80/g" /opt/HBmonitor2/config.py
sed -i "s/HBLINK_PORT     =.*/HBLINK_PORT     = 4322/g" /opt/HBmonitor2/config.py
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
wget -q --no-check-certificate -r 'https://docs.google.com/uc?export=download&id=17SaTJ5PntIAuBjB5tcuDhzUcMWg7syF2' -O /opt/HBmonitor2/img/logo.png
sed '5 a <link rel="shortcut icon" href="img/favicon.ico" />' -i /opt/HBmonitor2/templates/*.html
wget -q --no-check-certificate -r 'https://docs.google.com/uc?export=download&id=10tTBFDrnd1b8xcTvvB3gxABdjk5LRCFX' -O /opt/HBmonitor2/img/favicon.ico


#d /opt/dmr_utils3

#chmod +x install.sh

#./install.sh

#/usr/bin/python3 -m pip install --upgrade pip

#sudo pip3 install --upgrade dmr_utils3

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
REPORT_PORT: 4322
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
BOTH_SLOTS: True
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


(crontab -l | grep -v "sh /opt/HBmonitor2/sysinfo/graph.sh") | crontab -
(crontab -l | grep -v "sh /opt/HBmonitor2/sysinfo/cpu.sh") | crontab -

if systemctl status hbmon2.service |grep "service; enabled;" >/dev/null 2>&1
then sudo systemctl disable hbmon2.service

fi
if systemctl status hbmon.service |grep "service; enabled;" >/dev/null 2>&1
then sudo systemctl disable hbmon.service

fi
if systemctl status hbmon2.service |grep active >/dev/null 2>&1
then sudo systemctl stop hbmon2.service

fi
if systemctl status hbmon.service |grep active >/dev/null 2>&1
then sudo systemctl stop hbmon.service

fi

##################