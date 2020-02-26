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
# Allow the user to specify another command to use for building such as podman.
if [ "${ENGINE_CMD}" = "" ]; then
    ENGINE_CMD="docker"
fi

IMAGE=$1

for i in run-*.sh; do
    echo Running Test $i
    # make temporary workdir
    LOCAL_WDIR=$(mktemp -d  wdir_XXXXX)
    # get absolute path to it
    LOCAL_WDIR=$(readlink -f ${LOCAL_WDIR})
    cp $i $LOCAL_WDIR

    # This is to make sure the workdir is correct when using either docker
    # or the entrypoint workdir argument.
    if [ "$i" == "run-workdir-check.sh" ]; then
	# For passing the workdir to docker, use chmod to ensure that docker
	# will have permission to access the directory
	chmod o+x $LOCAL_WDIR
	${ENGINE_CMD} run --rm -t -v $LOCAL_WDIR:/workdir \
	    --workdir /workdir \
	    $IMAGE \
	    /workdir/$i &&
	${ENGINE_CMD} run --rm -t -v $LOCAL_WDIR:/workdir \
	    $IMAGE \
	    --workdir /workdir \
	    /workdir/$i
    else
	${ENGINE_CMD} run --rm -t -v $LOCAL_WDIR:/workdir \
	    $IMAGE \
	    --workdir /workdir \
	    /workdir/$i
    fi
    RET=$?
    if [ ${RET} != 0 ]; then
	echo "Test $i failed"
	echo "Workdir located in $LOCAL_WDIR"
	exit ${RET}
    fi
    rm $LOCAL_WDIR -rf
done

# Verify that each argument is preserved as expected
echo Running Argument Test
# make temporary workdir
LOCAL_WDIR=$(mktemp -d  wdir_XXXXX)
# get absolute path to it
LOCAL_WDIR=$(readlink -f ${LOCAL_WDIR})
cp check_args.py $LOCAL_WDIR

${ENGINE_CMD} run --rm -t -v $LOCAL_WDIR:/workdir \
    $IMAGE \
    --workdir /workdir \
    python /workdir/check_args.py \
    arg1 "second argument passed" "third arg" arg4 "this is the last argument"

RET=$?
if [ ${RET} != 0 ]; then
    echo "Test \"Argument Test\" failed"
    echo "Workdir located in $LOCAL_WDIR"
    exit ${RET}
fi
rm $LOCAL_WDIR -rf

# Verify that the PATH is preserved
echo Running PATH Test
# make temporary workdir
LOCAL_WDIR=$(mktemp -d  wdir_XXXXX)
# get absolute path to it
LOCAL_WDIR=$(readlink -f ${LOCAL_WDIR})
cp check-path.sh $LOCAL_WDIR

${ENGINE_CMD} run --rm -t -v $LOCAL_WDIR:/workdir --user=root \
    --entrypoint="/workdir/check-path.sh" \
    $IMAGE

RET=$?
if [ ${RET} != 0 ]; then
    echo "Test \"PATH Test\" failed"
    echo "Workdir located in $LOCAL_WDIR"
    exit ${RET}
fi
rm $LOCAL_WDIR -rf


echo Running Distro Check Test
./distro-check.sh ${ENGINE_CMD} ${IMAGE} ${BASE_DISTRO}
RET=$?
if [ ${RET} != 0 ]; then
    echo "Test \"Distro Check\" failed"
    exit ${RET}
fi

echo "All tests PASSED"
