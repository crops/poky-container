#!/bin/bash

# run-build.sh
#
# Copyright (C) 2016 Intel Corporation
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License version 2 as
# published by the Free Software Foundation.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along
# with this program; if not, write to the Free Software Foundation, Inc.,
# 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.

# do the build in the /workdir. Make it a temp directory as that
# allows us to have a more stressful test
BUILD_DIR=$(mktemp -d -p /workdir build_XXXXX)

failure () {
    echo "$0 Failed"
    echo "Failed build located in ${BUILD_DIR}"
    exit -1
}

git clone  git://git.yoctoproject.org/poky

. ./poky/oe-init-build-env $BUILD_DIR

bitbake quilt-native
# did bitbake run happily?
if [ $? -ne 0 ]; then
    failure
fi
# check some artifacts
STATDIR=`find tmp/buildstats/ -iname quilt-native* -type d`
for f in `ls $STATDIR`; do
    echo checking $f
    if ! grep PASSED $STATDIR/$f | egrep Status; then
	failure
    fi
done
# delete the build dir on success.
rm $BUILD_DIR -rf
