#!/bin/bash

set -eu

prehook /usr/local/bin/wait_db_connect.sh --

if [ "$FORCE_INSTALL" ]; then
    rm tmp/installed_wordpress
fi

if [ "$APP_ENV" = "local" ] && ! [ -f "tmp/installed_wordpress" ]; then
    /usr/local/bin/wordpress_install.sh
    composer install
    /usr/local/bin/setup_bedrock.sh
    /usr/local/bin/plugin_install.sh
    /usr/local/bin/theme_install.sh
    /usr/local/bin/file_install.sh
    touch tmp/installed_wordpress
fi

LOG_STREAM=/tmp/stdout

if ! [ -p "${LOG_STREAM}" ]; then
  if [ -f "${LOG_STREAM}" ]; then rm ${LOG_STREAM}; fi
  mkfifo ${LOG_STREAM}
  chmod 666 ${LOG_STREAM}
fi

/bin/bash -o pipefail -c php-fpm -D | tail -f ${LOG_STREAM}
