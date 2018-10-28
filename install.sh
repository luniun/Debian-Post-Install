#!/bin/bash
# Mon script de post installation serveur Debian 
# Compatible Debian
# luniun 07/18
# Apache2
#
# Syntaxe: # su - -c "./install.sh"
# Syntaxe: or # sudo ./install.sh
VERSION="1.0"

#=============================================================================
# Liste des applications à installer: A adapter a vos besoins
LISTE="git default-jdk default-jre cmake make apache2 mariadb-server php7.2 perl libcgi-pm-perl ruby python apache2-utils libapache2-mod-authnz-external pwauth phpmyadmin php-mbstring php-gettext"
#=============================================================================

# Test que le script est lance en root
if [ $EUID -ne 0 ]; then
  echo -e "\nLe script doit être lancé avec l'utilisateur root: # sudo $0" 1>&2
  exit 1
fi


# Mise a jour de la liste des depots
#-----------------------------------

# Require
apt update
apt -y install apt-transport-https lsb-release ca-certificates

# Cle de repo
wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg
echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list


# Update
echo -e "\n### Mise a jour de la liste des depots\n" apt update

# Upgrade
echo -e "\n### Mise a jour du systeme\n" apt -y upgrade

# Installation
echo -e "\n### Installation des logiciels suivants: $LISTE\n"
apt -y install $LISTE
update-alternatives --config php

# Configuration
#--------------

a2enmod cgid
a2enmod ssl
a2enmod userdir
systemctl restart apache2
mysql_secure_installation


# Fin du script
