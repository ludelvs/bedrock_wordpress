#!/bin/bash

echo "Wordpress Install"

set -eu

composer require roots/wordpress:${WORDPRESS_VERSION}
