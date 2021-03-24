#**********************************************************************************#
# Copyright by @bkozdras <b.kozdras@gmail.com>                                     #
# Version: 1.0                                                                     #
# Licence: MIT                                                                     #
#**********************************************************************************#

#!/bin/bash

if ! make --version &> /dev/null
then
    echo "Make is not found!"
    exit -1
fi

THIS_DIR_NAME=${PWD##*/}
if [ "$THIS_DIR_NAME" != "buildCI" ]
then
    echo "ERROR: CI pipeline issue! This script (runMake.sh) should be executed from buildCI directory!"
    echo "This directory: $THIS_DIR_NAME"
    exit -1
fi

make -j$(nproc --all)

exit 0
