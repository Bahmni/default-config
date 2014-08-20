#!/bin/sh -x
PATH_OF_CURRENT_SCRIPT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $PATH_OF_CURRENT_SCRIPT/vagrant/vagrant_functions.sh

run_in_vagrant -c "sudo chown bahmni:bahmni /packages/build/possible_config/migrations"
run_in_vagrant -c "sudo su - bahmni -c 'sudo cp -r /Project/possible-config/migrations/* /packages/build/possible_config/migrations/'"
run_in_vagrant -c "sudo su - bahmni -c 'cd /bahmni_temp/ && ./run-implementation-liquibase.sh'"
run_in_vagrant -c "sudo su - bahmni -c 'cd /bahmni_temp/ && ./run-implementation-openelis-config-liquibase.sh'"
