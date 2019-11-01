#!/bin/bash

# check-path.sh
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

# Make sure the path is preserved across sudo for usersetup.

# usersetup only has permission to run certain commands without a password, so
# create a script that does the "test" as /usr/bin/poky-launch.sh 
cat << EOF > /usr/bin/poky-launch.sh
#!/bin/bash
if ! echo "\$PATH" | grep -q -E ":bar:baz:cow$"; then
    echo \$PATH
    exit 1
fi
EOF

useradd -m pokyuser

sudo -E -u usersetup bash -c 'export PATH="$PATH":bar:baz:cow && /usr/bin/sudo -E -H -u pokyuser /usr/bin/poky-launch.sh'
