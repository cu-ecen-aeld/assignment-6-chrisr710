#!/bin/bash
# Script to build image for qemu.
# Author: Siddhant Jajoo.

git submodule init
git submodule sync
git submodule update

# local.conf won't exist until this step on first execution
source poky/oe-init-build-env

CONFLINE="MACHINE = \"qemuarm64\""

cat conf/local.conf | grep "${CONFLINE}" > /dev/null
local_conf_info=$?

if [ $local_conf_info -ne 0 ];then
	echo "Append ${CONFLINE} in the local.conf file"
	echo ${CONFLINE} >> conf/local.conf
	
else
	echo "${CONFLINE} already exists in the local.conf file"
fi

cat conf/local.conf | grep 'CORE_IMAGE_EXTRA_INSTALL += "aesd-assignments_git"' >> /dev/null
extra=$?

if [ $extra -ne 0 ];then
	echo "Append SOCKET RECIPE in the local.conf file"
        echo 'CORE_IMAGE_EXTRA_INSTALL += "aesd-assignments_git"' >> conf/local.conf
fi

	
        
        


	
bitbake-layers show-layers | grep "meta-aesd" > /dev/null
layer_info=$?

if [ $layer_info -ne 0 ];then
	echo "Adding meta-aesd layer"
	bitbake-layers add-layer ../meta-aesd
else
	echo "meta-aesd layer already exists"
fi
#
set -e
bitbake core-image-aesd
