#!/bin/sh

# start mysql service
service mysql start;

# create a database (if it's not exist)
mysql -e "CREATE DATABASE IF NOT EXISTS \`${SQL_DATABASE}\`;"

# create user with a password
mysql -e "CREATE USER IF NOT EXISTS \`${SQL_USER}\`@`localhost` IDENTIFIED BY `${SQL_PASSWORD}`;"

# give all privileges to the user
mysql -e "GRANT ALL PRIVILEGES ON \`${SQL_DATABASE}\`.* TO \`${SQL_USER}\`@`%` IDENTIFIED BY `${SQL_PASSWORD}`;"

# mod sql database
mysql -e "ALTER USER `root`@`localhost` IDENTIFIED BY `${SQL_ROOT_PASSWORD}`;"

# reload the database
mysql -e "FLUSH PRIVILEGES;"

# shutdown
mysqladmin -u root -p$SQL_ROOT_PASSWORD shutdown

exec mysqld_safe
