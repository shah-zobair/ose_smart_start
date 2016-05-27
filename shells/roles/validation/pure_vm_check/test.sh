#!/bin/bash
#
#  Author: Jooho Lee(ljhiyh@gmail.com)
#    Date: 2016.05.25
# Purpose: Check whether VMs are ready to install
#          Validate DNS / Validate yum repolist / Validate docker storage / Validate persistent volume


# Included scripts:
#
#  - validation_dns_lookup.sh
#   Description :
#       In order to install openshift, all VMs hostname/lb should be resovled by DNS (wildcard${subdomain} is optional)
#       This script check DNS entries.       
#   Execute Host: 
#        All VMs

#  - validation_yum_repolist.sh
#   Description :
#       In order to install openshift, rhel7, rhel7 extra, ose3 repositories should be attached to all VMs.
#       This script check YUM repositories.       
#   Execute Host: 
#        All VMs

#  - validation_docker_storage.sh
#   Description :
#       Using docker storage is strongly recommended so this script check it is already configured or not. However it is not mandatory.
#   Execute Host: 
#        All VMs

#  - validation_persistent_vol.sh
#   Description :
#       This script check NFS server connectivity and GUID for using PV
#   Execute Host: 
#        All VMs

. $CONFIG_PATH/ose_config.sh
cd $HOME_PATH/; cd ..
tar cvf ./ose_smart_start.tar ./ose_smart_start
for HOST in `grep -v \# $CONFIG_PATH/$host_file | awk '{ print $1 }'`;
do

  scp ~/.bashrc  oseadmin@${HOST}:
  scp ~/.bash_profile  oseadmin@${HOST}:

  ssh -q oseadmin@${HOST} "mkdir -p ${ose_temp_dir}/ose_smart_start"
  scp ./ose_smart_start.tar oseadmin@${HOST}:${ose_temp_dir}/.
  ssh -t -q oseadmin@${HOST} "tar xvf ${ose_temp_dir}/ose_smart_start.tar -C  ${ose_temp_dir}"
  ssh -t -q oseadmin@${HOST} "echo \"export HOME_PATH=${ose_temp_dir}/ose_smart_start\" >> ~/.bashrc"
  ssh -t -q oseadmin@${HOST} "echo \"export ANSIBLE_PATH=${ose_temp_dir}/ose_smart_start/ansible \" >> ~/.bashrc"
  ssh -t -q oseadmin@${HOST} "echo \"export CONFIG_PATH=${ose_temp_dir}/ose_smart_start/shells/config \" >> ~/.bashrc"
done
