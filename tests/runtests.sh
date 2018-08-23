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

for i in run-*.sh; do
    echo Running Test $i
    # make temporary workdir
    LOCAL_WDIR=$(mktemp -d  wdir_XXXXX)
    # get absolute path to it
    LOCAL_WDIR=$(readlink -f ${LOCAL_WDIR})
    cp $i $LOCAL_WDIR
    docker run --rm -t -v $LOCAL_WDIR:/workdir:Z $IMAGE \
	--workdir=/workdir --cmd="/workdir/$i"
    RET=$?
    if [ ${RET} != 0 ]; then
	echo "Test $i failed"
	echo "Workdir located in $LOCAL_WDIR"
	exit ${RET}
    fi
    rm $LOCAL_WDIR -rf
done
echo "All tests PASSED"
