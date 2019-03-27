#!/usr/bin/env bash

# Mandatory to set the remote db pwd
if [ -z $KEYSTONE_REMOTE_DB_PASSWD ]; then
	echo "KEYSTONE_REMOTE_DB_PASSWD is not configured."
	echo "Please set KEYSTONE_REMOTE_DB_PASSWD when running a container."
	exit 1;
fi

# Creating keystone user
addgroup --system keystone >/dev/null || true
adduser --quiet --system --home /var/lib/keystone \
	        --no-create-home --ingroup keystone --shell /bin/false \
		keystone || true

mkdir -p /var/lib/keystone/ /etc/keystone/ /var/log/keystone/ /etc/keystone/fernet-keys/

# change the permissions on key directories
chown keystone:keystone -R /var/lib/keystone/ /etc/keystone/ /etc/keystone/fernet-keys/
chmod 0700 /var/lib/keystone/ /var/log/keystone/ /etc/keystone/ /etc/keystone/fernet-keys/

# Start memcached
/usr/bin/memcached -u root & >/dev/null || true

# Populate keystone database
su -s /bin/sh -c 'keystone-manage db_sync' keystone

keystone-manage fernet_setup --keystone-user keystone --keystone-group keystone
keystone-manage credential_setup --keystone-user keystone --keystone-group keystone

# bootstrap keystone
keystone-manage bootstrap --bootstrap-username $KEYSTONE_ADMIN_USER \
		--bootstrap-password $KEYSTONE_ADMIN_PASSWORD \
		--bootstrap-project-name admin \
		--bootstrap-role-name admin \
		--bootstrap-service-name keystone \
		--bootstrap-admin-url "http://$HOSTNAME:35357/v3" \
		--bootstrap-public-url "http://$HOSTNAME:5000/v3" \
		--bootstrap-internal-url "http://$HOSTNAME:5000/v3"


# Writing to openrc- file
cat > /root/openrc <<EOF
export OS_PROJECT_DOMAIN_NAME=default
export OS_USER_DOMAIN_NAME=default
export OS_PROJECT_NAME=admin
export OS_USERNAME=${KEYSTONE_ADMIN_USER}
export OS_PASSWORD=${KEYSTONE_ADMIN_PASSWORD}
export OS_AUTH_URL=http://${HOSTNAME}:35357/v3
export OS_IDENTITY_API_VERSION=3
export OS_IMAGE_API_VERSION=2
EOF

# Configure Apache2
echo "ServerName $HOSTNAME" >> /etc/apache2/apache2.conf
#a2ensite keystone
apache2ctl -D FOREGROUND

