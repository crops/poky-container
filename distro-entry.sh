#!/bin/bash
# Copyright (C) 2019 Intel Corporation
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

# This entry point is so that we can do distro specific changes to the launch.
if [ "$(uname -m)" = "aarch64" ]; then
    SETUPSCRIPT="environment-setup-aarch64-pokysdk-linux"
elif [ "$(uname -m)" = "x86_64" ]; then
    SETUPSCRIPT="environment-setup-x86_64-pokysdk-linux"
fi

# This entry point is so that we can do distro specific changes to the launch.
if [ -e /opt/poky/3.1.13/${SETUPSCRIPT} ]; then
    # Buildtools has been installed so enable it
    . /opt/poky/3.1.13/${SETUPSCRIPT} || exit 1
fi

exec "$@"
