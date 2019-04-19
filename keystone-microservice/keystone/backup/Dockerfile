FROM python:2.7.12

ARG KEYSTONE_VERSION
ARG KEYSTONE_REMOTE_DB_PASSWD
LABEL version="$KEYSTONE_VERSION"

# Apache and mod-wsgi at the front-end for keystone
# Mysql and other dependencies
#RUN apt-get update
RUN echo "deb [check-valid-until=no] http://archive.debian.org/debian jessie-backports main" > /etc/apt/sources.list.d/jessie-backports.list
RUN sed -i '/deb http:\/\/deb.debian.org\/debian jessie-updates main/d' /etc/apt/sources.list
RUN apt-get -o Acquire::Check-Valid-Until=false update
RUN apt-get install -y apache2 libapache2-mod-wsgi git memcached\
        libffi-dev python-dev libssl-dev libldap2-dev libsasl2-dev\
    && apt-get install -y mysql-client && apt-get -y clean

RUN git clone -b ${KEYSTONE_VERSION} https://github.com/openstack/keystone.git
WORKDIR /keystone

# Installing dependicies
RUN apt-get install -y python-pip && pip install --upgrade pip
RUN pip install -r requirements.txt \
    && PBR_VERSION=${KEYSTONE_VERSION} python setup.py install
RUN yes | pip install PyMySql python-memcached python-ldap ldappool

RUN mkdir /etc/keystone
RUN cp -r ./etc/* /etc/keystone/
COPY bootstrap.sh /bootstrap.sh
COPY ./etc/keystone.conf /etc/keystone/keystone.conf
COPY ./apache.keystone.conf /etc/apache2/sites-available/keystone.conf
COPY ./apache.keystone.conf /etc/apache2/sites-enabled/keystone.conf
# Keystone ports
# EXPOSE 5000 35357

WORKDIR /root
CMD sh -x /bootstrap.sh
