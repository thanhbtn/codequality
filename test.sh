#!/bin/sh

# Make it TAP compliant, see http://testanything.org/tap-specification.html
echo "1..3"

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
DEFAULT_FILES_PATH="$PWD/codeclimate_defaults" SOURCE_CODE=$fixtures_path ./run.sh $fixtures_path

if test $? -eq 0 && diff $got $expect; then
  echo "ok $step - $desc"
else
  echo "not ok $step - $desc"
  failed=$((failed+1))
fi
step=$((step+1))
echo

# with defined REPORT_STDOUT
desc="Send expected output to STDOUT"
alias viaout="REPORT_STDOUT=1 DEFAULT_FILES_PATH=\"$PWD/codeclimate_defaults\" SOURCE_CODE=$fixtures_path ./run.sh $fixtures_path"

if test $? -eq 0 && viaout | diff - $expect; then
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
