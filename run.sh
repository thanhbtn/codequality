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
DEFAULT_FILES_PATH=${DEFAULT_FILES_PATH:-/codeclimate_defaults}
CODECLIMATE_VERSION=${CODECLIMATE_VERSION:-0.71.2}
CONTAINER_TIMEOUT_SECONDS=${TIMEOUT_SECONDS:-900} # default to 15 min

if [ -z "$SOURCE_CODE" ] ; then
  echo "SOURCE_CODE env variable not set"
  exit
fi

# Copy default config files unless already present for csslint, eslint (ignore), rubocop and coffeelint
for config_file in .csslintrc .eslintignore .rubocop.yml coffeelint.json; do
  if [ ! -f  $APP_PATH/$config_file ] ; then
    cp $DEFAULT_FILES_PATH/$config_file $APP_PATH/
  fi
done

# Copy default config file unless already present for code climate
# NB: check for all supported config files
if ! [ -f  $APP_PATH/.codeclimate.yml -o -f $APP_PATH/.codeclimate.json ] ; then
  cp $DEFAULT_FILES_PATH/.codeclimate.yml $APP_PATH/
fi

# Copy default config file unless already present for eslint
# NB: check for all supported config files
if ! [ -f  $APP_PATH/.eslintrc.js -o -f $APP_PATH/.eslintrc.yaml -o -f $APP_PATH/.eslintrc.yml -o -f $APP_PATH/.eslintrc.json -o -f $APP_PATH/.eslintrc ] ; then
  cp $DEFAULT_FILES_PATH/.eslintrc.yml $APP_PATH/
fi

# Run the code climate container.
# SOURCE_CODE env variable must be provided when launching this script. It allow
# code climate engines to mount the source code dir into their own container.
# TIMEOUT_SECONDS env variable is optional. It allows you to increase the timeout
# window for the analyze command.
docker run \
    --env CODECLIMATE_CODE="$SOURCE_CODE" \
    --env CONTAINER_TIMEOUT_SECONDS=$CONTAINER_TIMEOUT_SECONDS \
    --volume "$SOURCE_CODE":/code \
    --volume /tmp/cc:/tmp/cc \
    --volume /var/run/docker.sock:/var/run/docker.sock \
    "codeclimate/codeclimate:$CODECLIMATE_VERSION" analyze -f json > /tmp/raw_codeclimate.json

if [ $? -ne 0 ]; then
    echo "Could not analyze code quality for the repository at $APP_PATH"
    exit 1
fi

# Only keep "issue" type
jq -c 'map(select(.type | test("issue"; "i")))' /tmp/raw_codeclimate.json > "$APP_PATH/codeclimate.json"
