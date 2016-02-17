#!/bin/sh -x

USER=bahmni

sudo rm -rf /var/www/bahmni_config
sudo ln -s /bahmni-code/default-config /var/www/bahmni_config
sudo chown -h ${USER}:${USER} /var/www/bahmni_config