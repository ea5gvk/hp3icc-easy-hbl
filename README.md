# Easy-HBLink+  

<img src="https://gitlab.com/hp3icc/easy-hbl/-/raw/main/hbl-mon1.jpg" width="550" height="450"><img src="https://gitlab.com/hp3icc/easy-hbl/-/raw/main/hbl-mon2.jpg" width="550" height="450"><img src="https://gitlab.com/hp3icc/easy-hbl/-/raw/main/hbl-mon3.jpg" width="550" height="450">

#
# Info:

HBL+ is a script made at the request of multiple colleagues and friends who are faithful to HBLink for their local amateur radio projects.

This script includes excerpts from different versions of HBLink, it includes compatibility with private calls, it also includes 3 dashboards to choose from classic HBmonitor, HBmonitor2 by sp2ong, or HBJson by f4jdn.

The websock port of both dashboards, has been migrated from TCP 9000 to TCP 9100, the communication port between HBLink and the dashboard has been changed from 4321 to 4322.

Easy menu is also included manipulation to start your hblink with the dashboard of your choice, I hope it will be very useful for you, everything is preconfigured and ready to start your HBLINK.

#

# Pre-Requirements

need have curl and sudo installed

#

# Install
* into your ssh terminal copy and paste the following link :

      apt-get update
    
      apt-get install curl sudo -y

      sudo su

      bash -c "$(curl -fsSL https://gitlab.com/hp3icc/easy-hbl/-/raw/main/install.sh)"
               
 #            
  
 # Menu
 
<img src="https://gitlab.com/hp3icc/easy-hbl/-/raw/main/menu-hbl.jpg" width="550" height="450">
 
  At the end of the installation your HBLink server will be installed and working, a menu will be displayed that will make it easier for you to edit, restart or update your server and dashboard to future versions.
  
  to use the options menu, just type menu-hbl in your ssh terminal or console.
  
 #
   
# Credits :

Special thanks to colleagues: N0MJS Cortney T. Buffington , LZ5PN Lachizar Karchev , IU7IGU Daniele Marra , SP2ONG WALDEMAR OGONOWSKI , F4JDN Jean-Michel COHEN , for their contributions to the content of this scrip.

#

 # Sources :
 
 * https://github.com/HBLink-org/hblink3

 * https://github.com/lz5pn/HBlink3
 
 * https://github.com/iu7igu/hblink3-aprs
 
 * https://github.com/sp2ong/HBmonitor

 * https://github.com/sp2ong/HBMonv2

 * https://github.com/Avrahqedivra/HBJson
  
 


