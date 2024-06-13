#!/usr/bin/env bash

set -o errexit

USER="dumasg"

mkdir /home/$USER/.ssh
cd /home/$USER/.ssh
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQChEcCzKJDcXdOeDuivNYX9ZsUDq/hewUj/Wb9VGaar7PwJQEF//ia9R+CtuXgMCE8mNSND3UMah7Wjxl0+ynrC9v1FpUdr3Zx8MGU4KtHn33BLwZ85vW5sj31WyVroUZZyhz3skHiYMM0jqCWe+GHBZOJBgVfd7gFY2t/CncgrsapQJ1R8Di3qNbzmREJiNFTHfxfLZSOv9YVHiaQ6aVu7W6Ca2fC3Y70gRW0ZIcUGKk9AUlHBAo4zWCark5PI9GVV1Wtqqa1RW/0vCU9vaB++7BKZIUVyags8BnTQx+7kn7VFHPU4f4wGt08viTWoqZCotYxNzXalyEMc/7pkxzJSK9Eco7FQxgigHIRSFJ7tzFem+7BauwwroJIY/8bU2ganHG2uTWHuvaNjQVTceCRUJHUaie+8Wg4Uu8VbS8tEESqXM7qRbBOmEciNcxFA1nov59Lj8m9YYOFA4dyorLhw2X11xe0keKv1uRTsAg8NZQu3Lxpawb8YBqQCWHUDKv0= dumas@dumas-desktop" > authorized_keys


cd /home/$USER
chown -R $USER:$USER .ssh/

echo "$USER ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/$USER

