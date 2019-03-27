FROM debian:stretch

ENV OPENSTACK_HOST keystone
ENV APACHE_PID_FILE /var/run/apache2/apache2.pid
ENV APACHE_RUN_DIR /var/run/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data

RUN apt-get -y update \
    && apt-get install -y apache2 libapache2-mod-wsgi

RUN apt-get install -y openstack-dashboard
# cp -r /etc/local_settings.py /etc/openstack-dashboard/local_settings.py
# cp -r /etc/openstack-dashboard.conf /etc/apache2/conf-available/openstack-dashboard.conf

# RUN . /etc/apache2/envvars
RUN mkdir -p horizon/etc /var/run/apache2 /var/log/apache2
# RUN . /etc/apache2/envvars
# RUN echo "export APACHE_RUN_DIR=/var/run/apache2" >> /etc/apache2/envvars
RUN . /etc/apache2/envvars
# RUN ls /var/run/
WORKDIR /horizon/etc
COPY etc/* ./
COPY bootstrap.sh ../bootstrap.sh
# RUN pwd && ls etc/
RUN cp local_settings.py /etc/openstack-dashboard/local_settings.py
RUN cp openstack-dashboard.conf /etc/apache2/conf-available/openstack-dashboard.conf
RUN cp apache2.conf /etc/apache2/apache2.conf
# RUN apache2ctl start && apache2ctl restart
# RUN apache2 -S

# RUN ls /etc/apache2/
# RUN cat /etc/apache2/apache2.conf | grep serverName
# RUN cat /etc/apache2/apache2.conf | grep APACHE_RUN_DIR 
EXPOSE 80
# RUN apache2ctl start
# RUN service apache2 reload

CMD /usr/sbin/apache2 -DFOREGROUND
# RUN service apache2 start
#CMD sh -x /bootstrap.sh
