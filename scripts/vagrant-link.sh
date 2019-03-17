#!/bin/sh -x

PATH_OF_CURRENT_SCRIPT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $PATH_OF_CURRENT_SCRIPT/vagrant/vagrant_functions.sh

run_in_vagrant -c "sudo rm -rf /var/www/bahmni_config"
run_in_vagrant -c "sudo ln -s /bahmni/possible-config /var/www/bahmni_config"
run_in_vagrant -c "sudo chown -h bahmni:bahmni /var/www/bahmni_config"
