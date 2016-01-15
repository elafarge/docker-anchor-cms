#!/bin/bash

# Let's configure the database access
echo "Sedding the database credentials directly into the config file"
sed -ri "s/'hostname' => '.*'/'hostname' => '$ANCHOR_DB_PORT_3306_TCP_ADDR'/" /var/www/anchor/anchor/config/db.php
sed -ri "s/'port' => [0-9]{3,5}/'port' => $ANCHOR_DB_PORT_3306_TCP_PORT/" /var/www/anchor/anchor/config/db.php
sed -ri "s/'database' => '.*'/'database' => '$ANCHOR_DB_ENV_MYSQL_DATABASE'/" /var/www/anchor/anchor/config/db.php
sed -ri "s/'username' => '.*'/'username' => '$ANCHOR_DB_ENV_MYSQL_USER'/" /var/www/anchor/anchor/config/db.php
sed -ri "s/'password' => '.*'/'password' => '$ANCHOR_DB_ENV_MYSQL_PASSWORD'/" /var/www/anchor/anchor/config/db.php

echo "Chmodding Anchor main directories..."
chown -R www-data:www-data /var/www/anchor
chmod -R 777 /var/www/anchor/anchor/config /var/www/anchor/content

echo "Starting PHP5-FPM daemon..."
service php5-fpm start

echo "Starting Anchor server container..."
echo "Executing... $@ \n\n"

exec "$@"
