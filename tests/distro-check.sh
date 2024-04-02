#!/bin/bash

# distro-check.sh
#
# Copyright (C) 2020 Intel Corporation
# Copyright (C) 2024 Konsulko Group
#
# SPDX-License-Identifier: GPL-2.0-only
#
# Verify that the distro inside the container matches the one we expect based
# on the build

ENGINE_CMD=$1
IMAGE=$2
BASE_DISTRO="$3"

declare -A distros

distros["alma-8"]="AlmaLinux 8"
distros["alma-9"]="AlmaLinux 9"
distros["centos-7"]="CentOS Linux 7 (Core)"
distros["debian-9"]="Debian GNU/Linux 9 (stretch)"
distros["debian-10"]="Debian GNU/Linux 10 (buster)"
distros["debian-11"]="Debian GNU/Linux 11 (bullseye)"
distros["debian-12"]="Debian GNU/Linux 12 (bookworm)"
distros["fedora-36"]="Fedora Linux 36 (Container Image)"
distros["fedora-37"]="Fedora Linux 37 (Container Image)"
distros["fedora-38"]="Fedora Linux 38 (Container Image)"
distros["fedora-39"]="Fedora Linux 39 (Container Image)"
distros["fedora-40"]="Fedora Linux 40 (Container Image Prerelease)"
distros["opensuse-15.4"]="openSUSE Leap 15.4"
distros["opensuse-15.5"]="openSUSE Leap 15.5"
distros["ubuntu-18.04"]="Ubuntu 18.04"
distros["ubuntu-20.04"]="Ubuntu 20.04"
distros["ubuntu-22.04"]="Ubuntu 22.04"

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
