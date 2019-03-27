#!/usr/bin/env bash

apt-get install -y openstack-dashboard
cp -r /etc/local_settings.py /etc/openstack-dashboard/local_settings.py
cp -r /etc/openstack-dashboard.conf /etc/apache2/conf-available/openstack-dashboard.conf

apache2ctl reload
apache2ctl -D FOREGROUND
