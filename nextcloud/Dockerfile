FROM nextcloud:23.0.3


WORKDIR /var/www/html

ARG NEXTCLOUD_CUSTOM_APPS

COPY ./install-apps.sh /
COPY ./wait-for-it.sh /

RUN apt-get install -y --no-install-recommends $(apt-cache search libmagickcore-6.q[0-9][0-9]-[0-9]-extra | cut -d " " -f1)

RUN chmod u+x /install-apps.sh
RUN chmod u+x /wait-for-it.sh
RUN chsh -s /bin/bash www-data
RUN echo "ServerName 172.16.1.6" >> /etc/apache2/apache2.conf
