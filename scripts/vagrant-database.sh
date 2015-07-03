#!/bin/sh -x
PATH_OF_CURRENT_SCRIPT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $PATH_OF_CURRENT_SCRIPT/vagrant/vagrant_functions.sh

IMPLEMENTATION_NAME=default
APP_NAME=${1:-openmrs}
MIGRATIONS_DIR="/packages/build/${IMPLEMENTATION_NAME}_config/${APP_NAME}/migrations"
SRC_MIGRATIONS_DIR="/bahmni/${IMPLEMENTATION_NAME}-config/${APP_NAME}/migrations"

run_in_vagrant -c "sudo rm -rf ${MIGRATIONS_DIR}/*"
run_in_vagrant -c "sudo mkdir -p ${MIGRATIONS_DIR}"
run_in_vagrant -c "sudo cp  ${SRC_MIGRATIONS_DIR}/* ${MIGRATIONS_DIR}/"
run_in_vagrant -c "sudo /bahmni_temp/run-implementation-${APP_NAME}-liquibase.sh"