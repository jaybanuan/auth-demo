FROM httpd:2.4

RUN apt-get update -y && apt-get install -y libapache2-mod-auth-openidc
COPY httpd.conf /usr/local/apache2/conf/httpd.conf