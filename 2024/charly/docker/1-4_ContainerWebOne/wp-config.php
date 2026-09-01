<?php
/**
 * The base configuration for WordPress
 *
 * The wp-config.php creation script uses this file during the installation.
 * You don't have to use the website, you can copy this file to "wp-config.php"
 * and fill in the values.
 *
 * This file contains the following configurations:
 *
 * * Database settings
 * * Secret keys
 * * Database table prefix
 * * ABSPATH
 *
 * @link https://developer.wordpress.org/advanced-administration/wordpress/wp-config/
 *
 * @package WordPress
 */

// ** Database settings - You can get this info from your web host ** //
/** The name of the database for WordPress */
define( 'DB_NAME', 'wordpress' );

/** Database username */
define( 'DB_USER', 'wp_user' );

/** Database password */
define( 'DB_PASSWORD', 'password' );

/** Database hostname */
define( 'DB_HOST', '127.0.0.1' );

/** Database charset to use in creating database tables. */
define( 'DB_CHARSET', 'utf8mb4' );

/** The database collate type. Don't change this if in doubt. */
define( 'DB_COLLATE', '' );

/**#@+
 * Authentication unique keys and salts.
 *
 * Change these to different unique phrases! You can generate these using
 * the {@link https://api.wordpress.org/secret-key/1.1/salt/ WordPress.org secret-key service}.
 *
 * You can change these at any point in time to invalidate all existing cookies.
 * This will force all users to have to log in again.
 *
 * @since 2.6.0
 */
define( 'AUTH_KEY',         '$|j~ou5ocwYO#f95,j>r</twgA3CSG6T{0w#rHu%CdZN)a95+l=S8H%:]>GQu{u8' );
define( 'SECURE_AUTH_KEY',  ' &sXS.Y+aB4P<A%n{jBW{3}Y=j]/iwj{Ci=* `]sLjc8E.YF.Bz%~g#Kzcr)OEs ' );
define( 'LOGGED_IN_KEY',    'ly{+!PZk|b`W8#uSCsr@Sr~[)_8|k#G0|}ihHJ!1KQ-*g|9K^AL.TYi8W-1/32V$' );
define( 'NONCE_KEY',        'Y)@m*C`ArH-!@8a4N]}.XOp(.3BnoYbHX]@^^:k$G5Am_!,2l0Ffzl1V7/}IG64L' );
define( 'AUTH_SALT',        'buDz d/hQNC^tVSIf`NZgyhg@}EPyRy]R9mF!r+(?bDrz[@n@6:f,Qpo2dE 65k-' );
define( 'SECURE_AUTH_SALT', '[1]7/|jGtaw5ng*-AHhRQt*La@G),b}XUd5R?}sBL~,ETQc^iuZO/FcH:I{N0>1!' );
define( 'LOGGED_IN_SALT',   'OnTy>wKPh k~?.<+ =&ZiYS.>q14dK]RgCc#H+eI-.nUq+|>6FS18>^gv37]9A=w' );
define( 'NONCE_SALT',       ')rR%[c_tBN+iP+>!.g~FKJ.~l~>+$2SM?GZ=xY0<>g~>#eq[M=iQ_OR-pfaj#qE~' );

/**#@-*/

/**
 * WordPress database table prefix.
 *
 * You can have multiple installations in one database if you give each
 * a unique prefix. Only numbers, letters, and underscores please!
 */
$table_prefix = 'wp_';

/**
 * For developers: WordPress debugging mode.
 *
 * Change this to true to enable the display of notices during development.
 * It is strongly recommended that plugin and theme developers use WP_DEBUG
 * in their development environments.
 *
 * For information on other constants that can be used for debugging,
 * visit the documentation.
 *
 * @link https://developer.wordpress.org/advanced-administration/debug/debug-wordpress/
 */
define( 'WP_DEBUG', false );

/* Add any custom values between this line and the "stop editing" line. */



/* That's all, stop editing! Happy publishing. */

/** Absolute path to the WordPress directory. */
if ( ! defined( 'ABSPATH' ) ) {
	define( 'ABSPATH', __DIR__ . '/' );
}

/** Sets up WordPress vars and included files. */
require_once ABSPATH . 'wp-settings.php';
