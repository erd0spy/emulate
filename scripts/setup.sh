#!/bin/bash

set -euo pipefail

# Install dependencies
BINWALK_DEPS="git python3 python3-dev python3-pip python3-pexpect"
FIRMADYNE_DEPS="qemu-system-arm qemu-system-mips qemu-system-x86 qemu-utils busybox-static fakeroot kpartx snmp uml-utilities util-linux vlan"
sudo apt update
sudo apt install -y ${BINWALK_DEPS} ${FIRMADYNE_DEPS} zip unzip rar unrar lsb-core wget curl tar

# Install Binwalk
git clone --depth=1 https://github.com/erd0spy/binwalk/ # fixed version for Ubuntu 20.04+
cd binwalk

./deps.sh --yes
sudo python3 ./setup.py install
sudo -H pip3 install git+https://github.com/ahupp/python-magic
sudo -H pip3 install git+https://github.com/sviehb/jefferson
cd ..

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
