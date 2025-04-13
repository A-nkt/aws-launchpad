#! /bin/bash

APP_BASE=`git rev-parse --show-toplevel`

. $APP_BASE/env/common.sh

check_env $1

cd ./web

npm run build

aws s3 sync ./dist s3://${ENVIRONMENT_NAME}-hosting-bucket-ane1/ --profile ${Profile}
