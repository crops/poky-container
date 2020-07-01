#!/bin/bash

# distro-check.sh
#
# Copyright (C) 2020 Intel Corporation
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

# Verify that the distro inside the container matches the one we expect based
# on the build

ENGINE_CMD=$1
IMAGE=$2
BASE_DISTRO="$3"

declare -A distros

distros["centos-7"]="CentOS Linux 7 (Core)"
distros["debian-9"]="Debian GNU/Linux 9 (stretch)"
distros["debian-10"]="Debian GNU/Linux 10 (buster)"
distros["fedora-31"]="Fedora 31 (Container Image)"
distros["fedora-32"]="Fedora 32 (Container Image)"
distros["opensuse-15.1"]="openSUSE Leap 15.1"
distros["ubuntu-16.04"]="Ubuntu 16.04"
distros["ubuntu-18.04"]="Ubuntu 18.04"
distros["ubuntu-20.04"]="Ubuntu 20.04"

# If the distro is unknown it is a failure
if [ "${distros[${BASE_DISTRO}]}" = "" ]; then
    echo "Unknown distro \"${BASE_DISTRO}\""
    exit 1
fi

${ENGINE_CMD} run --rm -t $IMAGE grep "${distros[${BASE_DISTRO}]}" /etc/os-release &> /dev/null
RET=$?
if [ $RET != 0 ]; then
    echo "Distro check failed. Outputting /etc/os-release:"
    ${ENGINE_CMD} run --rm -t $IMAGE cat /etc/os-release
    echo ""
fi
exit $RET
