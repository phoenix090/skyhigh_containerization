#!/usr/bin/env bash

apt-get install -y openstack-dashboard

cp  etc/local_settings.py /etc/openstack-dashboard/local_settings.py
cp  etc/openstack-dashboard.conf /etc/apache2/conf-available/openstack-dashboard.conf
cp  etc/apache2.conf /etc/apache2/

# a2ensite openstack-dashboard.conf
# apache2ctl restart
apache2ctl -D FOREGROUND
