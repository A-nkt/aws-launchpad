#! /bin/bash

APP_BASE=`git rev-parse --show-toplevel`

. ${APP_BASE}/env/common.sh

check_env $1

deploy
