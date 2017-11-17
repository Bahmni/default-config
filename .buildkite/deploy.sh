#!/bin/bash

set -eo pipefail
echo "--- Copying config files from $BUILDKITE_BRANCH" | tee bk-pipeline.log
if [[ "$BUILDKITE_BRANCH" == "develop"  ]]; then
  sudo scp -i $AWS_PEM_KEY_DEV -r ./openelis $AWS_USER_DEV@$AWS_IP_DEV:$AWS_DESTINATION_PATH_DEV | tee -a bk-pipeline.log
  sudo scp -i $AWS_PEM_KEY_DEV -r ./openmrs $AWS_USER_DEV@$AWS_IP_DEV:$AWS_DESTINATION_PATH_DEV | tee -a bk-pipeline.log
fi
if [[ "$BUILDKITE_BRANCH" == "staging"  ]]; then
  sudo scp -i $AWS_PEM_KEY_STAGING -r ./openelis $AWS_USER_STAGING@$AWS_IP_STAGING:$AWS_DESTINATION_PATH_STAGING | tee -a bk-pipeline.log
  sudo scp -i $AWS_PEM_KEY_STAGING -r ./openmrs $AWS_USER_STAGING@$AWS_IP_STAGING:$AWS_DESTINATION_PATH_STAGING | tee -a bk-pipeline.log
  DUMP_NAME=$BUILDKITE_BRANCH"-"$BUILDKITE_BUILD_NUMBER".sql"
  ssh -i $AWS_PEM_KEY_DEV $AWS_USER_DEV@$AWS_IP_DEV "bash -s" < make_dump.sh $DUMP_NAME $AWS_PEM_KEY_STAGING $AWS_USER_STAGING $AWS_IP_STAGING $MYSQL_USER_DEV $MYSQL_PWD_DEV
  ssh -i $AWS_PEM_KEY_STAGING $AWS_USER_STAGING@$AWS_IP_STAGING "bash -s" < mount_dump.sh $DUMP_NAME $MYSQL_USER_DEV $MYSQL_PWD_DEV
fi
if [[ "$BUILDKITE_BRANCH" == "master"  ]]; then
  sudo scp -i $AWS_PEM_KEY_PROD -r ./openelis $AWS_USER_PROD@$AWS_IP_PROD:$AWS_DESTINATION_PATH_PROD | tee -a bk-pipeline.log
  sudo scp -i $AWS_PEM_KEY_PROD -r ./openmrs $AWS_USER_PROD@$AWS_IP_PROD:$AWS_DESTINATION_PATH_PROD | tee -a bk-pipeline.log
fi