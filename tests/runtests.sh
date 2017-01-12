#!/bin/bash

# runtests.sh
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


IMAGE=$1
LOCAL_WDIR=$(pwd)/wdir
if [ -e ${LOCAL_WDIR} ]; then
    echo "Cowardly refusing to overwrite $LOCAL_WDIR"
    exit -1
fi
for i in run-*.sh; do
    echo Running Test $i
    rm -rf $LOCAL_WDIR
    mkdir -p $LOCAL_WDIR
    cp $i $LOCAL_WDIR
    docker run -it --rm  -v $LOCAL_WDIR:/workdir $IMAGE --workdir=/workdir --cmd="/workdir/$i"
    RET=$?
    if [ ${RET} != 0 ]; then
	exit ${RET}
    fi
done
echo "All tests PASSED"
rm $LOCAL_WDIR -rf
