#!/bin/bash

fail_script() {
  local fail_message="$1"
  local fail_code="$2"

  echo -n "ERROR: "
  if [ -z "$fail_message" ]; then
    echo "Generic script failure."
  else
    echo "$fail_message"
  fi
 
  if [ -z "$fail_code" ]; then
    fail_code=1
  fi
  exit $fail_code
}

set_chap_env() {
  export CHAP_USE_PROXY='false'
  export CHAP_LOCAL_REPO="/Users/jdupuy/bin/projects/05"
  export CHAP_GUEST_IP="192.168.110.10"
  export CHAP_VM_NAME="chaperone.dev"
  export CHAP_HOST_ADMIN_PORT=8181
  export CHAP_HOST_PROJECT_PORT=8811
}

set_chap_env || fail_script "Failed to set CHAP ENV" 1
