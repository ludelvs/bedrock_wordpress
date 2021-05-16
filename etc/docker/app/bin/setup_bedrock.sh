#!/bin/bash

echo "Setup Bedrock"

set -eu

cd /var/www/html

composer create-project roots/bedrock
cp -rp bedrock/web/wp/* web/wp/
cp -rp bedrock/vendor/* vendor/
rm -rf bedrock

