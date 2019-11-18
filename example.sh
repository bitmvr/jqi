#!/usr/bin/env bash

# Source jqi and install

if ! command -v jq; then
  source ./jqi.sh
  jqi::installjq
  JQI_IN_USE="TRUE"
fi

test_json='{"name":"John", "age":31, "city":"New York"}'

echo "jq location: $(command -v jq)"
echo "Test JSON string: $test_json"
echo "Value for Name: $(jq -r '.name' < <(echo "$test_json"))"
echo "Value for Age: $(jq -r '.age' < <(echo "$test_json"))"
echo "Value for City: $(jq -r '.city' < <(echo "$test_json"))"
echo ""

# Safely Perform A Cleanup
if [ -n "$JQI_IN_USE" ]; then
  jqi::cleanup
fi

