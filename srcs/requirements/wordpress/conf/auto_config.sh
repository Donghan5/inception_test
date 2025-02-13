#!bin/bash
sleep 10

export REQUEST_URI='/'

if [ ! -e /var/www/html/wordpress/wp-config.php ]; then
	cp /var/www/html/wordpress/wp-config-sample.php /var/www/html/wordpress/wp-config.php
	chown www-data:www-data /var/www/html/wordpress/wp-config.php
	chmod 644 /var/www/html/wordpress/wp-config.php

	wp config set DB_NAME "$SQL_DATABASE" --path='/var/www/html/wordpress' --allow-root
	wp config set DB_USER "$SQL_USER" --path='/var/www/html/wordpress' --allow-root
	wp config set DB_PASSWORD "$SQL_PASSWORD" --path='/var/www/html/wordpress' --allow-root
	wp config set DB_HOST "mariadb:3306" --path='/var/www/html/wordpress' --allow-root

	wp core install --url="$DOMAIN_NAME" --title="$SITE_TITLE" \
	                --admin_user="$ADMIN_USER" --admin_password="$ADMIN_PASSWORD" \
	                --admin_email="$ADMIN_EMAIL" --allow-root --path='/var/www/html/wordpress'

	wp user create --allow-root --role=author "$USER1_LOGIN" "$USER1_MAIL" \
	                --user_pass="$USER1_PASS" --path='/var/www/html/wordpress' >> /log.txt

	# wp option update siteurl 'https://donghank.42.fr' --allow-root --path='/var/www/html/wordpress';
	# wp option update home 'https://donghank.42.fr' --allow-root --path='/var/www/html/wordpress';

	echo "if (strpos(\$_SERVER['REQUEST_URI'], '/wp-admin') !== false && !is_user_logged_in()) {" >> /var/www/html/wordpress/wp-config.php
	echo "    wp_redirect(wp_login_url());" >> /var/www/html/wordpress/wp-config.php
	echo "    exit();" >> /var/www/html/wordpress/wp-config.php
	echo "}" >> /var/www/html/wordpress/wp-config.php

	echo "if (!current_user_can('manage_options') && strpos(\$_SERVER['REQUEST_URI'], '/wp-admin') !== false) {" >> /var/www/html/wordpress/wp-content/themes/twentytwentytwo/functions.php
	echo "    wp_redirect(wp_login_url());" >> /var/www/html/wordpress/wp-content/themes/twentytwentytwo/functions.php
	echo "    exit();" >> /var/www/html/wordpress/wp-content/themes/twentytwentytwo/functions.php
	echo "}" >> /var/www/html/wordpress/wp-content/themes/twentytwentytwo/functions.php

	# add redirect home
    echo "add_filter('login_redirect', function(\$redirect_to, \$request, \$user) {" >> /var/www/html/wordpress/wp-content/themes/twentytwentytwo/functions.php
    echo "    if (!is_wp_error(\$user) && !in_array('administrator', \$user->roles)) {" >> /var/www/html/wordpress/wp-content/themes/twentytwentytwo/functions.php
    echo "        return home_url('/');" >> /var/www/html/wordpress/wp-content/themes/twentytwentytwo/functions.php
    echo "    }" >> /var/www/html/wordpress/wp-content/themes/twentytwentytwo/functions.php
    echo "    return \$redirect_to;" >> /var/www/html/wordpress/wp-content/themes/twentytwentytwo/functions.php
    echo "}, 10, 3);" >> /var/www/html/wordpress/wp-content/themes/twentytwentytwo/functions.php

fi

# echo "define( 'CONCATENATE_SCRIPTS', false );" >> /var/www/html/wordpress/wp-config.php
# echo "define( 'SCRIPT_DEBUG', true );" >> /var/www/html/wordpress/wp-config.php
echo "define( 'WP_HOME', 'https://donghank.42.fr' );" >> /var/www/html/wordpress/wp-config.php
echo "define( 'WP_SITEURL', 'https://donghank.42.fr' );" >> /var/www/html/wordpress/wp-config.php

# echo "define( 'WP_DEBUG', true);" >> /var/www/html/wordpress/wp-config.php
# echo "define( 'WP_DEBUG_LOG', true);" >> /var/www/html/wordpress/wp-config.php
# echo "define( 'WP_DEBUG_DISPLAY', false);" >> /var/www/html/wordpress/wp-config.php
# echo "define('WP_ALLOW_REPAIR', true);" >> /var/www/html/wordpress/wp-config.php

# if /run/php folder does not exist, create it
if [ ! -d /run/php ]; then
    mkdir /run/php
fi
/usr/sbin/php-fpm7.3 -F
