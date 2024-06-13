#!/usr/bin/env bash

# Install Apache
# ========================
apt-get install -y apache2

# Enable Apache
# ========================
systemctl enable apache2

# Create a test website
# ========================
html_root="/var/www/testapp"
mkdir -p $html_root

cat > "$html_root"/index.html <<-EOF
<html>
  <head>
    <title>Test apache on VM</title>
  </head>
  <body>
    <h1>You are accessing $html_root on the Debian VM</h1>
  </body>
</html>
EOF

# Set rights
# ========================

# directories :
#    user  : rwx (7) : needs to read, write and traverse
#    group : r-x (5) : doesn't need to write (group www-data)
#    set-group-ID bit : give files created in the directory the same group as
#                       the directory, no matter what group the user who creates them is in
# files :
#    user : rw (6) : needs to read and write
#    group : r (4) : www-data just needs Read access

chgrp -R www-data $html_root
find $html_root -type d -exec chmod 2750 {} \;
find $html_root -type f -exec chmod 640 {} \;

# Set vhost
# ========================
vhost_file="/etc/apache2/sites-available/testapp.conf"
cat > $vhost_file <<-EOF
<VirtualHost *:80>
    ServerName testapp
    ServerAdmin webmaster@localhost
    DocumentRoot $html_root
    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
EOF

# Enable the vhost
a2ensite testapp

# Reload Apache
systemctl reload apache2
