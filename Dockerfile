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

# Let's install PHP5 and its required module
RUN apt-get install -y php5-gd
RUN apt-get install -y php5-mysql
RUN apt-get install -y php5-curl
RUN apt-get install -y php5-mcrypt

# Let's install the Apache2 module for PHP5
RUN apt-get install -y libapache2-mod-php5

# And finally let's install Apache2
RUN apt-get install -y apache2
RUN update-rc.d -f  apache2 remove

## Ok let's download the source code of Bolt CMS
RUN apt-get install -y curl
RUN apt-get install -y unzip
RUN curl -L https://anchorcms.com/download -o anchorcms.zip
RUN unzip anchorcms.zip -d /var/www/ \
    && mv /var/www/anchor-* /var/www/anchor \
    && rm anchorcms.zip && chown -R www-data:www-data /var/www/anchor

# Enable URL rewriting for Apache2
COPY ./anchor_htaccess /var/www/anchor/.htaccess

RUN chmod -R 777 /var/www/anchor/anchor/config /var/www/anchor/content

# Let's forward request and error logs to docker log collector
RUN ln -sf /dev/stdout /var/log/apache2/access.log
RUN ln -sf /dev/stderr /var/log/apache2/error.log

# Let's setup our Apache2 Virtual Host
COPY ./volumes/apache2/sites-available/anchor.conf \
        /etc/apache2/sites-available/anchor.conf

# Remove the default Apache2 website
RUN a2dissite 000-default
# Enable our Anchor VirtualHost in Apache2
RUN a2ensite anchor
# Enable URL rewriting in Apache2
RUN a2enmod rewrite

# Let's expose the configuration so that it can be modified later (by chef,
# during deployments for instance). It includes the Bolt app config, its theme
# and extensions folders (which contain themes and extensions config files) and
# the NGinx config.
VOLUME /var/www/anchor/content
VOLUME /var/www/anchor/anchor/config
VOLUME /etc/apache2/sites-available

# And let's forward the HTTP and HTTPs ports to the host
EXPOSE 80 443

# We can now start our server
COPY start_server.sh /start_server.sh
RUN chmod +x /start_server.sh
CMD ["/start_server.sh"]
