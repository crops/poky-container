#!/bin/bash
# Copyright (C) 2019 Intel Corporation
# Copyright (C) 2022 Konsulko Group
#
# SPDX-License-Identifier: GPL-2.0-only

ARCH="$(uname -m)"

# Search the environment setup script with the higher version number
SETUPSCRIPT="$(find /opt/poky -type f -name environment-setup-${ARCH}-pokysdk-linux 2>/dev/null | sort -r | head -n 1)"

# This entry point is so that we can do distro specific changes to the launch.
if [ ! -z "${SETUPSCRIPT}" ]; then
    # Buildtools has been installed so enable it
    . ${SETUPSCRIPT} || exit 1
fi

exec "$@"
