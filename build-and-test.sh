#!/bin/bash
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
#
set -e

DOCKERFILE=`mktemp -p . Dockerfile.XXX`

sed -e "s#FROM crops/yocto:ubuntu-16.04#FROM crops/yocto:${BASE_DISTRO}#" Dockerfile > $DOCKERFILE
docker build --pull -f $DOCKERFILE -t ${REPO}:${BASE_DISTRO} .

if command -v annotate-output; then
    ANNOTATE_OUTPUT=annotate-output
fi
$ANNOTATE_OUTPUT bash -c "cd tests; ./runtests.sh ${REPO}:${BASE_DISTRO}"

rm -f $DOCKERFILE
