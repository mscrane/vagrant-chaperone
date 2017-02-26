#!/bin/bash

### Set CHAP_* ENV variables
#
set_chap_env() {
  export CHAP_USE_PROXY='false'
  export CHAP_LOCAL_REPO="/Users/jdupuy/bin/projects/05"
  export CHAP_GUEST_IP="192.168.110.10"
  export CHAP_VM_NAME="chaperone.dev"
  export CHAP_HOST_ADMIN_PORT=8181
  export CHAP_HOST_PROJECT_PORT=8811
}

set_chap_env
