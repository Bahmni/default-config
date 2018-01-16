#!/bin/bash

set -eo pipefail
echo "--- Copying config files from $BUILDKITE_BRANCH" | tee bk-pipeline.log
if [[ "$BUILDKITE_BRANCH" == "ci-config"  ]]; then
  echo "entro ci-config"
  sudo scp -i $AWS_PEM_KEY_DEV -r ./openelis $AWS_USER_DEV@$AWS_IP_DEV:$AWS_DESTINATION_PATH_DEV | tee -a bk-pipeline.log
  sudo scp -i $AWS_PEM_KEY_DEV -r ./openmrs $AWS_USER_DEV@$AWS_IP_DEV:$AWS_DESTINATION_PATH_DEV | tee -a bk-pipeline.log
fi
if [[ "$BUILDKITE_BRANCH" == "staging"  ]]; then
  sudo scp -i $AWS_PEM_KEY_STAGING -r ./openelis $AWS_USER_STAGING@$AWS_IP_STAGING:$AWS_DESTINATION_PATH_STAGING | tee -a bk-pipeline.log
  sudo scp -i $AWS_PEM_KEY_STAGING -r ./openmrs $AWS_USER_STAGING@$AWS_IP_STAGING:$AWS_DESTINATION_PATH_STAGING | tee -a bk-pipeline.log
fi
if [[ "$BUILDKITE_BRANCH" == "master"  ]]; then
  sudo scp -i $AWS_PEM_KEY_PROD -r ./openelis $AWS_USER_PROD@$AWS_IP_PROD:$AWS_DESTINATION_PATH_PROD | tee -a bk-pipeline.log
  sudo scp -i $AWS_PEM_KEY_PROD -r ./openmrs $AWS_USER_PROD@$AWS_IP_PROD:$AWS_DESTINATION_PATH_PROD | tee -a bk-pipeline.log
fi
