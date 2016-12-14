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
workdir=$1
cd $workdir
# start the vnc server if the user account is set up for it.
if [ -d $HOME/.vnc ]; then
    echo "starting vncserver..."
    vncserver -rfbport 5900  -name POKY $DISPLAY > /dev/null 2>&1
fi
exec bash -i
