#
# Dockerfile to run the PHP/Symfony backend of Bolt CMS
# The database backend is intended to be ran on a separate container
# The WebServer in use is NGinx
#
# Author: Etienne LAFARGE <etienne.lafarge@gmail.com>
# License: GPLv3
#

FROM ubuntu:14.04
MAINTAINER Etienne Lafarge "etienne.lafarge@gmail.com"

# Let's get rid of apt-get's interactive mode
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

# Let's be up to date
RUN apt-get install -y software-properties-common
RUN add-apt-repository "deb http://archive.ubuntu.com/ubuntu $(lsb_release -sc) universe"
RUN apt-get update

# Let's install our Webserver and it's PHP-FPM bindings and Postgres bindings
RUN apt-get install -y nginx
RUN apt-get install -y php5-fpm
RUN apt-get install -y php5-mysql

## Ok let's download the source code of Bolt CMS
RUN apt-get install -y wget
RUN apt-get install -y unzip
RUN wget http://bolt.cm/distribution/bolt-2.2.14.tar.gz -O bolt.tar.gz
RUN mkdir -p /var/www/bolt \
    && tar -zxf bolt.tar.gz -C /var/www/bolt --strip-components=1 \
    && rm bolt.tar.gz && chown -R www-data /var/www
RUN chmod -R 777 /var/www/bolt/files/ /var/www/bolt/app/database/ \
    /var/www/bolt/app/cache/ /var/www/bolt/app/config/ \
    /var/www/bolt/theme/ /var/www/bolt/extensions/

# Let's forward request and error logs to docker log collector
RUN ln -sf /dev/stdout /var/log/nginx/access.log
RUN ln -sf /dev/stderr /var/log/nginx/error.log

## Let's configure NGinx to use PHP
COPY ./volumes/nginx/sites-available/bolt /etc/nginx/sites-available/bolt
RUN echo "cgi.fix_pathinfo = 0;" >> /etc/php5/fpm/php.ini

# Let's setup our NGinx "Virtual Host"
RUN rm -rf /etc/nginx/sites-enabled/*
RUN ln -sf /etc/nginx/sites-available/bolt /etc/nginx/sites-enabled/bolt

# Let's expose the configuration so that it can be modified later (by chef,
# during deployments for instance). It includes the Bolt app config, its theme
# and extensions folders (which contain themes and extensions config files) and
# the NGinx config.
VOLUME /var/www/bolt/app/config
VOLUME /var/www/bolt/extensions
VOLUME /var/www/bolt/theme
VOLUME /var/www/bolt/files
VOLUME /etc/nginx/sites-available

# And let's forward the HTTP and HTTPs ports to the host
EXPOSE 80 443

# We can now start our server
COPY start_server.sh /start_server.sh
RUN chmod +x /start_server.sh
ENTRYPOINT ["/start_server.sh"]
CMD nginx -g 'daemon off;'
