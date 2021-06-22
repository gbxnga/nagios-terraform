#!/bin/bash

NAGIOS_ADMIN_PASSWORD="adminadmin"

sudo apt update
sudo apt install -y autoconf bc gawk dc build-essential gcc libc6 make wget unzip apache2 php libapache2-mod-php libgd-dev libmcrypt-dev make libssl-dev snmp libnet-snmp-perl gettext

wget https://github.com/NagiosEnterprises/nagioscore/archive/nagios-4.4.6.tar.gz

tar -xf nagios-4.4.6.tar.gz
cd nagioscore-*/

sudo ./configure --with-httpd-conf=/etc/apache2/sites-enabled
sudo make all

sudo make install-groups-users
sudo usermod -a -G nagios www-data

sudo make install
sudo make install-daemoninit
sudo make install-commandmode

sudo make install-config

sudo make install-webconf
sudo a2enmod rewrite cgi

systemctl restart apache2

# sudo htpasswd -c /usr/local/nagios/etc/htpasswd.users nagiosadmin

sudo htpasswd -b -c /usr/local/nagios/etc/htpasswd.users nagiosadmin "$NAGIOS_ADMIN_PASSWORD"
for svc in Apache ssh
do
sudo ufw allow $svc
done

yes | sudo ufw enable

sudo ufw status numbered

sudo apt install monitoring-plugins nagios-nrpe-plugin -y 

cd /usr/local/nagios/etc
mkdir -p /usr/local/nagios/etc/servers

# vim nagios.cfg

# cfg_dir=/usr/local/nagios/etc/servers

# vim resource.cfg
# $USER1$=/usr/lib/nagios/plugins

# vim objects/contacts.cfg
# define contact{
#         ......
#         email             email@host.com
# }

# vim objects/commands.cfg
# define command{
#         command_name check_nrpe
#         command_line $USER1$/check_nrpe -H $HOSTADDRESS$ -c $ARG1$
# }

sudo systemctl start nagios
sudo systemctl enable nagios
sudo systemctl status nagios
sudo systemctl restart apache2