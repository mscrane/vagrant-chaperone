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

#from http://stackoverflow.com/questions/5014632/how-can-i-parse-a-yaml-file-from-a-linux-shell-script
parse_yaml() {
   local prefix=$2
   local s='[[:space:]]*' w='[a-zA-Z0-9_]*' fs=$(echo @|tr @ '\034')
   sed -ne "s|^\($s\):|\1|" \
        -e "s|^\($s\)\($w\)$s:$s[\"']\(.*\)[\"']$s\$|\1$fs\2$fs\3|p" \
        -e "s|^\($s\)\($w\)$s:$s\(.*\)$s\$|\1$fs\2$fs\3|p"  $1 |
   awk -F$fs '{
      indent = length($1)/2;
      vname[indent] = $2;
      for (i in vname) {if (i > indent) {delete vname[i]}}
      if (length($3) > 0) {
         vn=""; for (i=0; i<indent; i++) {vn=(vn)(vname[i])("_")}
         printf("%s%s%s=\"%s\"\n", "'$prefix'",vn, $2, $3);
      }
   }'
}
#from http://www.linuxjournal.com/content/validating-ip-address-bash-script
valid_ip () {
  local  ip=$1
  local  stat=1

  if [[ $ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
      OIFS=$IFS
      IFS='.'
      ip=($ip)
      IFS=$OIFS
      [[ ${ip[0]} -le 255 && ${ip[1]} -le 255 \
          && ${ip[2]} -le 255 && ${ip[3]} -le 255 ]]
      stat=$?
  fi
  return $stat
}

set_chaperone_env() {
  local state=1
  local config_file=$1


  [[ -e ${config_file} ]] || fail_script "Config File Not Present" 1
  [[ -s ${config_file} ]] || fail_script "Config File Empty" 1

  env_vars=$(parse_yaml ${config_file})

  for var in ${env_vars[@]}; do
    var_name=$(echo ${var} | awk -F'=' '{print $1}')
    var_val=$(echo ${var} | awk -F'=' '{print $2}')

    if [[ ! -z ${var_name} ]]; then
      [[ "$var_name" != "CHAP_GUEST_IP" ]] && export $var && echo "EXPORTED: ${var}"
    fi

    if [[ ! -z ${var_name} ]] && [[ "$var_name" = "CHAP_GUEST_IP" ]]; then
      tmp=$(echo ${var_val} | awk -F'["="]' '{print $2}')
      valid_ip $tmp && export $var && echo "EXPORTED: ${var}"
    fi

  done
}

set_chap_env() {

  local chaperone_ip_address=${1}
  local chaperone_hostname=${2}
  local chaperone_admin_port=${3}
  local chaperone_project_port=${4}

  export CHAP_GUEST_IP=${chaperone_ip_address}
  export CHAP_VM_NAME=${chaperone_hostname}
  export CHAP_HOST_ADMIN_PORT=${chaperone_admin_port}
  export CHAP_HOST_PROJECT_PORT=${chaperone_project_port}

}

echo "--- Setting up Environment for Vagrant Chapeorne ---"
unset CHAP_GUEST_IP
unset CHAP_VM_NAME
unset CHAP_HOST_ADMIN_PORT
unset CHAP_HOST_PROJECT_PORT
#chaperone_setup_config_file='chaperone_config.yml'
#set_chaperone_env ${chaperone_setup_config_file}

set_chap_env
