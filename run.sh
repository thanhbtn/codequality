#!/bin/sh

usage="$(basename "$0") [-h] <app_path>

where:
    -h  show this help text
    app_path The path to the source code of the project you want to analyze."

while getopts 'h' option; do
  case "$option" in
    h) echo "$usage"
       exit
       ;;
    :) printf "missing argument for -%s\n" "$OPTARG" >&2
       echo "$usage" >&2
       exit 1
       ;;
   \?) printf "illegal option: -%s\n" "$OPTARG" >&2
       echo "$usage" >&2
       exit 1
       ;;
  esac
done
shift $((OPTIND - 1))

if [ $# -ne 1 ] ; then
  echo "$usage"
  exit
fi

APP_PATH=$1
CODECLIMATE_VERSION=${CODECLIMATE_VERSION:-0.71.1}

# Run the code climate container.
# SOURCE_CODE env variable must be provided when launching this script. It allow
# code climate engines to mount the source code dir into their own container.
docker run \
    --env CODECLIMATE_CODE="$SOURCE_CODE" \
    --volume "$SOURCE_CODE":/code \
    --volume /tmp/cc:/tmp/cc \
    --volume /var/run/docker.sock:/var/run/docker.sock \
    "codeclimate/codeclimate:$CODECLIMATE_VERSION" analyze -f json > /tmp/raw_codeclimate.json

if [ $? -ne 0 ]; then
    echo "Could not analyze code quality for the repository at $APP_PATH"
    exit 1
fi

# Only keep "issue" type
jq -c 'map(select(.type == "issue"))' /tmp/raw_codeclimate.json > "$APP_PATH/codeclimate.json"
