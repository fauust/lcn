<?php
define('DB_NAME', 'wordpressdatabase');
define('DB_USER', 'wordpressuser');
define('DB_PASSWORD', 'wordpresspassword');
define('DB_HOST', 'localhost');
define('DB_CHARSET', 'utf8');
define('DB_COLLATE', '');
$table_prefix  = 'wp_';
define('WP_DEBUG', false);
if ( !defined('ABSPATH') )
    define('ABSPATH', dirname(__FILE__) . '/');
require_once(ABSPATH . 'wp-settings.php');
