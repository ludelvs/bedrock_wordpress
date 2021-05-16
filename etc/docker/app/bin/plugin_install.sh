#!/bin/bash

echo "Plugin Install"

set -eu

PLUGIN_DIR=etc/docker/app/plugin
PLUGIN_LIST=$(eval echo \"$(cat ${PLUGIN_DIR}/${SITE})\")
for PLUGIN in $PLUGIN_LIST
do
  composer require ${PLUGIN}
done

