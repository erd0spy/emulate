#!/bin/bash

set -euo pipefail

# Install dependencies
FIRMADYNE_DEPS="qemu-system-arm qemu-system-mips qemu-system-x86 qemu-utils busybox-static fakeroot kpartx snmp uml-utilities util-linux vlan python3 python3-dev python3-pip git"
sudo apt update
sudo apt install -y ${FIRMADYNE_DEPS} zip unzip rar unrar lsb-core wget curl tar binwalk

# Install Firmadyne
git clone --recursive https://github.com/firmadyne/firmadyne.git
cd firmadyne
./download.sh
firmadyne_dir=$(realpath .)

# Set FIRMWARE_DIR in firmadyne.config
sed -i "s|^#FIRMWARE_DIR=.*|FIRMWARE_DIR=${firmadyne_dir}|" firmadyne.config

# Comment out psql -d firmware ... in getArch.sh
sed -i 's/psql/#psql/' scripts/getArch.sh

# Fix
touch images/0.tar.gz

# Change interpreter to python3
sed -i 's/env python/env python3/' sources/extractor/extractor.py scripts/makeNetwork.py
cd ..

# Make emulate.sh executable
chmod +x emulate.sh
