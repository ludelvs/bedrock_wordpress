#!/bin/sh

set -su

if [ "$APP_ENV" != "local" ]; then
  chown -R www-data.www-data /var/www/html/web
fi

nginx -g 'daemon off;'
