#!bin/bash
sleep 10

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

	wp theme install astra --allow-root --path='/var/www/html/wordpress'
	wp theme activate astra --allow-root --path='/var/www/html/wordpress'

	prohibit the access of user to the page wp-admin
	echo "if (!current_user_can('manage_options') && strpos(\$_SERVER['REQUEST_URI'], '/wp-admin') !== false) {" >> /var/www/html/wordpress/wp-content/themes/astra/functions.php
    echo "    wp_redirect('/wp-login.php');" >> /var/www/html/wordpress/wp-content/themes/astra/functions.php
    echo "    exit();" >> /var/www/html/wordpress/wp-content/themes/astra/functions.php
    echo "}" >> /var/www/html/wordpress/wp-content/themes/astra/functions.php

	# remove admin cache when login
	echo "add_action('init', function() {" >> /var/www/html/wordpress/wp-content/themes/astra/functions.php
    echo "    if (!current_user_can('manage_options')) {" >> /var/www/html/wordpress/wp-content/themes/astra/functions.php
    echo "        header('Cache-Control: no-store, no-cache, must-revalidate, max-age=0');" >> /var/www/html/wordpress/wp-content/themes/astra/functions.php
    echo "        header('Cache-Control: post-check=0, pre-check=0', false);" >> /var/www/html/wordpress/wp-content/themes/astra/functions.php
    echo "        header('Pragma: no-cache');" >> /var/www/html/wordpress/wp-content/themes/astra/functions.php
    echo "    }" >> /var/www/html/wordpress/wp-content/themes/astra/functions.php
    echo "});" >> /var/www/html/wordpress/wp-content/themes/astra/functions.php

	# after login redirect to home
    echo "add_filter('login_redirect', function(\$redirect_to, \$request, \$user) {" >> /var/www/html/wordpress/wp-content/themes/astra/functions.php
    echo "    if (!is_wp_error(\$user) && !in_array('administrator', \$user->roles)) {" >> /var/www/html/wordpress/wp-content/themes/astra/functions.php
    echo "        return home_url('/');" >> /var/www/html/wordpress/wp-content/themes/astra/functions.php
    echo "    }" >> /var/www/html/wordpress/wp-content/themes/astra/functions.php
    echo "    return \$redirect_to;" >> /var/www/html/wordpress/wp-content/themes/astra/functions.php
    echo "}, 10, 3);" >> /var/www/html/wordpress/wp-content/themes/astra/functions.php
fi

echo "define( 'CONCATENATE_SCRIPTS', false );" >> /var/www/html/wordpress/wp-config.php
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
