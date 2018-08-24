#!/bin/bash

# run-dumb-init-check.sh
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

# This verifies that dumb-init is running as the correct user and is running
# what we expected.

username="usersetup"
username_width=${#username}
expected='1 usersetup /usr/bin/dumb-init -- /usr/bin/poky-entry.py /workdir/run-dumb-init-check.sh'
actual=`ps -w -w h -C dumb-init -o pid:1,user:$username_width,args`

if [ "$expected" != "$actual" ]; then
    printf "expected dumb-init not found\n"
    printf "expected:\n%s\n" "$expected"
    printf "actual:\n%s\n" "$actual"
    printf "all:\n"
    ps -w -w -A -o pid,user:$username_width,args
    exit 1
fi

if [ "$(pwd)" != "/workdir" ] ; then
    printf "expected workdir not found\n"
    printf "expected:\n%s\n" "/workdir"
    printf "actual:\n%s\n" "$(pwd)"
    exit 1
fi
