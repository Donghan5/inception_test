#!/bin/sh

if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "⏳ Initializing MariaDB data directory..."
    mysql_install_db --user=mysql --datadir=/var/lib/mysql > /dev/null
fi

echo "🚀 Starting MariaDB..."
exec mysqld_safe --skip-networking &
sleep 5

echo "🔑 Setting root password..."
mysql -u root <<EOF
ALTER USER 'root'@'localhost' IDENTIFIED BY '${SQL_ROOT_PASSWORD}';
CREATE DATABASE IF NOT EXISTS \`${SQL_DATABASE}\`;
CREATE USER IF NOT EXISTS '${SQL_USER}'@'%' IDENTIFIED BY '${SQL_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${SQL_DATABASE}\`.* TO '${SQL_USER}'@'%';
FLUSH PRIVILEGES;
EOF

echo "🛑 Shutting down MariaDB..."
mysqladmin -u root -p"${SQL_ROOT_PASSWORD}" shutdown

exec mysqld_safe
