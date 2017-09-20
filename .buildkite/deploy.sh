#!/bin/bash

set -eo pipefail
echo "--- Copying config files from $BUILDKITE_BRANCH" | tee bk-pipeline.log
if [[ "$BUILDKITE_BRANCH" == "develop"  ]]; then
  scp -i $AWS_PEM_KEY_DEV -r ./dist/* $AWS_USER_DEV@$AWS_IP_DEV:$AWS_DESTINATION_PATH_DEV | tee -a bk-pipeline.log
fi
if [[ "$BUILDKITE_BRANCH" == "staging"  ]]; then
  scp -i $AWS_PEM_KEY_STAGING -r ./dist/* $AWS_USER_STAGING@$AWS_IP_STAGING:$AWS_DESTINATION_PATH_STAGING | tee -a bk-pipeline.log
fi
if [[ "$BUILDKITE_BRANCH" == "master"  ]]; then
  scp -i $AWS_PEM_KEY_PROD -r ./dist/* $AWS_USER_PROD@$AWS_IP_PROD:$AWS_DESTINATION_PATH_PROD | tee -a bk-pipeline.log
fi