#!/bin/sh
if [[ $EUID -ne 0 ]]; then
	whiptail --title "FDMR+" --msgbox "Debe ejecutar este script como usuario ROOT" 0 50
	exit 0
fi

whiptail --title "FDMR+" --msgbox "Muy pronto / Comming soon" 0 50
#bash -c "$(curl -fsSL https://gitlab.com/hp3icc/easy-hbl/-/raw/main/menu-hbl.sh)"
#bash -c "$(curl -fsSL https://gitlab.com/hp3icc/easy-hbl/-/raw/main/hbl.sh)"

