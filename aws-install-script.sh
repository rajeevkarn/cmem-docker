#!/bin/bash

if [ ! -f conf/stardog/stardog-license-key.bin ]; then

    echo "Stardog license key not found at conf/stardog/stardog-license-key.bin. Please provide the key. Aborting..."
    exit 1
fi

wget https://download.eccenca.com/cmem/2018-04-cmem-data.zip -O - > data/backups/2018-04-cmem-data.zip
# Check that file downloaded correctly
if [ ! -f data/backups/2018-04-cmem-data.zip ]; then
    echo "Download of CMEM data dump was not successful! Aborting..."
    exit 1
fi
