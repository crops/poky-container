#!/bin/bash

# run-workdir-check.sh
#
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
# 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.

# This verifies that the workdir is what we expect it to be.

if [ "$(pwd)" != "/workdir" ] ; then
    printf "expected workdir not found\n"
    printf "expected:\n%s\n" "/workdir"
    printf "actual:\n%s\n" "$(pwd)"
    exit 1
fi
