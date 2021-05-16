#!/bin/bash

echo "File Install"

set -eu

FILE_DIR=etc/docker/app/file
FILE_LIST=$(cat ${FILE_DIR}/${SITE})

for FILE in $FILE_LIST
do
  cp -rp data/uploads/${FILE} web/app/uploads/
done

