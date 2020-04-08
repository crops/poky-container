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
if grep -q CentOS /etc/*release; then
    # This is so that tar >= 1.28 can be used, which is required to pass the
    # sanity checks as of poky commit 2c7624c17e43f9215cf7dcebf7258d28711bc3ce.
    . /opt/poky/3.0/environment-setup-x86_64-pokysdk-linux || exit 1

    # This is so that a gcc >= 5.0 will be used
    . scl_source enable devtoolset-8 || exit 1
fi

exec "$@"
