#! /bin/bash

function get_category_name () {
    echo "$(basename $(dirname $(cd $(dirname $0); pwd)))"
}

function get_app_name () {
    echo "$(basename $(cd $(dirname $0); pwd))" | sed s/${Project}-//
}


function set_env() {
    PROJECT_NAME=`jq -r '.Exports.ProjectName' $1`
    Profile=`jq -r '.Parameters.Profile' $1`
    export REGION=`jq -r '.Parameters.Region' $1`
    export DEPLOY_PROFILE=`jq -r '.Exports.DeployProfile' $1`
    export CATEGORY_NAME=`get_category_name`
    export APP_NAME=`get_app_name`
}

function init() {
    set_env ${APP_BASE}/env/env.json
    
}

function check_env () {
    if [ $# -lt 1 ]; then
        echo "need EnvironmentName[dev|stg|prd]"
        exit 1
    fi

    if [ $1 = "dev" ]; then
        export ENVIRONMENT_NAME="$1-${PROJECT_NAME}"
        export Profile="${Profile}_$1"
    fi
    
}

function deploy () {
    sam deploy \
        --template-file template.yaml \
        --capabilities CAPABILITY_NAMED_IAM \
    --parameter-overrides \
        EnvironmentName=${ENVIRONMENT_NAME} \
        CategoryName=${CATEGORY_NAME} \
        AppName=${APP_NAME} \
        Region=${REGION} \
    --stack-name ${ENVIRONMENT_NAME}-${CATEGORY_NAME}-${APP_NAME}-${REGION} \
    --region ${DEPLOY_PROFILE} \
    --profile default
}


init