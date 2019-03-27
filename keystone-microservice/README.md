# keystone-microservice
Keystone with docker

#### Make an environment file with the params used in the run command(Optional)
- E.g:
```
export KEYSTONE_VERSION=<tag version> 
```
- [Keystone release versions](https://github.com/openstack/keystone/releases#)
- Change the value of "KEYSTONE_VERSION" in the Dockerfile to use another version for now.
#### Build the image
```
docker build -t keystone:${KEYSTONE_VERSION} ./
```
#### Run the container
```
docker run -d -p 5000:5000 -p 35357:35357 -e KEYSTONE_ADMIN_USER=$KEYSTONE_ADMIN_USER -e KEYSTONE_ADMIN_PASSWORD=$KEYSTONE_ADMIN_PASSWORD -e KEYSTONE_DB_HOST=$KEYSTONE_DB_HOST -e KEYSTONE_REMOTE_DB_PASSWD=$KEYSTONE_REMOTE_DB_PASSWD -e HOSTNAME=$KEYSTONE_HOST --name=keystone keystone:${KEYSTONE_VERSION}
```
