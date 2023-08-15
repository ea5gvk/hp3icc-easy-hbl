# Easy-FreeDMR-Docker  

<img src="https://raw.githubusercontent.com/hp3icc/Easy-FreeDMR-Docker/main/Easy-FreeDMR-Docker.png" width="550" height="450"><img src="https://raw.githubusercontent.com/CS8ABG/FDMR-Monitor/main/screenshot.png" width="550" height="450">

Is an excerpt from the emq-TE1ws proyect, focused on new and current sysops who want to install FreeDMR Docker Version easily, quickly and up-to-date.

This shell, install FreeDMR Server,with 2 option Dashboard for select: FDMR-Monitor by OA4DOA Christian and FDMR-Monitor by CS8ABG Bruno , Both Dashboard version Self-Service

FreeDMR Server Self-Service version Docker by CA5RPY Rodrigo, with Dashboard,last original version gitlab FreeDMR by G7RZU hacknix Simon, template mods by WP3JM James & N6DOZ Rudy, Self-Service mods with Dial-TG by IU2NAF Diego .

#
# Important note : 

* Compatibility

You can use this script on raspberry arm64 , linux pc , server , virtual machine or vps with debian 11 x86 or x64

This script contains binaries created by different developers , many designed to be used on debian 11 or higher , bad news for ubuntu users , some of the included applications may only work correctly on debian 11

* Support

Unofficial script to install Freedmr Server with Dashboard self-service, if you require support from the official version of the developer , refer to the original developer script :

https://gitlab.hacknix.net/hacknix/FreeDMR/-/wikis/Installing-using-Docker-(recommended!)

FreeDMR Server original version gitlab FreeDMR by G7RZU hacknix Simon.

#

# Pre-Requirements

need have curl and sudo installed

#

# Install

* into your ssh terminal copy and paste the following link :

    apt-get update
    
    apt-get install curl sudo -y

    bash -c "$(curl -fsSL https://gitlab.com/hp3icc/easy-hbl/-/raw/main/install.sh)"
               
#

* If you want to use Easy HBLink+ on your Raspberry B3+ or PI4, you can download the pre-installed image at the following link: 

  <p><a href="https://drive.google.com/u/0/uc?id=1ko4uDqZXd173HYbeEFvCwqFXOjkK4n7e&export=download&confirm=t&uuid=1ko4uDqZXd173HYbeEFvCwqFXOjkK4n7e" target="_blank">Download</a> Raspberry ARM64 image&nbsp;</p>

  User : pi

  Password : Panama507


 #            
  
 # Menu
 
 ![alt text](https://raw.githubusercontent.com/hp3icc/Easy-FreeDMR-Docker/main/menu.png)
 
  At the end of the installation your freedmr server will be installed and working, a menu will be displayed that will make it easier for you to edit, restart or update your server and dashboard to future versions.
  
  to use the options menu, just type menu-fdmr2 in your ssh terminal or console.
  
 #
 
 # Location files config
 
  * Docker compose YML File:
 
  /etc/freedmr/docker-compose.yml
  
  * FreeDMR Server:  
   
  /etc/freedmr/freedmr.cfg  
   
  * FreeDMR Rules: 
   
  /etc/freedmr/rules.py  
   
  * FDMR-Monitor: 
   
   /etc/freedmr/hbmon/fdmr-mon.cfg
   
   
 #
  
 # Location Dashboard Files
 
 /etc/freedmr/hbmon/html/

 # Location Dashboard image logo

 /etc/freedmr/hbmon/html/img/logo.png


#

# Credits :

Special thanks to colleagues: N0MJS Cortney T. Buffington , IU7IGU Daniele Marra , SP2ONG WALDEMAR OGONOWSKI , for their contributions to the content of this scrip.

#

 # Sources :
 
 * https://gitlab.hacknix.net/hacknix/FreeDMR
 
 * https://github.com/sp2ong/
 
 * https://github.com/yuvelq/FDMR-Monitor/tree/Self_Service

 * https://github.com/CS8ABG/FDMR-Monitor/tree/Self_Service
  
 


