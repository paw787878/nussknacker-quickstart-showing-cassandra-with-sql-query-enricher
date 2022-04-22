#!/usr/bin/env bash

set -e

cd "$(dirname $0)"
export BASE_PATH=`pwd`
export ADDITIONAL_COMPOSE_FILE="-f $(realpath ./docker-compose-streaming.yml)"
export DEFAULT_SCENARIO_TYPE=streaming

../common/invokeDocker.sh pull 
../common/invokeDocker.sh up -d
