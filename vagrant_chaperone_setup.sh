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

  local project_directory=${1}
  local chaperone_ip_address=${2}

  export CHAP_LOCAL_REPO=${project_directory}
  export CHAP_GUEST_IP=${chaperone_ip_address}
  export CHAP_VM_NAME="chaperone-ui.corp.local"
  export CHAP_HOST_ADMIN_PORT=8181
  export CHAP_HOST_PROJECT_PORT=8811

}

project_dir=${1}
chaperone_ip_address=${2}

set_chap_env ${project_dir} ${chaperone_ip_address} || fail_script "Failed to set CHAP ENV" 1
