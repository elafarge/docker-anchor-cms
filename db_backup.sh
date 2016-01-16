#!/bin/bash

#
# A script to automatically backup the Anchor database that runs in a separate
# MySQL/MariaDB container.
#
# Author: Etienne Lafarge (etienne.lafarge_at_gmail.com)
#

# Let's just do a big .tar.gz of our database files and store them in ./backups

mkdir -p ./backups
tar -cvpzf "anchor-db-backup-$(date +F_R).tar.gz" ./volumes/mysql
exit 0
