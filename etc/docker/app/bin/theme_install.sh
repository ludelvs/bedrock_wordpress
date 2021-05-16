#!/bin/bash

echo "Theme Install"

set -eu

THEMES=""

cd /var/www/html

if [ "${SITE}" = "ticketpay" ]; then
  THEMES=ticketpay_2020
elif [ "${SITE}" = "kaihipay" ]; then
  THEMES="yswallow kaihipayblog"
fi

for THEME in ${THEMES}
do
  cp -rp data/themes/${THEME} web/wp/wp-content/themes/
done

