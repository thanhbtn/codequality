#!/bin/sh

# Make it TAP compliant, see http://testanything.org/tap-specification.html
echo "1..2"

failed=0
step=1

got="test/fixtures/gl-code-quality-report.json"
expect="test/expect/gl-code-quality-report.json"
fixtures_path="$PWD/test/fixtures/"

# Missing SOURCE_CODE env var
desc="Exit with error message"
err=$(./run.sh ./test/fixtures)

if [ "$err" == "SOURCE_CODE env variable not set" ]; then
  echo "ok $step - $desc"
else
  echo "not ok $step - $desc"
  failed=$((failed+1))
fi
step=$((step+1))
echo

# Normal execution
desc="Generate expected output"
rm -f $got
docker build -t codequality:test .
docker run \
  --env SOURCE_CODE="$fixtures_path" \
  --volume "$fixtures_path":/code \
  --volume /var/run/docker.sock:/var/run/docker.sock \
  --volume /tmp/cc:/tmp/cc \
  codequality:test /code

if test $? -eq 0 && diff $got $expect; then
  echo "ok $step - $desc"
else
  echo "not ok $step - $desc"
  failed=$((failed+1))
fi
step=$((step+1))
echo

# Finish tests
count=$((step-1))
if [ $failed -ne 0 ]; then
  echo "Failed $failed/$count tests"
  exit 1
else
  echo "Passed $count tests"
fi

