#!/bin/bash

set -e

mkdir -p /var/www/html
cd /var/www/html

if [ ! -f /var/www/html/wp-config.php ]; then
    rm -rf *
fi

# WP-CLI 설치
echo "📥 WP-CLI DOWNLOAD..."
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar
mv wp-cli.phar /usr/local/bin/wp
echo "✅ WP-CLI COMPLETE!"


wp core download --allow-root


export $(grep -v '^#' /var/www/html/.env | xargs)


if [ ! -f /var/www/html/wp-config.php ]; then
    cp /var/www/html/wp-config-sample.php /var/www/html/wp-config.php
fi

sed -i "s/database_name_here/$DB_NAME/" wp-config.php
sed -i "s/username_here/$DB_USER/" wp-config.php
sed -i "s/password_here/$DB_PASSWORD/" wp-config.php
sed -i "s/localhost/$DB_HOST/" wp-config.php

echo "✅ wp-config.php complete!"

wp core install --url="$DOMAIN_NAME" --title="$WP_TITLE" --admin_user="$WP_ADMIN_USR" --admin_password="$WP_ADMIN_PWD" --admin_email="$WP_ADMIN_EMAIL" --skip-email --allow-root
echo "✅ WordPress complete!"

if [ -f /etc/php/7.3/fpm/pool.d/www.conf ]; then
    sed -i 's/listen = \/run\/php\/php7.3-fpm.sock/listen = 9000/g' /etc/php/7.3/fpm/pool.d/www.conf
else
    echo "⚠️ DO NOT EXIST PHP-FPM! PLEASE CHECK www.conf."
fi

mkdir -p /run/php
chown www-data:www-data /run/php

echo "🚀 PHP-FPM..."
exec /usr/sbin/php-fpm7.3 -F
