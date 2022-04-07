#!/bin/sh

#
# Install the custom apps listed in NEXTCLOUD_CUSTOM_APPS.
#

run_as() {
  su -p www-data -c "$1"
}


echo "installing custom apps: $NEXTCLOUD_CUSTOM_APPS"
for app in $NEXTCLOUD_CUSTOM_APPS; do
  echo "now installing this app: $app"
  run_as "php /var/www/html/occ app:install $app" || echo "Warning: Failed to install custom app '$app'!"
#  run_as "php /var/www/html/occ app:enable $app" || echo "Warning: Cant enable app '$app'!"
done
