#!/bin/sh
set -e
echo "Rewriting Bahmni Config at /usr/local/bahmni_config"
cp -r /etc/bahmni_config /usr/local/bahmni_config

echo "Sleeping infinitely....."
sleep infinity