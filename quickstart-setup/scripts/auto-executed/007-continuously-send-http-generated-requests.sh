#!/bin/bash -e

cd "$(dirname "$0")"

function runRequestSending() {
  if [ "$#" -ne 2 ]; then
    echo "Error: Two parameters required: 1) OpenAPI service slug, 2) request generator script"
    exit 11
  fi

  set -e

  local OPENAPI_SERVICE_SLUG=$1
  local REQUEST_GENERATOR_SCRIPT=$2

  echo "Starting to send to '$OPENAPI_SERVICE_SLUG' OpenAPI service, requests generated by '$REQUEST_GENERATOR_SCRIPT' generator script"

  mkdir -p /var/log/continuously-send-http-requests
  nohup ../utils/http/continuously-send-http-requests.sh "$OPENAPI_SERVICE_SLUG" "$REQUEST_GENERATOR_SCRIPT" > /var/log/continuously-send-http-requests/output.log 2>&1 &
}

echo "Starting to send generated requests to Nu OpenAPI services ..."

while IFS= read -r OPENAPI_SERVICE_SLUG; do

  if [[ $OPENAPI_SERVICE_SLUG == "#"* ]]; then
    continue
  fi

  REQUEST_GENERATOR_SCRIPT=$(find ../../data/http/generate-requests -iname "$OPENAPI_SERVICE_SLUG.sh" | head)

  if [[ -f "$REQUEST_GENERATOR_SCRIPT" ]]; then
    runRequestSending "$OPENAPI_SERVICE_SLUG" "$(realpath $REQUEST_GENERATOR_SCRIPT)"
  fi

done < "../../data/http/slugs.txt"

echo -e "DONE!\n\n"