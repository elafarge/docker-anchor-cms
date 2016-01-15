#!/bin/bash

# Let's configure te database access if not already there

echo "\n Allow overrides in apache2.conf and enable mod_rewrite\n\n"
sed -i "s/AllowOverride None/AllowOverride All/g" /etc/apache2/apache2.conf
a2enmod rewrite

echo "\n Chmodding Anchor main directories...\n\n"
chown -R www-data:www-data /var/www/anchor
chmod -R 777 /var/www/anchor/anchor/config /var/www/anchor/content

echo "\n Starting Anchor server container...\n\n"
echo "    Executing... $@ \n\n"

# And run our command, probably ApacheCTL (see in Dockerfile)
source /etc/apache2/envvars
tail -F /var/log/apache2/* & exec apache2 -D FOREGROUND
