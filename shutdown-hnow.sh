#! /bin/bash

# Filename: shutdown-hnow.sh 2016-09-19
# Author: Huoty <sudohuoty@gmail.com>
# Script starts from here:

set -e

echo "Shutting down ..."

if [ $USER = "root" ]; then
    init 0
else
    sudo init 0
fi

