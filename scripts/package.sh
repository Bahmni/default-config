
#!/bin/bash

BASE_DIR=`dirname $0`
ROOT_DIR=$BASE_DIR/..

mkdir -p $ROOT_DIR/target
rm -rf $ROOT_DIR/target/defaultconfig.zip

cd $ROOT_DIR && zip -r target/defaultconfig.zip openmrs/* migrations/* openelis/* offline/*
