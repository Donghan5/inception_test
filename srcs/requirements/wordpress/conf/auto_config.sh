#!bin/bash
sleep 10

if [ ! -e /var/www/html/wordpress/wp-config.php ]; then
    cp /var/www/html/wordpress/wp-config-sample.php /var/www/html/wordpress/wp-config.php
    chown www-data:www-data /var/www/html/wordpress/wp-config.php
    chmod 640 /var/www/html/wordpress/wp-config.php

    wp config set DB_NAME "$SQL_DATABASE" --path='/var/www/html/wordpress' --allow-root
    wp config set DB_USER "$SQL_USER" --path='/var/www/html/wordpress' --allow-root
    wp config set DB_PASSWORD "$SQL_PASSWORD" --path='/var/www/html/wordpress' --allow-root
    wp config set DB_HOST "mariadb:3306" --path='/var/www/html/wordpress' --allow-root

    wp core install --url="$DOMAIN_NAME" --title="$SITE_TITLE" \
                    --admin_user="$ADMIN_USER" --admin_password="$ADMIN_PASSWORD" \
                    --admin_email="$ADMIN_EMAIL" --allow-root --path='/var/www/html/wordpress'

    wp user create --allow-root --role=author "$USER1_LOGIN" "$USER1_MAIL" \
                    --user_pass="$USER1_PASS" --path='/var/www/html/wordpress' >> /log.txt

	wp option update siteurl 'https://donghank.42.fr' --allow-root --path='/var/www/html/wordpress';
	wp option update home 'https://donghank.42.fr' --allow-root --path='/var/www/html/wordpress';

	wp config set AUTH_KEY ':0K!`+DMuQ-`g]x|@SM1kIlI!NdJn;=?_]Yupg+-S:&SbmfK+^fqRwsrsrFiW.18';
define('SECURE_AUTH_KEY',  'A%R^1rBx|>+i|?MmN3F,I.BgW/MjJL13aM)xPg<[(HhwNC!j?Qz,v5qT,=ht:{,}');
define('LOGGED_IN_KEY',    'l4=#@=iNRcvU&zdfjRzfu,u!2{n@|3`05lD%KB V}&|H<Nix/944Y|T.5BB3;8`G');
define('NONCE_KEY',        ')o%dkZrC9-,@4+R%3@IO>yR7[3 (vd6nv!gk5`|-Ll;qKrEWO&NsEB#;Ic,y}zV5');
define('AUTH_SALT',        '.H=Z*;47ebU^9$OArW|*2ZO? -o+(T9trM*7M1VS+Ls*SN>C%m1f@5Wj9E1~IZ:-');
define('SECURE_AUTH_SALT', 'I&9D+ngm;/@Z&vq_96H<@ *Ex0zkAvsj]GZc03:EDjx+MEk+BT+*0h|7hc+VR!CY');
define('LOGGED_IN_SALT',   '^k_->+?66mU+U}>Zi|i[%Um0ju$p|`s#/jOZ1NfmFVgWCz/,vsi8rJdx{cOBZI!a');
define('NONCE_SALT',       '$f~^U(5i_Rj+$cxL|AMf`lJKCWl*&-QIEy+s_K*qbAYh@_uG|jana$l;rya)0FlC');
	# echo "if (!current_user_can('manage_options') && strpos(\$_SERVER['REQUEST_URI'], '/wp-admin') !== false) {" >> /var/www/html/wordpress/wp-content/themes/astra/functions.php
    # echo "    wp_redirect('/wp-login.php');" >> /var/www/html/wordpress/wp-content/themes/astra/functions.php
    # echo "    exit();" >> /var/www/html/wordpress/wp-content/themes/astra/functions.php
    # echo "}" >> /var/www/html/wordpress/wp-content/themes/astra/functions.php
	# # add redirect home
    # echo "add_filter('login_redirect', function(\$redirect_to, \$request, \$user) {" >> /var/www/html/wordpress/wp-content/themes/astra/functions.php
    # echo "    if (!is_wp_error(\$user) && !in_array('administrator', \$user->roles)) {" >> /var/www/html/wordpress/wp-content/themes/astra/functions.php
    # echo "        return home_url('/');" >> /var/www/html/wordpress/wp-content/themes/astra/functions.php
    # echo "    }" >> /var/www/html/wordpress/wp-content/themes/astra/functions.php
    # echo "    return \$redirect_to;" >> /var/www/html/wordpress/wp-content/themes/astra/functions.php
    # echo "}, 10, 3);" >> /var/www/html/wordpress/wp-content/themes/astra/functions.php

fi

# echo "define( 'CONCATENATE_SCRIPTS', false );" >> /var/www/html/wordpress/wp-config.php
# echo "define( 'SCRIPT_DEBUG', true );" >> /var/www/html/wordpress/wp-config.php
# echo "define( 'WP_HOME', 'https://donghank.42.fr' );" >> /var/www/html/wordpress/wp-config.php
# echo "define( 'WP_SITEURL', 'https://donghank.42.fr' );" >> /var/www/html/wordpress/wp-config.php
echo "define( 'FORCE_SSL_ADMIN', true );" >> /var/www/html/wordpress/wp-config.php
# echo "define( 'DISABLE_WP_CRON', true );" >> /var/www/html/wordpress/wp-config.php
# echo "define( 'COOKIE_DOMAIN', false );" >> /var/www/html/wordpress/wp-config.php
# echo "define( 'COOKIE_PATH', '' );" >> /var/www/html/wordpress/wp-config.php
# echo "define( 'SITECOOKIEPATH', '' );" >> /var/www/html/wordpress/wp-config.php

# echo "define( 'WP_DEBUG', true);" >> /var/www/html/wordpress/wp-config.php
# echo "define( 'WP_DEBUG_LOG', true);" >> /var/www/html/wordpress/wp-config.php
# echo "define( 'WP_DEBUG_DISPLAY', false);" >> /var/www/html/wordpress/wp-config.php
# echo "define('WP_ALLOW_REPAIR', true);" >> /var/www/html/wordpress/wp-config.php

# if /run/php folder does not exist, create it
if [ ! -d /run/php ]; then
    mkdir /run/php
fi
/usr/sbin/php-fpm7.3 -F
