#!/user/bin/env bash

apt-get update -y
apt-get install php8.2-fpm -y
apt-get install php-mysql -y
a2enmod proxy_fcgi setenvif
a2enconf php8.2-fpm
systemctl reload apache2
rm /var/www/html/index.html
#cat > /var/www/html/index.php <<-EOF
#<?php
#	phpinfo();
#?>
EOF
mv testProject.php /var/www/html/
mv vhostphp.conf /etc/apache2/sites-available/
a2ensite vhostphp.conf
rm /etc/apache2/sites-available/000-default.conf
systemctl restart apache2
