#!/bin/bash
# Copyright (C) 2019 Intel Corporation
# Copyright (C) 2022 Konsulko Group
#
# SPDX-License-Identifier: GPL-2.0-only

RELEASE="4.1"

# This entry point is so that we can do distro specific changes to the launch.
if [ "$(uname -m)" = "aarch64" ]; then
    SETUPSCRIPT="environment-setup-aarch64-pokysdk-linux"
elif [ "$(uname -m)" = "x86_64" ]; then
    SETUPSCRIPT="environment-setup-x86_64-pokysdk-linux"
fi

# This entry point is so that we can do distro specific changes to the launch.
if [ -e /opt/poky/${RELEASE}/${SETUPSCRIPT} ]; then
    # Buildtools has been installed so enable it
    . /opt/poky/${RELEASE}/${SETUPSCRIPT} || exit 1
elif [ -e /opt/poky/${RELEASE}/${SETUPSCRIPT} ]; then
    # Buildtools(-make) has been installed so enable it
    . /opt/poky/${RELEASE}/${SETUPSCRIPT} || exit 1
fi

exec "$@"
